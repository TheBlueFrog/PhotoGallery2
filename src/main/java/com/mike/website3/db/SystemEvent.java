package com.mike.website3.db;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.util.Util;
import com.mike.website3.MySystemState;
import com.mike.website3.Website;
import com.mike.website3.db.repo.SystemEventRepo;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;
import java.sql.Timestamp;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Created by mike on 11/6/2016.
 */
@Entity
@Table(name="system_events")
public class SystemEvent implements Serializable {

    private static final long serialVersionUID = -2739778471724219646L;

    // to move all the old events to the this table
    //
    // insert into system_events select * from security_events;
    // drop table security_events;

    @Id
    @Column(name = "timestamp")                 private Timestamp timestamp;
    @Column(name = "username")                  private String username = "system";
    @Column(name = "event", columnDefinition="text default ''")  private String event = "";


    public Timestamp getTimestamp() {
        return timestamp;
    }
    public String getTimestampAsString() {
        return Util.timestamp2URL(timestamp);
    }
    public String getUsername() {
        return username;
    }
    public String getEvent() {
        return event;
    }

    protected SystemEvent() { }

    public SystemEvent(User user, String event) {
        timestamp = new Timestamp(MySystemState.getInstance().now());
        username = user != null ? user.getUsername() : "system";
        this.event = trim(event);
    }
    public SystemEvent(String username, String event) {
        timestamp = new Timestamp(MySystemState.getInstance().now());
        this.username = username;
        this.event = trim(event);
    }

    private String trim(String s) {
        if (s.length() < 200)
            return s;

        s = s.replace("  ", " ");
        if (s.length() < 200)
            return s;

        s = s.substring(0, 100) + "..." + s.substring(s.length() - 100, s.length());
        return s;
    }

    @Override
    public String toString() {
        return String.format("%s, %s, %s",
                timestamp.toString(),
                username,
                event);
    }

    /**
     *
     * @return the day of the year this happened on
     */
    public int getDayOfYear () {
        return Util.getDayOfYear(timestamp.getTime());
    }
    public Object getHourOfDay() {
        return Util.getHourOfDay(timestamp.getTime());
    }



    static public SystemEventRepo getRepo() {
        return Website.getRepoOwner().getSystemEventRepo();
    }

    public void save() {
        getRepo().save(this);
    }
    public void delete() {
        getRepo().delete(this);
    }

    public static void save(User user, String event) {
        getRepo().save(new SystemEvent(user, event));
    }
    public static void save(String username, String event) {
        getRepo().save(new SystemEvent(username, event));
    }
    public static void save(String s) {
        new SystemEvent((User) null, s).save();
    }
    public static void save(List<String> list) {
        for(String s : list)
            s = s.replaceAll("  ", " ");

        new SystemEvent((User) null, Util.flatten(list)).save();
    }


    static public List<SystemEvent> findLoginEvents(String userId) {
        List<SystemEvent> x = findByUserIdOrderByTimestampDesc(userId);
        x.addAll(findByEventAndUserIdOrderByTimestampDesc("Login failed", userId));

        Collections.sort(x, new Comparator<SystemEvent>() {
            @Override
            public int compare(SystemEvent o1, SystemEvent o2) {
                return o1.timestamp.compareTo(o2.timestamp);
            }
        });

        return x;
    }

    /**
     * dump records
     * @param days  threshold
     */
    public static void purge(long days) {
        Timestamp cutoff = new Timestamp(MySystemState.getInstance().now() - (days * 24 * 60 * 60 * 1000));
        List<SystemEvent> x = getRepo().findByOrderByTimestampAsc();
        for(SystemEvent s : x) {
            if (s.getTimestamp().before(cutoff))
                s.delete();
            else
                return;
        }
    }

    public static List<SystemEvent> findByEventOrderByTimestampDesc(String event) {
        List<SystemEvent> x = getRepo().findByEventOrderByTimestampDesc(event);
        return x;
    }

    static public class AnEvent {
        private SystemEvent event;

        public AnEvent(SystemEvent o) {
            this.event = o;
        }

        public Timestamp getTimestamp() {
            return event.getTimestamp();
        }
        public String getEvent() {
            return event.getTimestampAsString();
        }
    }

    public static List<SystemEvent> findByEvent(String event) {
        return getRepo().findByEvent(event);
    }
    public static List<SystemEvent> findByEventOrderByTimestampAsc(String event) {
        return getRepo().findByEventOrderByTimestampAsc(event);
    }

    public static List<SystemEvent> findByUserIdOrderByTimestampDesc(String userId) {

        Timestamp cutoff = new Timestamp(MySystemState.getInstance().now() - (60L * 24 * 60 * 60 * 1000L));
        List<SystemEvent> x = getRepo().findByUsernameOrderByTimestampDesc(userId).stream()
                .filter(securityEvent -> securityEvent.getTimestamp().after(cutoff))
                .collect(Collectors.toList());
        return x;
    }
    public static List<SystemEvent> findByEventAndUserIdOrderByTimestampDesc(String event, String userId) {

        Timestamp cutoff = new Timestamp(MySystemState.getInstance().now() - (60L * 24 * 60 * 60 * 1000L));
        List<SystemEvent> x = getRepo().findByEventAndUsernameOrderByTimestampDesc(event, userId).stream()
                .filter(securityEvent -> securityEvent.getTimestamp().after(cutoff))
                .collect(Collectors.toList());
        return x;
    }

    public static List<SystemEvent> findAll() {
        List<SystemEvent> x = getRepo().findAll();
        return x;
    }

    public static List<SystemEvent> findTop200ByEventContainingOrderByTimestampDesc(String s) {
        List<SystemEvent> x = getRepo().findTop200ByEventContainingOrderByTimestampDesc(s);
        return x;
    }
    public static List<SystemEvent> findByEventContainingOrderByTimestampDesc(String s) {
        List<SystemEvent> x = getRepo().findByEventContainingOrderByTimestampDesc(s);
        return x;
    }
}
