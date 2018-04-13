package com.mike.website3.pages;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.util.Log;
import com.mike.website3.Constants;
import com.mike.website3.Website;
import com.mike.website3.db.User;
import com.mike.website3.db.UserImage;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

@Controller
public class UserImageController extends BaseController {
    private static final String TAG = UserImageController.class.getSimpleName();

    @RequestMapping(value = "/user-image-manager", method = RequestMethod.GET)
    public String get(HttpServletRequest request, Model model) {
        String page = "user-image-manager";
        try {
            User user = getSessionUser(request);
            if (user == null) {
                page = Constants.Web.REDIRECT_EATER_ALPHA_HOME;
            }

            addImageFiles(model, user);
        }
        catch (Exception e) {
            Log.e(TAG, e);
            page  = Constants.Web.REDIRECT_EATER_ALPHA_HOME;
        }

        this.addAttributes(request, model);
        return super.get(request, model, page);
    }

    private void addImageFiles(Model model, User user) {
        List<String> paths = new ArrayList<>();
        Website.getStorageService().loadAll(user).forEach(path -> {
            String s = path.toFile().getName();
            paths.add(path.toFile().getName());
        });

        model.addAttribute("filesystemUserImages", paths);
    }

    @RequestMapping(value = "/user-image-manager", method = RequestMethod.POST)
    public String post(HttpServletRequest request, Model model) {

        String nextPage = "/user-image-manager";
        try {
            User user = getSessionUser(request);
            if (user != null) {

                switch (request.getParameter("operation")) {
                    case "Update": {
                        UserImage userImage = UserImage.findById(request.getParameter("imageId"));
                        userImage.setFilename(request.getParameter("filename"));
                        userImage.setCaption(request.getParameter("caption"));
                        userImage.setUsage(request.getParameter("usage"));
                        userImage.save();
                        break;
                    }
                    case "Create": {
                        UserImage userImage = new UserImage(user,
                                request.getParameter("caption"),
                                request.getParameter("filename"),
                                request.getParameter("usage"));
                        userImage.save();
                        break;
                    }
                    case "Delete": {
                        UserImage userImage = UserImage.findById(request.getParameter("imageId"));
                        userImage.delete();;
                        break;
                    }
                }

                addImageFiles(model, user);
            }
        } catch (Exception e) {
            Log.d(e);
            nextPage = Constants.Web.REDIRECT_INDEX_HOME;
        }

        return super.post(request, model, nextPage);
    }
}
