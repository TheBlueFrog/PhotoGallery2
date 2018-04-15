package com.mike.website3.pages.external;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.exceptions.PasswordResetException;
import com.mike.util.AccountIsDisabled;
import com.mike.util.Log;
import com.mike.util.NoSuchLoginName;
import com.mike.util.NoSuchUserId;
import com.mike.website3.MySessionState;
import com.mike.website3.db.*;
import com.mike.website3.pages.BaseController2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.security.NoSuchAlgorithmException;
import java.sql.Timestamp;


/**
 * Created by mike on 11/23/2016.
 */
@Controller
public class LoginController extends BaseController2 {

    private static final String TAG = LoginController.class.getSimpleName();

    private void setMessage(MySessionState state, String s) {
        state.setAttribute("loginController-message", s);
    }

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String get(HttpServletRequest request, Model model, HttpServletResponse response) {
        try {
            MySessionState state = getSessionState(request);

            Cookie cookie = getCookie(request.getCookies(), "loginName");
            if (cookie != null)
                model.addAttribute("loginName", cookie.getValue());

            String offerId = request.getParameter("offerId");
            if (offerId != null)
                state.setAttribute("loginOfferId", offerId);
            else
                state.removeAttribute("loginOfferId");

            setMessage(state, "");
            return get2(request, model, "login");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public String post(HttpServletRequest request, Model model, HttpServletResponse response) {
        try {
            return login(request, model, response);
        } catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

    private Cookie getCookie(Cookie[] cookies, String name) {
        for (Cookie cookie : cookies) {
            if (cookie.getName().equals(name))
                return cookie;
        }
        return null;
    }

    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logoutGet(HttpServletRequest request, Model model) {
        try {
            MySessionState state = getSessionState(request);
            setMessage(state, "");

            if (state.getPushedUser() == null) {
                // simple logout
                // clear everything that depends on the user
                setSessionUser(request, null, null);
                return get2(request, model, "/");
            } else {
                // logging out of a switched-to user restore pushedUser
                setSessionUser(request, "?", state.getPushedUser());
                SystemEvent.save(state.getPushedUser(), "Restored from switch-user");
                state.setPushedUser(null);
                return get2(request, model, "redirect:/gallery");
            }
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }


    @RequestMapping(value = "/switch-user", method = RequestMethod.GET)
    public String switchUser(HttpServletRequest request, Model model) {
        try {
            MySessionState state = getSessionState(request);
            User admin = state.getUser();
            if ((admin == null) || (!admin.isAnAdmin()))
                return showErrorPage("Unauthorized Access", request, model);

            setMessage(state, "");

            String adminName = admin.getUsername();
            state.setPushedUser(admin);

            User user = User.findById(request.getParameter("userId"));
            if (user == null) {
                state.setPushedUser(null);
                return showErrorPage("Failed to load user " + request.getParameter("userId"), request, model);
            }

            setSessionUser(request, adminName, user);
            user.login();

            SystemEvent.save(state.getPushedUser(),
                    String.format("Switched-user from %s to %s",
                            admin.getName(), user.getName()));
            return get2(request, model, "/");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

    // landing page if a user with a reset account logs in
    // tells them they need a reset code
    @RequestMapping(value = "/reset-account", method = RequestMethod.GET)
    public String geth(HttpServletRequest request, Model model) {
        try {
            model.addAttribute("loginName", request.getParameter("loginName"));
            return get(request, model, "reset-account");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

    private String login(HttpServletRequest request, Model model, HttpServletResponse response) {
        String loginname = request.getParameter("loginName");
        MySessionState state = getSessionState(request);

        Log.d(TAG, String.format("Login user: %s", loginname == null ? "" : loginname));
        if (loginname.length() == 0) {
            setMessage(state,  String.format("Empty Login Name"));
            return get2(request, model, "login");
        }
        try {
            loginname = loginname.trim();
            User user = User.authenticate(loginname, request.getParameter("password"));

            if (user == null) {
                // the authenticate method throws a ton of exceptions
                // if we get here it's either a bad loginname or bad password

                SystemEvent.save(loginname,
                        String.format("Incorrect password for login %s", loginname));
                setMessage(state, String.format("Either the login and/or the password are incorrect."));
                return get2(request, model, "login");
            }

            if (user.doesRole2(UserRole.Role.AccountPending) || ( ! user.getEnabled())) {
                // log them back out
                setSessionUser(request, null, null);
                setMessage(state, String.format("To ensure quality, we are limiting activation and your account is still pending.  " +
                        "We will notify you via email as soon as your account can be activated."));
                SystemEvent.save(loginname, String.format("Pending user %s attempted to login.", user.getId()));
                return get2(request, model, "login");
            }

            setMessage(state,  "Login successful");
            user.login();
            setSessionUser(request, loginname, user);
            SystemEvent.save(user, String.format("Logged in using %s", loginname));

            Cookie cookie = new Cookie("loginName", loginname);
            response.addCookie(cookie);

            if (user.getHasLoggedIn()) {
                return "redirect:/";
            } else {
                user.setHasLoggedIn();
                user.save();
                new SystemEvent(user.getUsername(), String.format("First login of %s (%s)",
                        user.getName(), user.getId()))
                        .save();
                return "redirect:/";
            }
        }
        catch (PasswordResetException e) {
            String s = String.format("Attempt to login with reset login %s.  Please contact customer support for a new reset URL.", loginname);
            SystemEvent.save(loginname, s);
            setMessage(state,  s);
            return get2(request, model, "login");
        }
        catch (NoSuchAlgorithmException e) {
            String s = String.format("Sever is misconfigured, no encryption algorithm");
            setMessage(state,  s);
            Log.e(TAG, s);
            return get2(request, model, "login");
        }
        catch (NoSuchLoginName noSuchLoginName) {
            String s = String.format("Login %s is not recognized", loginname);
            setMessage(state,  s);
            Log.e(TAG, s);
            return get2(request, model, "login");
        } catch (AccountIsDisabled e) {
            String s = String.format("The account %s has been disabled.  Please contact customer support.", e.getMessage());
            setMessage(state, s);
            Log.e(TAG, s);
            return get2(request, model, "login");
        } catch (NoSuchUserId e) {
            String s = String.format("The login %s does not match a know user account. Please contact customer support.", loginname);
            setMessage(state,  s);
            Log.e(TAG, s);
            return get2(request, model, "login");
        } catch (PasswordEmpty e) {
            String s = String.format("Passwords may not be be empty strings.");
            setMessage(state, s);
            Log.e(TAG, s);
            return get2(request, model, "login");
        }
    }

}
