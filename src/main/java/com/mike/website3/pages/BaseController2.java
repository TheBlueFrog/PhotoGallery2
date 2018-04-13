package com.mike.website3.pages;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.util.Log;
import com.mike.website3.MySessionState;
import org.springframework.ui.Model;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by mike on 11/23/2016.
 */
public abstract class BaseController2 extends BaseController {

    private static final String TAG = BaseController2.class.getSimpleName();

    public String get2(HttpServletRequest request, Model model, String nextPage) {

        try {
            MySessionState ss = getSessionState(request);
            addAttributes(request, model);
//            model.addAttribute("sessionErrors", ss.getSessionErrors());

            model.addAttribute("pageState", this);

            Log.d(TAG, String.format("%s GET %s, next page %s", ss.getId(), request.getRequestURI(), nextPage));
        } catch (Exception e) {
            Log.d(e);
        }

        return nextPage;
    }

}
