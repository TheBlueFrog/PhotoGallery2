package com.mike.website3.pages.external;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.pages.BaseController2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
public class IndexController extends BaseController2 {
    private static final String TAG = IndexController.class.getSimpleName();

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String slashGet(
            HttpServletRequest request,
            HttpServletResponse response,
            Model model) {
        try {
            return get2(request, model, "index3");

        } catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

    @RequestMapping(value = "/index3", method = RequestMethod.GET)
    public String get(HttpServletRequest request, Model model) {
        try {
            return get2(request, model, "index3");

        } catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }
}