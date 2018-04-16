package com.mike.website3.pages.external;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.MySessionState;
import com.mike.website3.db.User;
import com.mike.website3.pages.BaseController;
import com.mike.website3.pages.BaseController2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;

@Controller
public class GalleryController extends BaseController2 {
    private static final String TAG = GalleryController.class.getSimpleName();

    @RequestMapping(value = "/gallery-image", method = RequestMethod.GET)
    public String geta(HttpServletRequest request, Model model) {

        MySessionState state = getSessionState(request);
        state.removeAttribute("userGallery");

        return get2(request, model, "gallery-image");
    }
    @RequestMapping(value = "/gallery-video", method = RequestMethod.GET)
    public String getb(HttpServletRequest request, Model model) {

        MySessionState state = getSessionState(request);
        state.removeAttribute("userGallery");

        return get2(request, model, "gallery-video");
    }

    @RequestMapping(value = "/gallery-image/{userId}", method = RequestMethod.GET)
    public String get1a(@PathVariable("userId") String userId, HttpServletRequest request, Model model) {

        MySessionState state = getSessionState(request);
        state.setAttribute("userGallery", userId);

        return get2(request, model, "gallery-image");
    }
    @RequestMapping(value = "/gallery-video/{userId}", method = RequestMethod.GET)
    public String get1b(@PathVariable("userId") String userId, HttpServletRequest request, Model model) {

        MySessionState state = getSessionState(request);
        state.setAttribute("userGallery", userId);

        return get2(request, model, "gallery-video");
    }


}
