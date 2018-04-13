package com.mike.website3.RestApi;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.MySessionState;
import com.mike.website3.MySystemState;
import com.mike.website3.db.SystemNotice;
import com.mike.website3.db.User;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;

import static com.mike.website3.Constants.appSession;
import static com.mike.website3.db.SystemNotice.createSystemNoticeForClosing;

/**
 * Created by mike on 2/13/2017.
 *
 */
@RestController
@RequestMapping("session-api")
public class SessionRestController {

    @RequestMapping(value = "/clear/notice/{id}", method = RequestMethod.GET, produces = "application/text")
    public String get(@PathVariable String id,
                      HttpServletRequest request) {

        MySessionState ss = (MySessionState) request.getSession().getAttribute(appSession);
        MySystemState systemState = MySystemState.getInstance();

        if (ss != null) {
            systemState.clearNotice(ss, id);
            return "OK";
        }

        return "Error";
    }

    @RequestMapping(value = "/create/notice/shutdown", method = RequestMethod.GET, produces = "application/text")
    public String get1(HttpServletRequest request) {

        try {
            MySessionState state = (MySessionState) request.getSession().getAttribute(appSession);
            if (state == null)
                return "Error";

            MySystemState systemState = MySystemState.getInstance();
            User user = state.getUser();
            if ((user == null) || (!user.isAnAdmin()))
                return "Error";

            int delayMin = Integer.parseInt(request.getParameter("delay"));
            Timestamp thenUTC = new Timestamp(MySystemState.getInstance().now() + (delayMin * 60 * 1000L));

            Instant instant = thenUTC.toInstant();
            ZoneOffset currentOffset = MySystemState.getInstance().getUIZone().getRules().getOffset(instant);

            LocalDateTime localTime = LocalDateTime.ofInstant(instant, MySystemState.getInstance().getUIZone());
            Instant instantLocal = localTime.toInstant(currentOffset);

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM d, HH:mm");
            String s = localTime.format(formatter);

            SystemNotice notice = new SystemNotice(
                    new Timestamp(MySystemState.getInstance().now()),
                    new Timestamp(instant.toEpochMilli()),
                    String.format("MilkRun server will be shut down at %s for maintenance, back up shortly.",
                            s));
            notice.save();
            return "OK";
        }
        catch (Exception e) {
            return e.getMessage();
        }
    }

    @RequestMapping(value = "/create/notice/milkrunClosing", method = RequestMethod.GET, produces = "application/text")
    public String get2(HttpServletRequest request) {

        MySessionState ss = (MySessionState) request.getSession().getAttribute(appSession);
        MySystemState systemState = MySystemState.getInstance();

        if (ss != null) {
            User user = ss.getUser();
            if ((user != null) &&(user.isAnAdmin())) {

                SystemNotice notice = createSystemNoticeForClosing(MilkRunDB.findOpen().getEstClosingTimestamp());

//                // magical dance to figure out when 7pm PDT today is in UTC
//
//                Instant instant = Instant.now();
//                ZoneOffset currentOffset = MySystemState.getInstance().getUIZone().getRules().getOffset(instant);
//
//                LocalDateTime localTimeNow = LocalDateTime.ofInstant(instant, MySystemState.getInstance().getUIZone());
//
//                int hour = localTimeNow.getHour();
//                LocalDateTime localTimeThen = localTimeNow.plusHours(19 - hour);
//                int minute = localTimeNow.getMinute();
//                localTimeThen = localTimeThen.minusMinutes(minute);
//
//                Instant then = localTimeThen.toInstant(currentOffset);
//
//                SystemNotice notice = new SystemNotice(
//                        new Timestamp(MySystemState.getInstance().now()),
//                        new Timestamp(then.toEpochMilli()),
//                        String.format(StringData.findByUserIdAndKey("", "MilkRunClosingBanner").getValue()));

                notice.save();
                return "OK";
            }
        }

        return "Error";
    }


    // this method gets called by page loads to clear transitory
    // state we are showing to users
    //
    @RequestMapping(value = "/clear-page-state", method = RequestMethod.GET, produces = "application/text")
    public String get7(HttpServletRequest request) {

//        MySessionState sessionState = (MySessionState) request.getSession().getAttribute(appSession);
//        sessionState.clearSessionErrors();
//        sessionState.putPageData(request.getParameter("pageName"), null);
        return "OK";
    }

    @RequestMapping(value = "/milkrun/set", method = RequestMethod.GET, produces = "application/text")
    public String get9(HttpServletRequest request) {

        MySessionState ss = (MySessionState) request.getSession().getAttribute(appSession);
        String milkRunId = request.getParameter("milkRunId");
        String color = request.getParameter("color");

        MilkRunDB m = MilkRunDB.findById(milkRunId);
        m.setColor("#" + color);
        m.save();
        return "OK";
    }

    @RequestMapping(value = "/set-attribute", method = RequestMethod.GET, produces = "application/text")
    public String get10(HttpServletRequest request) {

        MySessionState ss = (MySessionState) request.getSession().getAttribute(appSession);

        String name = request.getParameter("name");
        String typeS = request.getParameter("type");
        String valueS = request.getParameter("value");

        switch (typeS) {
            case "boolean":
                ss.setAttribute(name, Boolean.parseBoolean(valueS));
                break;
            case "string":
                ss.setAttribute(name, valueS);
                break;
            default:
                return "Unsupported type " + typeS;
        }
        return "OK";
    }
}

