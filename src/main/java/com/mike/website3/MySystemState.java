package com.mike.website3;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.util.DuplicateKeyException;
import com.mike.util.Location;
import com.mike.util.Log;
import com.mike.util.Util;
import com.mike.website3.db.*;
import com.mike.website3.tools.GetCPULoad;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.sql.Timestamp;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Created by mike on 1/3/2017.
 */
public class MySystemState {
    private static final String TAG = MySystemState.class.getSimpleName();

    private static long systemStartTime = 0;
    private static long timeShift = 0;

    private static MySystemState myself = null;

    private String notice = "";


    public static MySystemState getInstance() {
        assert myself != null;
        return myself;
    }

    public MySystemState() {
        assert myself == null;
        myself = this;
    }

    public String getStripeSecretKey() {
        if (Website.isProduction())
            return "sk_live_4674R5wZMYSwgcNQ0vjZaXVs";  // use our live secret key

        // use our test secret key
        return "sk_test_ikqF5zSnsuf0LFiZMW8f8wfK";
    }

    public String getStripePublishableKey() {
        if (Website.isProduction())
            return "pk_live_dVHPlq5kl4YhFeg4YMq4sPQT";

        return "pk_test_4oYUrXnbImBrmsV7W2zRibcM";
    }

    /**
     * @return current time
     */
    public long now() {
        return Instant.now().toEpochMilli(); // gmt.toInstant().toEpochMilli();
    }

    public Timestamp nowTimestamp() {
        return new Timestamp(now());
    }

    public void setNow(long time) {
        assert false;
        // nyi
//        UTCstartTime = time;
    }


    public Map<String, Object> getSite() {
        Map<String, Object> map = new HashMap<>();

        map.put("HomePage", Constants.Web.INDEX_HTML);
        map.put("indexPage", Constants.Web.INDEX_HTML);
        map.put("SiteVersion", Website.builtVersion.getVersion());
        map.put("devEnv", Website.getDevEnv());
        map.put("production", Website.getProduction());

        StringData.findByUserId("").forEach(p -> map.put(p.getKey(), p.getValue()));
        return map;

        //        return SiteGlobals.getInstance().getModel();
    }


    public List<User> getUsers() {
        return User.findByEnabled(true);
    }

    public List<User> getUsersByRoles(String roles) {
        List<UserRole.Role> x = new ArrayList<>();
        String[] a = roles.split("[ ]");
        for (String s : a) {
            try {
                x.add(UserRole.Role.valueOf(s));
            } catch (Exception e) {
                // no such role
                Log.e(TAG, "No such user Role " + s);
            }
        }

        return User.getUsersByRoles(x);
    }

    public List<User> getUsersByRole(UserRole.Role role) {
        return User.getUsersByRole(role);
    }

    private static Random random = new Random();//128754);

    public Random getRandom() {
        return random;
    }


    Map<Long, List<String>> doNotShowNotices = new HashMap<>();

    public List<SystemNotice> getNotices(MySessionState sessionState) {

        return SystemNotice.findActive().stream()
                .filter(notice -> {
                    List<String> v = doNotShowNotices.get(sessionState.getSerialNumber());
                    return true; // ((v != null) && v.contains(notice.getId())) {
                })
                .collect(Collectors.toList());
    }

    public void setNotice(String notice) {
        this.notice = notice;
    }

    // this session has seen the notice, don't show again
    public void clearNotice(MySessionState sessionState, String noticeId) {

        if (doNotShowNotices.keySet().size() > 500)
            doNotShowNotices.clear();   // memory wipe, been up so long getting senile

        if (!doNotShowNotices.containsKey(sessionState.getSerialNumber())) {
            doNotShowNotices.put(sessionState.getSerialNumber(), new ArrayList<>());
        }

        doNotShowNotices.get(sessionState.getSerialNumber()).add(noticeId);
    }

    /**
     * return the recent login activity
     */
    public List<String> getTodaysLogins() {
        Map<Integer, List<SystemEvent>> loginsByDay =
                SystemEvent.findByEventOrderByTimestampAsc("Login").stream()
                        .collect(Collectors.groupingBy(securityEvent -> securityEvent.getDayOfYear()));

        int today = Util.getDayOfYear(getInstance().now());

        List<String> output = new ArrayList<>();
        if (loginsByDay.containsKey(today)) {
            loginsByDay.get(today).forEach(securityEvent -> {
                String un = securityEvent.getUsername();
//                un = un.length() > 8 ? un.substring(0, 8) : un;
                String s = String.format("%s: %s",
                        Util.formatTimestamp(securityEvent.getTimestamp(), "HH:mm z"),
                        un);
                output.add(s);
            });
        }

        return output;
    }


    public List<SystemEvent> getEvents() {
//        Timestamp dayAgo = new Timestamp(now() - (24 * 60 * 60 * 1000L));
        List<SystemEvent> events = SystemEvent.getRepo().findTop200ByOrderByTimestampDesc();
//                .map(se -> String.format("%s %-8.8s %-50.50s",
//                        Util.formatTimestamp(se.getTimestamp(), "HH:mm:ss z"),
//                        se.getUsername(),
//                        se.getEvent()))
//                .collect(Collectors.toList());

//        int today = Util.timeToDayOfYear(getInstance().now());
//
//        List<String> output = new ArrayList<>();
//        if (loginsByDay.containsKey(today)) {
//            loginsByDay.get(today).forEach(securityEvent -> {
//                String un = securityEvent.getUsername();
////                un = un.length() > 8 ? un.substring(0, 8) : un;
//                String s = String.format("%s: %s",
//                        Util.formatTimestamp(securityEvent.getTimestamp(), "HH:mm z"),
//                        un);
//                output.add(s);
//            });
//        }

        return events;
    }


    private List<String> cpuLoad = new ArrayList<>();

    public void checkCPULoad() {
        List<String> a = GetCPULoad.snap("CPU Load " +
                Util.formatTimestamp(
                        new Timestamp(MySystemState.getInstance().now()),
                        "MMM ddd hh:mm a z"));
        if (cpuLoad.size() > 100) {
            for (int i = 0; i < a.size(); ++i)
                cpuLoad.remove(0);
        }
        cpuLoad.addAll(a);
    }

    public List<String> getCPULoad() {
        return cpuLoad;
    }

    static private double fuzz(double d) {
        double f = (random.nextDouble() * 2.0) - 1.0;  // -1.0 .. 1.0
        double displacementM = Location.meter2DegX(f * 70.0);
        return  d + displacementM;
    }

    public double getMetric(String metric) {
        StringData sd = StringData.findByUserIdAndKey("", metric);
        return Double.parseDouble(sd.getValue());
    }

    // get timezone from browser
    public ZoneId getUIZone() {
        return ZoneId.of("America/Los_Angeles");
    }
    public TimeZone getUITimeZone() {
        TimeZone tz = TimeZone.getTimeZone("America/Los_Angeles");
        return tz;
    }

    public String getDefaultState() {
        return StringData.findByUserIdAndKey("", "DefaultState").getValue();
    }

    public static void bootstrap() {

        setup("AutoUnPendSubject", "Auto-unpended user");
        setup("PendingUserIncrementalCostThreshold", "100.0");
//        setup("NextMilkRunClosingTimestamp", Long.toString(getInstance().nowTimestamp().getTime()));
        setup("MaintenanceShutdownBanner", "Maintenance shutdown in 15 minutes");

        // see Java 8 ZoneId.of() for what's supported
        // if the server is supporting a service area that straddles timezones
        // this is not good enough
        setup("ServiceAreaTimezone", "America/Los_Angeles");

        // default state for address records
        setup("DefaultState", "OR");
    }

    // if a system string does not exist set it up with some value
    private static void setup(String key, String value) {

        if (StringData.findByUserIdAndKey("", key) == null) {
            try {
                new StringData("", key, value)
                        .save();
            } catch (DuplicateKeyException e) {
                Log.e(TAG, e);
            }
        }
    }

    // produce the depot User object, eventually this will probably
    // take some parameters to pick the right depot, maybe
    public User getDepot() {
        List<User> depots = User.findByRole(UserRole.Role.Depot);
        if (depots.size() > 0)
            return depots.get(0);
        return null;
    }
}
