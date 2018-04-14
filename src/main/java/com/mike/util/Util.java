package com.mike.util;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.MySystemState;
import com.mike.website3.db.User;

import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.temporal.ChronoField;
import java.util.*;


public class Util
{
    static public String getShortId(String id) {
        return id.length() > 8 ? id.substring(0, 8) : id;
    }

    static public String timestamp2URL (Timestamp t) {
        return t.toString().replace(" ", "+");
    }
    static public Timestamp url2Timestamp (String s) {
        return Timestamp.valueOf(s.replace("+", " "));
    }

    static public String flatten(Map<String, String> map) {
        StringBuilder sb = new StringBuilder();
        for (String s : map.keySet())
            sb.append("(").append(s).append(", ").append(map.get(s)).append("), ");
        if (sb.length() > 2)
            sb.delete(sb.length() - 2, sb.length());
        return sb.toString().replaceAll("[<]", "{").replaceAll("[>]", "}");
    }

    static public String flatten(List<String> v) {
        StringBuilder sb = new StringBuilder();
        for (String s : v)
            sb.append(s).append(", ");
        if (sb.length() > 2)
            sb.delete(sb.length() - 2, sb.length());
        return sb.toString().replaceAll("[<]", "{").replaceAll("[>]", "}");
    }



    /**
     * @param s
     * @return sanitized string
     */
    public static String sanitizeForDB(String s) {
        if (s == null)
            return "";

        // do not do this
        // .replace("'", "''") // Postgres needs "Mike's" mapped into "Mike''s"
        // Postgres will handle it

        return s.trim();
    }

    public static int getDayOfYear(Timestamp timestamp) {
        return getDayOfYear(timestamp.getTime());
    }
    public static int getDayOfYear(long time) {
        Instant instant = Instant.ofEpochMilli(time);
        LocalDateTime gmtTime = LocalDateTime.ofInstant(instant, ZoneId.of("Z"));
        return gmtTime.get(ChronoField.DAY_OF_YEAR);
//        Calendar calendar = Calendar.getInstance();
//        calendar.setTimeInMillis(time);
//        return calendar.get(Calendar.DAY_OF_YEAR);
    }
    public static int getHourOfDay(Timestamp timestamp) {
        return getHourOfDay(timestamp.getTime());
    }
    public static int getHourOfDay(long time) {
        Instant instant = Instant.ofEpochMilli(time);
        LocalTime gmtTime = LocalDateTime.ofInstant(instant, ZoneId.of("Z")).toLocalTime();
        return gmtTime.getHour();
//        Calendar calendar = Calendar.getInstance();
//        calendar.setTimeZone(TimeZone.getDefault());
//        calendar.setTimeInMillis(time);
//        return calendar.get(Calendar.HOUR_OF_DAY);
    }


    public static int getWeekOfYear(Timestamp timestamp) {
        return getWeekOfYear(timestamp.getTime());
    }
    public static int getWeekOfYear(long time) {
        Calendar calendar = Calendar.getInstance();
//        calendar.setTimeZone(TimeZone.getDefault());
        calendar.setTimeInMillis(time);
        return calendar.get(Calendar.WEEK_OF_YEAR);
    }

    public static int getYear(Timestamp timestamp) {
        return getYear(timestamp.getTime());
    }
    public static int getYear(long time) {
        Calendar calendar = Calendar.getInstance();
//        calendar.setTimeZone(TimeZone.getDefault());
        calendar.setTimeInMillis(time);
        return calendar.get(Calendar.YEAR);
    }

    public static String timestamp2String(Timestamp timestamp) {
        return timestamp.toString();
    }

//    public static String timestamp2HumanString(Timestamp then) {
//        SimpleDateFormat df = new SimpleDateFormat();
//        return df.format(then.getTime());
//    }

    static public String formatTime(long ms, String format) {

        SimpleDateFormat sdf = new SimpleDateFormat(format);//"HH:mm:ss.SSS");
//            sdf.setTimeZone(TimeZone.getTimeZone("UTC"));

        if (24 * 60 * 60 * 1000L > ms) {
            return sdf.format(ms);
        } else {
            long days = ms / (24 * 60L * 60L * 1000L);
            return String.format("%d days %s", days, sdf.format(ms));
        }
    }

    public static String formatTimestamp(long millis, String format) {
        return formatTimestamp(new Timestamp(millis), format);
    }
    /**
     * @param timestamp
     * @param format    yyyy-MM-dd'T'HH:mm:ss.SSS
     *                  MMM dd YYYY hh:mm z
     *                  MMM dd YY
     * @return
     */
    public static String formatTimestamp(Timestamp timestamp, String format) {
        DateFormat df = new SimpleDateFormat(format);
        df.setTimeZone(MySystemState.getInstance().getUITimeZone());

        Date date = new Date(timestamp.getTime());
        return df.format(date);
    }

    public static String toComma(List<String> a) {
        StringBuilder sb = new StringBuilder();
        a.forEach(s -> sb.append(s).append(", "));
        if (sb.length() > 2)
            sb.delete(sb.length()-2, sb.length());
        return sb.toString();
    }

    public static String toDots(List<String> a) {
        if (a.size() > 1)
            return String.format("%s (%d more)", a.get(0), a.size()-1);
        else
            return a.get(0);
    }


    public static List<User> sortByLoginName(List<User> users) {

        Collections.sort(users, new Comparator<User>() {
            @Override
            public int compare(User o1, User o2) {
                return o1.getLoginName().compareTo(o2.getLoginName());
            }
        });

        return users;
    }

}
