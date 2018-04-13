package com.mike.website3.db;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.MySystemState;
import com.mike.website3.Website;
import com.mike.website3.db.repo.SystemNoticeRepo;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Created by mike on 11/6/2016.
 */
@Entity
@Table(name="system_notices")
public class SystemNotice implements Serializable {

    private static final long serialVersionUID = 88819398703950134L;


    @Id
    @Column(name = "id")                        private String id;      // UUID

    @Column(name = "fromTimestamp")             private Timestamp fromTimestamp;
    @Column(name = "untilTimestamp")            private Timestamp untilTimestamp;
    @Column(name = "body")                      private String body;

    public String getId() { return id; }

    public Timestamp getFromTimestamp() { return fromTimestamp; }
    public Timestamp getUntilTimestamp() { return untilTimestamp; }
    public String getBody() {
        return body;
    }

    protected SystemNotice() { }

    public SystemNotice(Timestamp from, Timestamp until, String body) {
        id = UUID.randomUUID().toString();
        fromTimestamp = from;
        untilTimestamp = until;
        this.body = body;
    }

    /** setup a system notice for this MilkRun's closing */
    static public SystemNotice createSystemNoticeForClosing(Timestamp estClosingTime) {

        // notice goes up at 1am on the closing day, comes down at 7pm PST

        long hourOfNoticeStart = 1;
        long hourOfNoticeEnd = 19;

        // magical dance to convert from UTC to local time, we don't
        // mess with the minutes or seconds

        Instant instant = estClosingTime.toInstant();
        ZoneOffset currentOffset = MySystemState.getInstance().getUIZone().getRules().getOffset(instant);

        LocalDateTime localTimeClosing = LocalDateTime.ofInstant(instant, MySystemState.getInstance().getUIZone());

        int hour = localTimeClosing.getHour();

        LocalDateTime localTimeStartOfNotice = localTimeClosing.plusHours(hourOfNoticeStart - hour);
        Instant startOfNotice = localTimeStartOfNotice.toInstant(currentOffset);

        LocalDateTime localTimeEndOfNotice = localTimeClosing.plusHours(hourOfNoticeEnd - hour);
        Instant endOfNotice = localTimeEndOfNotice.toInstant(currentOffset);

        String body = StringData.findByUserIdAndKey("", "MilkRunClosingBanner").getValue();

        // remove all other similar notices
        SystemNotice.findByBody(body).forEach(systemNotice -> systemNotice.delete());

        SystemNotice notice = new SystemNotice(
                new Timestamp(startOfNotice.toEpochMilli()),
                new Timestamp(endOfNotice.toEpochMilli()),
                body);

        return notice;
    }


    @Override
    public String toString() {
        return String.format("%s, %s, %s, %s",
                this.getId().substring(0, 8),
                this.getFromTimestamp().toString(),
                this.getUntilTimestamp().toString(),
                this.getBody());
    }

    static private SystemNoticeRepo getRepo() {
        return Website.getRepoOwner().getSystemNoticeRepo();
    }

    public void save() {
        getRepo().save(this);
    }
    public void delete() {
        getRepo().delete(this);
    }

    public static List<SystemNotice> findActive() {

        Timestamp now = new Timestamp(MySystemState.getInstance().now());

        List<SystemNotice> notices = Website.getRepoOwner().getSystemNoticeRepo().findAll();
        List<SystemNotice> net = new ArrayList<>();

        notices.forEach(notice -> {
            if (isCurrent(notice)) {
                net.add(notice);
            }
        });

        return net;
    }

    static public List<SystemNotice> findByBody(String body) {
        List<SystemNotice> x = getRepo().findByBody(body);
                return x;
    }

    private static boolean isCurrent(SystemNotice notice) {
        Timestamp now = new Timestamp(MySystemState.getInstance().now());

        if (notice.getUntilTimestamp().before(now)) {
            return false; // history, delete it?
        }

        if (notice.getFromTimestamp().before(now)) {
            // starts before now, ends after now,
            return true;
        }

        return false; // future
    }

    public static void cleanShutdownNotices() {
        getRepo().findAll().forEach(notice -> {
            // they look like this
            //    MilkRun server will be

            if (notice.body.contains("MilkRun server will be"))
                notice.delete();
        });
    }
}
