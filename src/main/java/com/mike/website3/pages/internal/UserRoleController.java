package com.mike.website3.pages.internal;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.util.Log;
import com.mike.website3.Constants;
import com.mike.website3.MySessionState;
import com.mike.website3.db.*;
import com.mike.website3.pages.BaseController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class UserRoleController extends BaseController {
    private static final String TAG = UserRoleController.class.getSimpleName();

    @RequestMapping(value = "/user-details/{username}", method = RequestMethod.GET)
    public String get1(@PathVariable String username,
                       HttpServletRequest request,
                       Model model) {
        try {
            MySessionState state = getSessionState(request);
            User user = state.getUser();
            if ((user == null || ( ! user.isAnAdmin()))) {
                state.setAttribute("targetUserId", null);
                return super.get(request, model, Constants.Web.REDIRECT_EATER_ALPHA_HOME);
            }
            User u = User.findByUsername(username);
            state.setAttribute("targetUserId", u.getId());

            model.addAttribute("loginNamesOfAccount", LoginName.findAllByUserId(u.getUsername()));
            return super.get(request, model, "user-details");

        } catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

//    @RequestMapping(value = "/user-details/{username}/reset", method = RequestMethod.GET)
//    public String get1a(@PathVariable String username,
//                       HttpServletRequest request,
//                       Model model) {
//        try {
//            User admin = getSessionUser(request);
//            if ((admin == null || ( ! admin.isAnAdmin())))
//                return showErrorPage("Unauthorized Access", request, model);
//
//            String loginNameS = request.getParameter("loginName");
//            List<LoginName> loginName = LoginName.findByLoginName(loginNameS);
//            if (loginName.size() == 0)
//                return showErrorPage("No such login name " + loginNameS, request, model);
//            if (loginName.size() > 1)
//                return showErrorPage("Non-unique login name " + loginNameS, request, model);
//
//            loginName.get(0).resetPassword();
//
//            User user = User.findByUserId(loginName.get(0).getUserId());
//            UserPrefs userPrefs = user.getPrefs();
//            user.sendLoginResetEmail(loginName.get(0), userPrefs.getSendEmailOnLoginResetAddressId());
//
//            SystemEvent.save(user, String.format("Login %s reset by admin %s (%8.8s)",
//                    loginName.get(0).getLoginName(),
//                    admin.getName(),
//                    admin.getId()));
//
//            return super.get(request, model, "redirect:/user-details/" + username);
//        }
//        catch (Exception e) {
//            return showExceptionPage(e, request, model);
//        }
//    }


    // update a user account's roles

    @RequestMapping(value = "/user-details/{username}", method = RequestMethod.POST)
    public String post3(@PathVariable("username") String username,
                        HttpServletRequest request, Model model) {

        String nextPage = "redirect:/user-details/" + username;
        try {
            User sessionUser = getSessionUser(request);
            if ((sessionUser != null) && (UserRole.does(sessionUser.getId(), UserRole.Role.UserAdmin))) {

                // redo this code with error messages

                User target = User.findByUsername(username);
                switch (request.getParameter("operation")) {
                    case "CreateLogin": {
                        createLoginName(request, model, target);
                    }
                    break;
                    case "CreateEmail": {
                        // disallow duplicates
                        if (EmailAddress.findByEmail(request.getParameter("newEmailAddress")).size() == 0) {
                            // not in system
                            new EmailAddress(target, request.getParameter("newEmailAddress"))
                                    .save();
                        }
                    }
                    break;
                    case "setSendOnCloseEmailAddressId": {
                        String id = request.getParameter("emailAddressId");
                        UserPrefs userPrefs = target.getPrefs();
                        userPrefs.setSendOnCloseEmailAddressId(id.equals("None") ? "" : id);
                        userPrefs.save();
                    }
                    break;
                    case "setSendSupplieOrderEmailAddressId": {
                        String id = request.getParameter("emailAddressId");
                        UserPrefs userPrefs = target.getPrefs();
                        userPrefs.setSendSupplierOrderEmailId(id.equals("None") ? "" : id);
                        userPrefs.save();
                    }
                    break;
                    case "setSendOnOpenEmailAddressId": {
                        String id = request.getParameter("emailAddressId");
                        UserPrefs userPrefs = target.getPrefs();
                        userPrefs.setSendOnOpenEmailAddressId(id.equals("None") ? "" : id);
                        userPrefs.save();
                    }
                    break;
                    case "setSendOnLoginResetEmailAddressId": {
                        String id = request.getParameter("emailAddressId");
                        UserPrefs userPrefs = target.getPrefs();
                        userPrefs.setSendEmailOnLoginResetAddressId(id.equals("None") ? "" : id);
                        userPrefs.save();
                    }
                    break;
                    case "setSendOnPendingEmailAddressId": {
                        String id = request.getParameter("emailAddressId");
                        UserPrefs userPrefs = target.getPrefs();
                        userPrefs.setSendOnPendingAccountEmailAddressId(id.equals("None") ? "" : id);
                        userPrefs.save();
                    }
                    break;
                    case "update": {
                        // order dependency here, disabling a user will wipe all
                        // roles, so first we set all the roles to match the UI
                        // then we set enabled

                        for (UserRole.Role role : UserRole.Role.values()) {
                            boolean b = request.getParameter(role.toString()) != null;
                            UserRole.changeRole (sessionUser, target, b, role);
                        }

                        boolean b = request.getParameter("Enabled") != null;
                        target.setEnabled(b);
                        target.save();
                    }
                    break;
                }
            }
            else
                nextPage = Constants.Web.REDIRECT_INDEX_HOME;

        } catch (Exception e) {
            Log.d(e);
        }

        return super.post(request, model, nextPage);
    }

    private void createLoginName(HttpServletRequest request, Model model, User user) {
        String loginname = request.getParameter("NewLoginName");
        if (!LoginName.validLoginName(loginname)) {
            SystemEvent.save(user, String.format("Login name %s is not valid, fail create", loginname));
            return;
        }

        List<LoginName> existing = LoginName.findByLoginName(loginname);
        if (existing.size() > 0) {
            SystemEvent.save(user, String.format("Login name %s already exists, fail create", loginname));
            return;
        }

        // login name does not exist in the system

        List<EmailAddress> emailAddress = EmailAddress.findByEmail(user.getId());
//            Set<String> emails = new HashSet<>();
//            emailAddress.forEach(emailAddress1 -> {
//                if ( ! emails.add(emailAddress1.getEmail()))
//            });

        switch (emailAddress.size()) {
            case 0: { // no such email in system either, good to go
                LoginName loginName = new LoginName(user.getId(), loginname);
                loginName.resetPassword();
                loginName.save();
                SystemEvent.save(user, String.format("Login name %s created, password reset", loginname));
            }
            break;
            case 1: { // login name is not in-use but that email exists,
                // we allow that if, only if it's this user's
                if (!emailAddress.get(0).getUserId().equals(user.getId())) {
                    SystemEvent.save(user, String.format("Login name %s matches existing email of another user, fail create", loginname));
                }

                LoginName loginName = new LoginName(user.getId(), loginname);
                loginName.resetPassword();
                loginName.save();
                SystemEvent.save(user, String.format("Login name %s added to user, already has existing email", loginname));
            }
            break;
            default:
                SystemEvent.save(user, String.format("Login name %s matches more than 1 existing email, fail create", loginname));
                break;
        }
    }

}
