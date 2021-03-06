package com.mike.website3.pages.oneliners;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.pages.BaseController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;

@Controller
public class HowItWorksController extends BaseController {

    private static final String TAG = HowItWorksController.class.getSimpleName();

    @RequestMapping(value = "/how-it-works", method = RequestMethod.GET)
    public String get1(HttpServletRequest request, Model model)
    {
        return super.get(request, model, "how-it-works");
    }
}