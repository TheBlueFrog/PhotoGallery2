package com.mike.website3.pages.external;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.MySessionState;
import com.mike.website3.db.LoginName;
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

    private String resetLogin;
    public String getResetLogin() {
        return resetLogin;
    }

    private String resetCode;
    public String getResetCode() {
        return resetCode;
    }

    private User resetUser = null;
    public User getResetUser() {
        return resetUser;
    }

    private void doGet(HttpServletRequest request, Model model) {
        MySessionState state = getSessionState(request);

        setSessionUser(request, null, null);
        setMessage(state, "");
        resetUser = null;

        resetLogin = request.getParameter("resetLogin");
        resetCode = request.getParameter("resetCode");

        // verify stuff

        List<LoginName> x = LoginName.findByLoginName(getResetLogin());
        if (x.size() != 1) {
            setMessage(state, String.format("The login (%s) in the URL does not match a known login.",
                    getResetLogin()));
            return;
        }
        if ( ! x.get(0).hasPasswordBeenReset()) {
            setMessage(state, String.format("The reset URL has already been used and cannot be reused"));
            return;
        }
        if ( ! x.get(0).getPwHash().equals(getResetCode())) {
            setMessage(state, String.format("The reset code (%s) in the URL not correct.", resetCode));
            return;
        }

        resetUser = User.findByUserId(x.get(0).getUserId());
    }

    private void doPost(HttpServletRequest request, Model model) {

        MySessionState state = getSessionState(request);
        String op = request.getParameter("operation");
        if (op == null) {
            return;
        }
        if ( ! op.equals("SetPasswordOfUser")) {
            return;
        }

        String loginName = getResetLogin();
        resetUser.resetPassword(loginName);

        try {
            resetUser.hashPassword(loginName, request.getParameter("password"));
        } catch (NoSuchAlgorithmException e) {
            setMessage(state, String.format("Internal error, %s", e.toString()));
            return;
        }

        setSessionUser(request, loginName, resetUser);
        resetUser.login();

        SystemEvent.save(resetUser, String.format("%s used the resetCode to reset their password", loginName));
        SystemEvent.save(resetUser, String.format("Logged in using %s", loginName));

        setMessage(state, "");
    }

}
