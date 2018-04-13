package com.mike.website3.pages;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.util.Log;
import com.mike.website3.*;
import com.mike.website3.db.StringData;
import com.mike.website3.db.SystemEvent;
import com.mike.website3.db.User;
import freemarker.ext.beans.BeansWrapper;
import freemarker.ext.beans.BeansWrapperBuilder;
import freemarker.template.Configuration;
import freemarker.template.TemplateHashModel;
import freemarker.template.TemplateModelException;
import org.springframework.ui.Model;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

import static com.mike.website3.Constants.appSession;

/**
 * Created by mike on 11/23/2016.
 */
public abstract class BaseController  {

    private static final String TAG = BaseController.class.getSimpleName();

    static private TemplateHashModel stringStatics = null;

    static private TemplateHashModel utilStatics = null;
    static private TemplateHashModel userStatics = null;
    static private TemplateHashModel addressStatics = null;
    static private TemplateHashModel emailAddressStatics = null;
    static private TemplateHashModel itemImageStatics = null;
    static private TemplateHashModel phoneNumberStatics = null;
    static private TemplateHashModel userImageStatics = null;
    static private TemplateHashModel systemEventStatics = null;
    static private TemplateHashModel loginNameStatics = null;
    static private TemplateHashModel websiteStatics = null;
    static private TemplateHashModel userRoleStatics = null;
    static private TemplateHashModel locationStatics = null;
    static private TemplateHashModel metricsStatics = null;
    static private TemplateHashModel mySystemStateStatics = null;

    static Map<String, Object> models = null;

    static private void initStatics() {
        models = new HashMap<>();

        BeansWrapper wrapper = new BeansWrapperBuilder(Configuration.VERSION_2_3_21).build();

        TemplateHashModel staticModels = wrapper.getStaticModels();
        try {
            utilStatics = (TemplateHashModel) staticModels.get("com.mike.util.Util");
            userStatics = (TemplateHashModel) staticModels.get("com.mike.website3.db.User");
            addressStatics = (TemplateHashModel) staticModels.get("com.mike.website3.db.Address");
            emailAddressStatics = (TemplateHashModel) staticModels.get("com.mike.website3.db.EmailAddress");
            itemImageStatics = (TemplateHashModel) staticModels.get("com.mike.website3.db.ItemImage");
            phoneNumberStatics = (TemplateHashModel) staticModels.get("com.mike.website3.db.PhoneNumber");
            userImageStatics = (TemplateHashModel) staticModels.get("com.mike.website3.db.UserImage");
            systemEventStatics = (TemplateHashModel) staticModels.get("com.mike.website3.db.SystemEvent");
            loginNameStatics = (TemplateHashModel) staticModels.get("com.mike.website3.db.LoginName");
            websiteStatics = (TemplateHashModel) staticModels.get("com.mike.website3.Website");
            userRoleStatics = (TemplateHashModel) staticModels.get("com.mike.website3.db.UserRole");
            locationStatics = (TemplateHashModel) staticModels.get("com.mike.util.Location");
            metricsStatics = (TemplateHashModel) staticModels.get("com.mike.website3.milkrun.routing.Metrics");
            stringStatics = (TemplateHashModel) staticModels.get("java.lang.String");
            mySystemStateStatics = (TemplateHashModel) staticModels.get("com.mike.website3.MySystemState");

        } catch (TemplateModelException e) {
            Log.d(e);
        }
    }

    static private Map<String, Object> staticsMap = new HashMap<>();

    public BaseController () {
        if (models == null) {
            initStatics();

            staticsMap.put("String", stringStatics);

            staticsMap.put("Address", addressStatics);
            staticsMap.put("EmailAddress", emailAddressStatics);
            staticsMap.put("ItemImage", itemImageStatics);
            staticsMap.put("Location", locationStatics);
            staticsMap.put("LoginName", loginNameStatics);
            staticsMap.put("Metrics", metricsStatics);
            staticsMap.put("MySystemState", mySystemStateStatics);
            staticsMap.put("PhoneNumber", phoneNumberStatics);
            staticsMap.put("SystemEvent", systemEventStatics);
            staticsMap.put("Util", utilStatics);
            staticsMap.put("User", userStatics);
            staticsMap.put("UserImage", userImageStatics);
            staticsMap.put("UserRole", userRoleStatics);
            staticsMap.put("Website", websiteStatics);
        }
    }

    static public Map<String, Object> getStatics() {
        return staticsMap;
    }

    static public Map<String, Object> getBasicData() {
        Map<String, Object> data = new HashMap<>();
//        data.put("session", (MySessionState) request.getSession().getAttribute(Constants.appSession));
        data.put("system", MySystemState.getInstance());
        data.putAll(BaseController.getStatics());

        data.put("environment", getEnvronment());
        return data;
    }

    // setup environment vars that are used in FTL
    static public Map<String, Object> getEnvronment() {
        Map<String, Object> map = new HashMap<>();

        if (Website.getDevEnv())
            map.put("machine", "localhost:8080");
        else if (System.getenv("BUILD_TYPE").equals("stage"))
            map.put("machine", "35.194.52.222");
        else
            map.put("machine", StringData.findByUserIdAndKey("", "DNSName").getValue());

        return map;
    }

    protected void addAttributes(HttpServletRequest request, Model model) {

        model.addAllAttributes(staticsMap);

        model.addAttribute("system", MySystemState.getInstance());
        model.addAttribute("session", getSessionState(request));
    }

    public MySessionState getSessionState(HttpServletRequest request) {
//        HttpSession session = request.getSession();
//        Log.d(TAG, "Session ID: " + session.getId());
        MySessionState ss = (MySessionState) request.getSession().getAttribute(Constants.appSession);
        if (ss == null) {
            // no such object for this session, create one
            ss = new MySessionState();
            putSessionState(request, ss);
        }
        return ss;
    }
    private void putSessionState (HttpServletRequest request, MySessionState ss) {
        request.getSession().setAttribute(appSession, ss);
    }

    public User getSessionUser(HttpServletRequest request) {
        return getSessionState(request).getUser();
    }

    protected void setSessionUser(HttpServletRequest request, String loginname, User user) {
        getSessionState(request).setUser(loginname, user);
    }

    protected String get(HttpServletRequest request, Model model, String nextPage) {
        return get(request, model, null, nextPage);
    }
    public String get(HttpServletRequest request, Model model, PageState pageState, String nextPage) {

        try {
            MySessionState ss = getSessionState(request);
            addAttributes(request, model);
//            model.addAttribute("sessionErrors", ss.getSessionErrors());

            if (pageState != null)
                model.addAttribute("pageState", pageState);

            Log.d(TAG, String.format("%s GET %s", ss.getId(), request.getRequestURI()));
        } catch (Exception e) {
            Log.d(e);
        }

        return nextPage;
    }

    protected String post(HttpServletRequest request, Model model, String nextPage) {

        try {
            MySessionState ss = getSessionState(request);
            addAttributes(request, model);
            Log.d(TAG, String.format("%s POST %s", ss.getId(), request.getPathInfo()));
        } catch (Exception e) {
            Log.d(e);
        }

        return nextPage;
    }


    protected String showErrorPage(String s, HttpServletRequest request, Model model) {
        Log.e(TAG, s);
        SystemEvent.save(s);
        getSessionState(request).setLastError(s);
        this.addAttributes(request, model);
        return get(request, model, "redirect:/myerror");
    }

    protected String showExceptionPage(Exception e, HttpServletRequest request, Model model) {
        Log.e(TAG, e);
        SystemEvent.save(e.toString());
        getSessionState(request).setLastError(e.toString());
        return "redirect:/myerror";
    }

}
