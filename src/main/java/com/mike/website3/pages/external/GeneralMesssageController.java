package com.mike.website3.pages.external;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.MySessionState;
import com.mike.website3.pages.BaseController2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;

@Controller
public class GeneralMesssageController extends BaseController2 {

    private static final String TAG = GeneralMesssageController.class.getSimpleName();

    @RequestMapping(value = "/general-message", method = RequestMethod.GET)
    public String get1(HttpServletRequest request, Model model)
    {
        MySessionState state = getSessionState(request);

        state.setAttribute("generalMessage-title", request.getParameter("title"));
        state.setAttribute("generalMessage-message", request.getParameter("message"));
        return get2(request, model, "general-message");
    }
}
