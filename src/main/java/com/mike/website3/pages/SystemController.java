package com.mike.website3.pages;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.MySystemState;
import com.mike.website3.SystemCharts2;
import com.mike.website3.db.User;
import com.mike.website3.tools.TakeDBSnapshot;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class SystemController extends BaseController {
    private static final String TAG = SystemController.class.getSimpleName();

    // access to admin function pages
    @RequestMapping(value = "/admin", method = RequestMethod.GET)
    public String get1(HttpServletRequest request, Model model) {

        try {
            User user = getSessionUser(request);
            if ((user == null) || ( ! user.isAnAdmin()))
                return showErrorPage("Unauthorized Access", request, model);

            model.addAttribute("recentLogins", MySystemState.getInstance().getTodaysLogins());
            model.addAttribute("dbSnapshot", dbSnapshotOutput);
            model.addAttribute("milkrunFilesRefreshOutput", milkrunFilesRefreshOutput);

            Map<String, Object> charts = new HashMap<>();
            SystemCharts2.getFailFirstActivity(charts);
            SystemCharts2.getLoginActivity(charts);
            model.addAttribute("charts", charts);

            this.addAttributes(request, model);
            return super.get(request, model, "admin");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }
    @RequestMapping(value = "/admin2", method = RequestMethod.GET)
    public String get12a(HttpServletRequest request, Model model) {

        try {
            User user = getSessionUser(request);
            if ((user == null) || ( ! user.isAnAdmin()))
                return showErrorPage("Unauthorized Access", request, model);

            model.addAttribute("recentLogins", MySystemState.getInstance().getTodaysLogins());
            model.addAttribute("dbSnapshot", dbSnapshotOutput);
            model.addAttribute("milkrunFilesRefreshOutput", milkrunFilesRefreshOutput);

            this.addAttributes(request, model);
            return super.get(request, model, "admin2");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

//    @RequestMapping(value = "/system", method = RequestMethod.GET)
//    public String get(HttpServletRequest request, Model model) {
//        try {
//            User user = getSessionUser(request);
//            if ((user == null) || ( ! user.isAnAdmin()))
//                return showErrorPage("Unauthorized Access", request, model);
//
//            model.addAttribute("systemCharts", SystemCharts.getSystemCharts ());
//            model.addAttribute("chartData", Charts.getChartingData());
//            this.addAttributes(request, model);
//            return super.get(request, model, "system");
//        }
//        catch (Exception e) {
//            return showExceptionPage(e, request, model);
//        }
//    }

    @RequestMapping(value = "/system-charts2", method = RequestMethod.GET)
    public String get11(HttpServletRequest request, Model model) {
        try {
            User user = getSessionUser(request);
            if ((user == null) || ( ! user.isAnAdmin()))
                return showErrorPage("Unauthorized Access", request, model);

            model.addAttribute("systemCharts", new SystemCharts2().getModel());
            this.addAttributes(request, model);
            return super.get(request, model, "system-charts2");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }


    List<String> dbSnapshotOutput = new ArrayList<>();

    @RequestMapping(value = "/admin/db-snapshot", method = RequestMethod.GET)
    public String get10(HttpServletRequest request, Model model) {
        try {
            User user = getSessionUser(request);
            if ((user == null) || ( ! user.isAnAdmin()))
                return showErrorPage("Unauthorized Access", request, model);

//            List<String> args = new ArrayList<>();
//            if (TakeDBSnapshot.isWindows)
//                args.add("dir");    // not supported
//            else
//                args.add("../../take-snapshot");

            dbSnapshotOutput = TakeDBSnapshot.snap("REST API snapshot");

            this.addAttributes(request, model);
            return super.get(request, model, "redirect:/admin");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

    List<String> milkrunFilesRefreshOutput = new ArrayList<>();


    @RequestMapping(value = "/nrfpty", method = RequestMethod.GET)
    public String get8(HttpServletRequest request, Model model) {
        try {
            User user = getSessionUser(request);
            if ((user == null) || (!user.isAnAdmin()))
                return showErrorPage("Unauthorized Access", request, model);

            return super.get(request, model, "nrfpty");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

    @RequestMapping(value = "/user-logins", method = RequestMethod.GET)
    public String get5(HttpServletRequest request, Model model) {
        try {
            User user = getSessionUser(request);
            if ((user == null) || (!user.isAnAdmin()))
                return showErrorPage("Unauthorized Access", request, model);

            return super.get(request, model, "user-logins");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

}
