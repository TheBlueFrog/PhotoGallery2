package com.mike.website3.pages;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.MySessionState;
import com.mike.website3.db.LoginName;
import com.mike.website3.db.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;

@Controller
public class MyPagesController extends BaseController2 {
    private static final String TAG = MyPagesController.class.getSimpleName();

    @RequestMapping(value = "/my-pages", method = RequestMethod.GET)
    public String get2(HttpServletRequest request, Model model) {
        try {
            User user = getSessionUser(request);
            if (user == null)
                return showErrorPage("Unauthorized Access", request, model);

            model.addAttribute("loginNamesOfAccount", LoginName.findAllByUserId(user.getUsername()));
            this.addAttributes(request, model);
            return super.get(request, model, "my-pages");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

    @RequestMapping(value = "/my-pages2", method = RequestMethod.GET)
    public String get2a(HttpServletRequest request, Model model) {
        try {
            User user = getSessionUser(request);
            if (user == null)
                return showErrorPage("Unauthorized Access", request, model);

            model.addAttribute("loginNamesOfAccount", LoginName.findAllByUserId(user.getUsername()));
            this.addAttributes(request, model);
            return super.get(request, model, "my-pages2");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

    @RequestMapping(value = "/my-pages2", method = RequestMethod.POST)
    public String post(HttpServletRequest request, Model model) {
        try {
            User user = getSessionUser(request);
            if (user == null)
                return showErrorPage("Unauthorized Access", request, model);

            boolean searchTruncation = request.getParameter("enableSearchTruncation") != null;
            UserPrefs p = user.getPrefs();
            p.setSearchTruncation(searchTruncation);
            p.save();

            return super.get(request, model, "my-pages2");
        } catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }


    @RequestMapping(value = "/my-orders", method = RequestMethod.GET)
    public String get3a(HttpServletRequest request, Model model) {
        try {
            MySessionState state = getSessionState(request);
            User user = state.getUser();
            if (user == null)
                return showErrorPage("Unauthorized Access", request, model);

            if (state.getAttribute("showOrderHistory") == null)
                state.setAttribute("showOrderHistory", false);

            return get2(request, model, "my-orders");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

    @RequestMapping(value = "/my-orders", method = RequestMethod.POST)
    public String post3(HttpServletRequest request, Model model) {
        try {
            MySessionState state = getSessionState(request);
            User user = state.getUser();
            if (user == null)
                return showErrorPage("Unauthorized Access", request, model);

            return get2(request, model, "redirect:/my-orders");
        } catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

    @RequestMapping(value = "/my-orders-grid", method = RequestMethod.GET)
    public String get4(HttpServletRequest request, Model model) {
        try {
            MySessionState state = getSessionState(request);
            User user = state.getUser();
            if (user == null)
                return showErrorPage("Unauthorized Access", request, model);

            return get2(request, model, "my-orders-grid");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }


//    @RequestMapping(value = "/my-pages", method = RequestMethod.POST)
//    public String post(HttpServletRequest request, Model model) {
//        try {
//            User user = getSessionUser(request);
//            if (user == null)
//                return showErrorPage("Unauthorized Access", request, model);
//
//            switch (request.getParameter("operation")) {
//                case "CreateLogin": {
//                    String loginname = request.getParameter("NewLoginName");
//                    if (!LoginName.validLoginName(loginname))
//                        return showErrorPage(
//                                String.format("<%s> is not a valid login name", loginname), request, model);
//
//                    if (LoginName.findByLoginName(loginname) != null)
//                        return showErrorPage(
//                                String.format("Login name <%s> already exists, please try another one.", loginname),
//                                request, model);
//
//                    // does not exist
//                    LoginName loginName = new LoginName(user.getUsername(), loginname);
//                    loginName.resetPassword();
//                    loginName.save();
//                    break;
//                }
//                case "Reset": {
//                    String loginname = request.getParameter("LoginName");
//                    LoginName loginName = LoginName.findByLoginName(loginname);
//                    if (loginName == null)
//                        return showErrorPage(
//                                String.format("Login name <%s> does not exist", loginName), request, model);
//
//                    loginName.resetPassword();
//                    }
//                    break;
//                }
//
//            return super.post(request, model, "redirect:/my-pages");
//        }
//        catch (Exception e) {
//            return showExceptionPage(e, request, model);
//        }
//    }

}
