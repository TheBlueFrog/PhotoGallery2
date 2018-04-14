package com.mike.website3.pages;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

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

            model.addAttribute("loginNameOfAccount", user.getLoginName());
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

            model.addAttribute("loginNameOfAccount", user.getLoginName());
            this.addAttributes(request, model);
            return super.get(request, model, "my-pages2");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }


}
