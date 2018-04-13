package com.mike.website3.pages.external;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */


import com.mike.exceptions.InvalidAddressException;
import com.mike.exceptions.PasswordResetException;
import com.mike.exceptions.UserDirectoryExistsException;
import com.mike.exceptions.UserExistsException;
import com.mike.util.AccountIsDisabled;
import com.mike.util.InvalidLoginNameException;
import com.mike.util.NoSuchLoginName;
import com.mike.util.NoSuchUserId;
import com.mike.website3.*;
import com.mike.website3.db.*;
import com.mike.website3.pages.BaseController2;
import com.mike.website3.util.UnsupportedZipCode;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;

import java.security.NoSuchAlgorithmException;
import java.util.List;


/**
 * Created by mike on 11/23/2016.
 */
@Controller
public class RegisterUserController extends BaseController2 {

    private static final String TAG = RegisterUserController.class.getSimpleName();

    private void setMessage(MySessionState state, String s) {
        state.setAttribute("registerUserController-message", s);
    }


    @RequestMapping(value = "/register-account", method = RequestMethod.GET)
    public String get(HttpServletRequest request, Model model) {

        try {
            MySessionState state = getSessionState(request);

//            setMessage(state,"");
            if (getSessionUser(request) != null)
                return "redirect:/general-message?title=" + "Ooops" + "&message=" +
                        String.format("You cannot register while logged in.");


            if (state.getAttribute("registerUsername") == null)
                state.setAttribute("registerUsername", "");

            state.setAttribute("registerZip", request.getParameter("registerZip"));

            return get2(request, model, "register-account");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

    @RequestMapping(value = "/register-account", method = RequestMethod.POST)
    public String post(HttpServletRequest request, Model model) {

        try {
            MySessionState state = getSessionState(request);
            String nextPage = createAccount(request, model);

            if ( ! nextPage.contains("register-account")) {
                // we're leaving the register flow, wipe state
                state.removeAttribute("registerUsername");
                state.removeAttribute("registerZip");
            }

            return get2(request, model, nextPage);

        } catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

    private String createAccount(HttpServletRequest request, Model model) {

        MySessionState state = getSessionState(request);

        setMessage(state,"");

        if (state.getUser() != null) {
            return "redirect:/general-message?title=" + "Ooops" + "&message=" +
                String.format("You cannot register while logged in.");
        }

        state.setAttribute("registerUsername", request.getParameter("username"));

        User user = null;
        String errorPage = "redirect:/register-account?registerZip=" + state.getAttribute("registerZip");
        try {

            if (EmailAddress.findByEmail((String) state.getAttribute("registerUsername")).size() > 0) {
                setMessage(state,String.format("The login name %s already exists as an email address.", request.getParameter("username")));
                return errorPage;
            }
            user = new User((String) state.getAttribute("registerUsername"),
                    request.getParameter("password"),
                    request.getParameter("role"),
                    "",//(String) state.getAttribute("registerFirstName"),
                    "",//(String) state.getAttribute("registerLastName"),
                    "",//(String) state.getAttribute("registerStreet"),
                    "",//(String) state.getAttribute("registerCity"),
                    "Oregon", //(String) state.getAttribute("registerState"),
                    (String) state.getAttribute("registerZip"));
        } catch (InvalidLoginNameException e) {
            setMessage(state, String.format("The login name %s is not valid.", request.getParameter("username")));
            return errorPage;
        } catch (UserExistsException e) {
            setMessage(state, String.format("The login name %s is already registered.", request.getParameter("username")));
            return errorPage;
        } catch (InvalidAddressException e) {
            setMessage(state, String.format("The address you entered cannot be geo-coded (we use Google Maps for geo-coding). Please check it carefully."));
            return errorPage;
        } catch (UnsupportedZipCode e) {
            setMessage(state, String.format("Zip code %s is not supported.  Please use a supported zip code", e.getMessage()));
            return errorPage;
        } catch (IllegalArgumentException e) {
            setMessage(state, String.format("Internal error: %s", e.toString()));
            return errorPage;
        } catch (UserDirectoryExistsException e) {
            setMessage(state, String.format("Internal error: %s", e.toString()));
            return errorPage;
        } catch (Exception e) {
            setMessage(state, String.format("Internal error: %s", e.toString()));
            return errorPage;
        }

        if (user == null) {
            setMessage(state, String.format("Internal error: failed to create account %s",
                    (String) state.getAttribute("registerUsername")));
            return errorPage;
        }

        // get a new, authenticated user
        try {
            user = User.authenticate(request.getParameter("username"), request.getParameter("password"));
        }
        catch (PasswordResetException e) {
            setMessage(state, String.format("The password for the login name %s of this account has already been reset",
                    e.toString()));
            return errorPage;
        }
        catch (NoSuchAlgorithmException e) {
            setMessage(state, String.format("Internal error: mis-configured server, %s", e.toString()));
            return errorPage;
        }
        catch (AccountIsDisabled e) {
            setMessage(state, String.format("The account %s has been disabled.  Please contact customer support.",
                    e.getMessage()));
            return errorPage;
        }
        catch (NoSuchUserId e) {
            setMessage(state, String.format("The system failed to generate a new account %s.  Please contact customer support",
                    e.toString()));
            return errorPage;
        }
        catch (NoSuchLoginName e) {
            setMessage(state, String.format("Login %s is not recognized", request.getParameter("username")));
            return errorPage;
        }
        catch (PasswordEmpty e) {
            setMessage(state, String.format("Passwords may not be be empty strings."));
            return errorPage;
        }

        if (user == null) {
            setMessage(state, String.format("Internal error: failed to authenticate new account %s", request.getParameter("username")));
            return errorPage;
        }

        setSessionUser(request, request.getParameter("username"), user);
        user.login();
        initializePrefs(user);

        String referrer = request.getParameter("referrer");
        if ((referrer != null) && (referrer.length() > 5)) {
            UserNote note = new UserNote("Referred by: " + referrer);
            note.setUserId(user.getId());
            note.setColor(UserNote.Color.Referrer);
            note.save();
        }

        // newly minted users are usually pending, some can be automatically un-pended

        if (user.doesRole2(UserRole.Role.AccountPending)) {

//            double incCost = user.getPendingUserIncrementalCostMetric();
//            double threshold = MySystemState.getInstance().getMetric("PendingUserIncrementalCostThreshold");
            String zip = (String) state.getAttribute("registerZip");
            if (MySystemState.getInstance().isSupportedZipCode(zip)) {
                    //|| (incCost < threshold)) {
                // good to go
                user.removeRole(UserRole.Role.AccountPending);

                User.notifyAdminsOfAutoUnPendUser(user,
                        String.format("Auto-unpended, %s, (%8.8s...) zip code %s",
                                user.getName(), user.getId(),
                                zip));

                return "redirect:/first-login";
            }
            else {
                setSessionUser(request, null, null);  // log them back out
                String s = String.format("Pending user, %s, (%8.8s...) zip code %s is unsupported.",
                                user.getName(), user.getId(),
                                zip);
                User.notifyAdminsOfNewPendingUser(user, s);
                SystemEvent.save(s);

                return "redirect:/pending-account";
            }
        }
        else {
            // a not-immediately pending user
            return "redirect:/first-login";
        }
    }

    private void initializePrefs(User user) {
        List<EmailAddress> emails = user.getEmailAddresses();
        if (emails.size() != 1) {
            SystemEvent.save(user, "New user has more than one email address?");
        }

        UserPrefs prefs = user.getPrefs();
        prefs.setSendEmailOnLoginResetAddressId(emails.get(0).getId());
        prefs.setSendOnCloseEmailAddressId(emails.get(0).getId());
        prefs.setSendSupplierOrderEmailId(emails.get(0).getId());
        prefs.save();
    }
}
