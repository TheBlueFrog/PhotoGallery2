package com.mike.website3.pages.internal;

import com.mike.website3.Constants;
import com.mike.website3.MySessionState;
import com.mike.website3.db.Image;
import com.mike.website3.db.SystemEvent;
import com.mike.website3.db.User;
import com.mike.website3.pages.BaseController;
import com.mike.website3.pages.BaseController2;
import com.mike.website3.storage.StorageFileNotFoundException;
import com.mike.website3.storage.StorageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * Created by mike on 3/6/2017.
 */
@Controller
public class ManageController extends BaseController2 {

    @GetMapping("/manage-images")
    public String get(HttpServletRequest request, Model model) {
        return get2(request, model, "manage-images");
    }

    @GetMapping("/manage-videos")
    public String get1(HttpServletRequest request, Model model) {
        return get2(request, model, "manage-videos");
    }

    @PostMapping("/manage-items")
    public String post(HttpServletRequest request) {

        User user = getSessionUser(request);
        if (user != null) {
            Image image = Image.findById(request.getParameter("id"));
            image.setCaption(request.getParameter("caption"));
            boolean b = request.getParameter("public") != null;
            image.setPublic(b);
            image.save();
        }
        return "redirect:/manage-items";
    }


}