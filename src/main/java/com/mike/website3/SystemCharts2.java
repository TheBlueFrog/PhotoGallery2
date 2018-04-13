package com.mike.website3;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.util.Log;
import com.mike.util.Util;
import com.mike.website3.MySystemState;
import com.mike.website3.UserActivity;
import com.mike.website3.Website;
import com.mike.website3.db.*;
import javafx.util.Pair;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.sql.Timestamp;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Created by mike on 2/9/2017.
 */
public class SystemCharts2 {
    private static final String TAG = SystemCharts2.class.getSimpleName();

    // charts is a map of stuff, lists, maps etc.
    // FreeMarker will dig through it but we have
    // to go to Object to keep the compiler happy

    Map<String, Object> charts = new HashMap<>();


    public SystemCharts2() {


        getLoginActivity(charts);
        getFailFirstActivity(charts);
    }



    public Map<String, Object> getModel() {
        return charts;
    }



    static public void getLoginActivity(Map<String, Object> charts) {

        List<SystemEvent> events = SystemEvent.findByEventContainingOrderByTimestampDesc("Logged in");
        Map<Integer, List<SystemEvent>> loginsByDay = events.stream()
                .collect(Collectors.groupingBy(event -> event.getDayOfYear()));

        Map<Integer, Timestamp> dayToTimestamp = new HashMap<>();
        loginsByDay.keySet().forEach(day ->
                dayToTimestamp.put(day, loginsByDay.get(day).get(0).getTimestamp()));

        Set<Integer> setDays = new HashSet<>(loginsByDay.keySet());
        List<Integer> sortedDays = new ArrayList<>(setDays);
        Collections.sort(sortedDays);

        List<Map<String, String>> rows = new ArrayList<>();
        charts.put("LoginRows", rows);

        Calendar calendar = Calendar.getInstance();
        for (int day : sortedDays) {
            if (loginsByDay.containsKey(day)) {
                Map<String, String> row = new HashMap<>();
                calendar.setTimeInMillis(dayToTimestamp.get(day).getTime());
                row.put("year", Integer.toString(calendar.get(Calendar.YEAR)));
                row.put("month", Integer.toString(calendar.get(Calendar.MONTH)));
                row.put("day", Integer.toString(calendar.get(Calendar.DAY_OF_MONTH)));

                row.put("logins", String.format("%d", loginsByDay.containsKey(day) ? loginsByDay.get(day).size() : 0));
                rows.add(row);
            }
        }
    }

    static public void getFailFirstActivity(Map<String, Object> charts) {

        List<SystemEvent> fails = SystemEvent.findByEventContainingOrderByTimestampDesc("Incorrect password" );
        Map<Integer, List<SystemEvent>> failsByDay = fails.stream()
                .collect(Collectors.groupingBy(event -> event.getDayOfYear()));

        List<SystemEvent> firsts = SystemEvent.findByEventContainingOrderByTimestampDesc("First login of");
        Map<Integer, List<SystemEvent>> firstsByDay = firsts.stream()
                .collect(Collectors.groupingBy(event -> event.getDayOfYear()));

        Set<Integer> setDays = new HashSet<>(failsByDay.keySet());
        setDays.addAll(firstsByDay.keySet());

        Map<Integer, Timestamp> dayToTimestamp = new HashMap<>();
        setDays.forEach(day -> {
            if (failsByDay.containsKey(day))
                dayToTimestamp.put(day, failsByDay.get(day).get(0).getTimestamp());
            if (firstsByDay.containsKey(day))
                dayToTimestamp.put(day, firstsByDay.get(day).get(0).getTimestamp());
        });

        List<Integer> sortedDays = new ArrayList<>(setDays);
        Collections.sort(sortedDays);

        List<Map<String, String>> rows = new ArrayList<>();
        charts.put("FailFirstRows", rows);

        Calendar calendar = Calendar.getInstance();
        for (int day : sortedDays) {
            if (failsByDay.containsKey(day) || firstsByDay.containsKey(day)) {
                Map<String, String> row = new HashMap<>();
                calendar.setTimeInMillis(dayToTimestamp.get(day).getTime());
                row.put("year", Integer.toString(calendar.get(Calendar.YEAR)));
                row.put("month", Integer.toString(calendar.get(Calendar.MONTH)));
                row.put("day", Integer.toString(calendar.get(Calendar.DAY_OF_MONTH)));

                row.put("fails", String.format("%d", failsByDay.containsKey(day) ? failsByDay.get(day).size() : 0));
                row.put("firsts", String.format("%d", firstsByDay.containsKey(day) ? firstsByDay.get(day).size() : 0));
                rows.add(row);
            }
        }
    }



}


