package com.mike.website3.pages.internal;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 *
 *
 */

import com.mike.util.Log;
import com.mike.util.Util;
import com.mike.website3.Constants;
import com.mike.website3.MySessionState;
import com.mike.website3.SendGrid.SendGrid;
import com.mike.website3.Website;
import com.mike.website3.dataAnalysis.UserCharts;
import com.mike.website3.db.Stripe.StripeCustomer;
import com.mike.website3.db.SystemEvent;
import com.mike.website3.db.User;
import com.mike.website3.db.UserRole;
import com.mike.website3.pages.BaseController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UsersController extends BaseController {
    private static final String TAG = UsersController.class.getSimpleName();

    // dead end for a user attempting to login to a pending account
    @RequestMapping(value = "/pending-account", method = RequestMethod.GET)
    public String get(HttpServletRequest request, Model model, HttpServletResponse response) {
        return super.get(request, model, "pending-account");
    }

    // this gets redirected to a user's mini-website
    //
    @RequestMapping(value = "/users/{user}/{resource}/**", method = RequestMethod.GET)
    public void get2(@PathVariable("user") String user,
                     @PathVariable("resource") String resource,
                     HttpServletRequest request, Model model, HttpServletResponse response) {
        assert request != null;
        assert response != null;

        String requestURI = request.getRequestURI();
        String s = requestURI.replace("/users/", "");
        s = s.replace(user, "");
        File userDir = Website.getUserDir(user);
        File thing = new File(userDir, s);
        if (thing.exists()) {

            Path path = thing.toPath();
            try {
                Files.copy(path, response.getOutputStream());
                response.flushBuffer();
            } catch (IOException ex) {
                Log.e(TAG, String.format("Error copying file %s to response", path.toString()));
            }
        }
    }

    // this gets redirected to the MilkRun static pages which live
    // in milkrunFiles/milkrun/

    @RequestMapping(value = "/milkrun/{resource}/**", method = RequestMethod.GET)
    public void get2a(@PathVariable("resource") String resource,
                     HttpServletRequest request, Model model, HttpServletResponse response) {

        String requestURI = request.getRequestURI();
        String s = requestURI.replace("/milkrun/", "");
        File milkrunStaticFilesDir = new File(Website.getMilkRunFilesDir(), "milkrun");
        File thing = new File(milkrunStaticFilesDir, s);
        if (thing.exists()) {

            Path path = thing.toPath();
            try {
                Files.copy(path, response.getOutputStream());
                response.flushBuffer();
            } catch (IOException ex) {
                Log.e(TAG, String.format("Error copying file %s to response", path.toString()));
            }
        }
    }

    // present a list of pending accounts

    @RequestMapping(value = "/pending-accounts", method = RequestMethod.GET)
    public String get1(HttpServletRequest request, Model model, HttpServletResponse response) {
        try {
            MySessionState state = getSessionState(request);
            User user = state.getUser();
            if ((user == null) | (!user.isAnAdmin()))
                return showErrorPage("Unauthorized Access", request, model);

            boolean showDisabled = state.getAttributeB("showDisabledUsers");
            model.addAttribute("pendingUsers", User.findPending(showDisabled));
            return super.get(request, model, "pending-accounts");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

    // update a pending account
    @RequestMapping(value = "/pending-accounts", method = RequestMethod.POST)
    public String post(HttpServletRequest request, Model model) {

        MySessionState state = getSessionState(request);
        String nextPage = "pending-accounts";
        try {
            User adminUser = getSessionUser(request);
            if ((adminUser == null) | (!adminUser.isAnAdmin()))
                return showErrorPage("Unauthorized Access", request, model);

            switch (request.getParameter("operation")) {
                case "update": {
                    String[] usernames = request.getParameterMap().get("username");
                    for (String username : usernames) {
                        User user = User.findByUsername(username);

                        if (request.getParameter("pending-" + username) == null) {
                            // allow this user into the system
                            UserRole.remove(user.getUsername(), UserRole.Role.AccountPending);

                            if (request.getParameter("new-user-email-" + username) != null) {
                                user.sendNewUserLoginEmail();
                            }

                            SystemEvent.save(user,
                                    String.format("Remove AccountPending for user %s, auth by %s",
                                    user.getUsername(),
                                    user.getUsernameShort()));

                            // set a couple other bits from the UI

                            boolean eater = request.getParameter("eater-" + username) != null;
                            if (eater) {
                                UserRole.add(user.getUsername(), UserRole.Role.Eater);
                            } else if (UserRole.does(user.getId(), UserRole.Role.Eater))
                                UserRole.remove(user.getUsername(), UserRole.Role.Eater);

                            boolean enabled = request.getParameter("enable-" + username) != null;
                            user.setEnabled(enabled);
                            user.save();

                            SystemEvent.save(user,
                                    String.format("Set Enabled for user %s to %s",
                                            user.getUsername(),
                                            Boolean.toString(enabled)));
                        }
                    }
                    break;
                }
                case "showDisabledUsers": {
                    boolean enabled = request.getParameter("showDisabledUsers") != null;
                    state.setAttribute("showDisabledUsers", enabled);
                }
                break;
            }

            boolean showDisabled = state.getAttributeB("showDisabledUsers");
            model.addAttribute("pendingUsers", User.findPending(showDisabled));
            return super.get(request, model, "pending-accounts");

        } catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }


    // present a list of user accounts, exclusive of pending accounts
    // pending accounts are not yet real ones

    @RequestMapping(value = "/users2", method = RequestMethod.GET)
    public String get3(HttpServletRequest request, Model model, HttpServletResponse response) {
        try {
            User user = getSessionUser(request);
            if ((user == null) || (!user.isAnAdmin()))
                showErrorPage("Unauthorized Access", request, model);

            model.addAttribute("seeders",
                    User.getSortedUsers(
                            new User.UserSelector() {
                                @Override
                                public boolean select(User user) {
                                    return user.getEnabled() && UserRole.does(user.getId(), UserRole.Role.Seeder);
                                }
                            },
                            Util::sortByComapanyName));

            model.addAttribute("feeders",
                    User.getSortedUsers(
                            new User.UserSelector() {
                                @Override
                                public boolean select(User user) {
                                    return user.getEnabled() && UserRole.does(user.getId(), UserRole.Role.Feeder);
                                }
                            },
                            Util::sortByComapanyName));

            model.addAttribute("admins",
                    User.getSortedUsers(
                            new User.UserSelector() {
                                @Override
                                public boolean select(User user) {
                                    return user.getEnabled() && UserRole.isAnAdmin(user.getId());
                                }
                            },
                            Util::sortByUserName));

            model.addAttribute("nonSeeders",
                    User.getSortedUsers(
                            new User.UserSelector() {
                                @Override
                                public boolean select(User user) {
                                    return user.getEnabled() && (!UserRole.does(user.getId(), UserRole.Role.Seeder));
                                }
                            },
                            Util::sortByUserName));

            model.addAttribute("disabledUsers",
                    User.getSortedUsers(
                            new User.UserSelector() {
                                @Override
                                public boolean select(User user) {
                                    return !user.getEnabled();
                                }
                            },
                            Util::sortByUserName));

            model.addAttribute("stripers",
                    User.getSortedUsers(
                            new User.UserSelector() {
                                @Override
                                public boolean select(User user) {
                                    return user.getEnabled() && (StripeCustomer.findByUserId(user.getId()) != null);
                                }
                            },
                            Util::sortByUserName));

            model.addAttribute("depots",
                    User.getSortedUsers(
                            new User.UserSelector() {
                                @Override
                                public boolean select(User user) {
                                    return user.getEnabled() && user.doesRole2(UserRole.Role.Depot);
                                }
                            },
                            Util::sortByUserName));


            return super.get(request, model, "users2");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

    @RequestMapping(value = "/user-charts/{userId}", method = RequestMethod.GET)
    public String get4a(@PathVariable("userId") String userId,
                       HttpServletRequest request, Model model, HttpServletResponse response) {
        try {
            {
                User user = getSessionUser(request);
                if ((user == null) | (!user.isAnAdmin()))
                    return showErrorPage("Unauthorized Access", request, model);
            }
            model.addAttribute("user", User.findById(userId));
            model.addAttribute("userCharts", UserCharts.getSystemCharts(userId));
            return super.get(request, model, "user-charts");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

    @RequestMapping(value = "/users/{username}", method = RequestMethod.GET)
    public String get4(@PathVariable("username") String username,
                       HttpServletRequest request, Model model, HttpServletResponse response) {

        MySessionState state = getSessionState(request);
        String nextPage = "user";
        User user = state.getUser();
        if ((user == null) || ( ! user.isAnAdmin()))
            return super.get(request, model, Constants.Web.REDIRECT_EATER_ALPHA_HOME);

        state.setAttribute ("targetUserId", User.findByUsername(username));
        return super.get(request, model, "user");
    }

    // update a user account's roles

    @RequestMapping(value = "/users/{username}", method = RequestMethod.POST)
    public String post3(@PathVariable("username") String username,
                        HttpServletRequest request, Model model) {

        MySessionState state = getSessionState(request);
        String nextPage = "redirect:/accounts";
        try {
            User user = getSessionUser(request);
            if ((user != null) && (user.isAnAdmin())) {

                switch (request.getParameter("operation")) {
                    case "update": {
                        User u = User.findByUsername(username);
                        {
                            boolean on = request.getParameter("Eater") != null;
                            changeRole (u, on, UserRole.Role.Eater);
                        }
                        {
                            boolean on = request.getParameter("Seeder") != null;
                            changeRole (u, on, UserRole.Role.Seeder);
                        }
                        {
                            boolean on = request.getParameter("Feeder") != null;
                            changeRole (u, on, UserRole.Role.Feeder);
                        }
                        {
                            boolean on = request.getParameter("Driver") != null;
                            changeRole (u, on, UserRole.Role.Driver);
                        }
                        {
                            boolean on = request.getParameter(UserRole.Role.Admin.toString()) != null;
                            changeRole (u, on, UserRole.Role.Admin);
                        }
                        break;
                    }
                }
            }
        } catch (Exception e) {
            Log.d(e);
            nextPage = Constants.Web.REDIRECT_INDEX_HOME;
        }

        boolean showDisabled = state.getAttributeB("showDisabledUsers");
        model.addAttribute("users", User.findPending(showDisabled));

        return super.post(request, model, nextPage);
    }

    private void changeRole (User user, boolean on, UserRole.Role role) {
        if (on) {
            UserRole.add(user.getUsername(), role);
        } else {
            UserRole.remove(user.getUsername(), role);
        }
    }

    @RequestMapping(value = "/users/create/contact-list", method = RequestMethod.GET)
    public String get5(HttpServletRequest req, Model model) {

        Map<String, Object> returns = new HashMap<>();
        try {
            returns = SendGrid.createContactList(req.getParameter("listName"), "email-dump.csv");
            return "ok";
        }
        catch (Exception ex) {
            returns.put("Exception", ex.getMessage());
            return "Error";
        }
    }
}
