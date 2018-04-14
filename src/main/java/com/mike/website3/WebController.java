package com.mike.website3;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.util.Log;
import com.mike.website3.db.*;
import com.mike.website3.db.ImageRepo;
import com.mike.website3.db.repo.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import freemarker.template.Configuration;

import javax.servlet.http.HttpServletRequest;

@Controller
public class WebController {

    private static final String TAG = WebController.class.getSimpleName();

    @Autowired      Configuration configuration;
    @Autowired      EmailAddressRepo emailRepo;
    @Autowired      PhoneNumberRepo phoneNumberRepo;
    @Autowired      SystemEventRepo systemEventRepo;
    @Autowired      private ImageRepo imageRepo;
    @Autowired      private UserImageRepo userImageRepo;
    @Autowired      private SystemNoticeRepo systemNoticeRepo;
    @Autowired      private UserRoleRepo userRoleRepo;
    @Autowired      private UserRepo userRepo;
    @Autowired      private DatabaseConfigRepo databaseConfigRepo;
    @Autowired      private StringDataRepo miniWebsiteDataRepo;

    public WebController () {
        Website.registerRepoOwner(this);
    }

    // seems like this class is magical, tried removing it and
    // things don't startup up??????


    @ExceptionHandler(Exception.class)
    public ModelAndView globalExceptionHandler(Exception e) {
        ModelAndView modelAndView = new ModelAndView("error");
        // there is a stack trace in the exception but it
        // only has the stack that got us here, whatever caused
        // the exception is gone
        modelAndView.getModelMap().addAttribute("error", e.getClass().getSimpleName());
        Log.e(TAG, "Caught an Exception...<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<,");
        Log.e(TAG, e);

        try {
            SystemEvent.save("Exception caught");
        }
        catch (Exception e1) {
            Log.e(TAG, e1);
            Log.e(TAG, "Caught an Exception trying to save Exception to SystemEvent, giving up.");
        }

        return modelAndView;
    }


    @RequestMapping("/myerror")
    public String test(
              HttpServletRequest request,
              Model model) {

        MySessionState ss = (MySessionState) request.getSession().getAttribute(Constants.appSession);
        model.addAttribute("error", ss.getLastError());

        MySystemState systemState = MySystemState.getInstance();
        model.addAttribute("system", systemState);
        model.addAttribute("session", ss);

        return "error";
    }

    @RequestMapping("/test")
    public String test1(
            HttpServletRequest request,
            Model model) {

        MySessionState ss = (MySessionState) request.getSession().getAttribute(Constants.appSession);

        MySystemState systemState = MySystemState.getInstance();
        model.addAttribute("system", systemState);
        model.addAttribute("session", ss);
        return "test";
    }

    @RequestMapping("/test-json-post")
    public String test3(
            HttpServletRequest request,
            Model model) {

        return "test-json-post";
    }

    public Configuration getConfiguration() {
        return configuration;
    }

    public EmailAddressRepo getUserEmailRepo() {
        return emailRepo;
    }
    public PhoneNumberRepo getPhoneNumberRepo() {
        return phoneNumberRepo;
    }
    public SystemEventRepo getSystemEventRepo() {
        return systemEventRepo;
    }
    public ImageRepo getImageRepo() {
        return imageRepo;
    }
    public UserImageRepo getUserImageRepo() {
        return userImageRepo;
    }
    public SystemNoticeRepo getSystemNoticeRepo() {
        return systemNoticeRepo;
    }
    public UserRoleRepo getUserRoleRepo() {
        return userRoleRepo;
    }
    public UserRepo getUserRepo() {
        return userRepo;
    }
    public DatabaseConfigRepo getDatabaseConfigRepo() {
        return databaseConfigRepo;
    }
    public StringDataRepo getMiniWebsiteDataRepo() {
        return miniWebsiteDataRepo;
    }
}
