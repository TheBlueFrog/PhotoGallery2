package com.mike.website3.pages.external;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.MySessionState;
import com.mike.website3.db.SystemEvent;
import com.mike.website3.db.User;
import com.mike.website3.pages.BaseController2;
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
public class ResetPasswordController extends BaseController2 {

    private static final String TAG = ResetPasswordController.class.getSimpleName();

    private void setMessage(MySessionState state, String s) {
        state.setAttribute("resetPasswordController-message", s);
    }


    @RequestMapping(value = "/reset-password", method = RequestMethod.GET)
    public String get21(HttpServletRequest request, Model model) {
        try {
            if (request.getParameter("resetCode") == null)
                showErrorPage("No reset code provided", request, model);

            // we have a reset URL
            doGet(request, model);
            return get2(request, model, "reset-password");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

    @RequestMapping(value = "/reset-password", method = RequestMethod.POST)
    public String post2(HttpServletRequest request, Model model) {
        try {
            doPost(request, model);
            return get2(request, model,
                    "redirect:/general-message?title=Password Changed&message=Your password has been changed");
        } catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

    private void doGet(HttpServletRequest request, Model model) {
        MySessionState state = getSessionState(request);

        setSessionUser(request, null, null);
        setMessage(state, "");

        String resetUser = null;
        String resetLogin = request.getParameter("resetLogin");
        String resetCode = request.getParameter("resetCode");

        state.setAttribute("resetUser", resetUser);

        // verify stuff

        User user = User.findByLoginName(resetLogin);
        if (user == null) {
            setMessage(state, String.format("The login (%s) in the URL does not match a known login.",
                    resetLogin));
            return;
        }
        if ( ! user.hasPasswordBeenReset()) {
            setMessage(state, String.format("The reset URL has already been used and cannot be reused"));
            return;
        }
        if ( ! user.getPwHash().equals(resetCode)) {
            setMessage(state, String.format("The reset code (%s) in the URL not correct.", resetCode));
            return;
        }

        state.setAttribute("resetLogin", resetLogin);
        state.setAttribute("resetCode", resetCode);
        state.setAttribute("resetUser", user);
    }

    // http://localhost:8080/reset-password?resetCode=92989&resetLogin=mike

    private void doPost(HttpServletRequest request, Model model) {

        MySessionState state = getSessionState(request);
        String op = request.getParameter("operation");
        if (op == null) {
            return;
        }
        if ( ! op.equals("ResetPassword")) {
            return;
        }

        String loginName = state.getAttributeS("resetLogin");

        state.removeAttribute("resetCode");
        state.removeAttribute("resetLogin");

        User user = (User) state.getAttribute("resetUser");
        state.removeAttribute("resetUser");

        user.resetPassword();   // kill existing reset code,

        try {
            user.hashPassword(request.getParameter("password"));
        } catch (NoSuchAlgorithmException e) {
            setMessage(state, String.format("Internal error, %s", e.toString()));
            return;
        }

        setSessionUser(request, loginName, user);
        user.login();

        SystemEvent.save(user, String.format("%s used the resetCode to reset their password", loginName));
        SystemEvent.save(user, String.format("Logged in using %s", loginName));

        setMessage(state, "");
    }

}
