package com.mike.util;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import java.sql.Date;
import java.sql.Timestamp;

/**
 * Created by mike on 12/21/2016.
 */
public class TimeWindow {

    private long left;
    private long right;

    public TimeWindow (long left, long right) {
        this.left = left;
        this.right = right;
    }

    public TimeWindow(TimeWindow timeWindow) {
        this.left = timeWindow.left;
        this.right = timeWindow.right;
    }

    public boolean inside(Timestamp timestamp) {
        long t = timestamp.getTime();

        return (left < t) && (t < right);
    }

    public TimeWindow expandLeft() {
        TimeWindow expanded = new TimeWindow(this);
        expanded.left -= (14 * com.mike.util.Constants.dayInMilli);
        return expanded;
    }

    public Date getLeftDate() {
        return new Date(left);
    }
    public Date getRightDate() {
        return new Date(right);
    }

    @Override
    public String toString() {
        return String.format("left = %s, right = %s", getLeftDate().toString(), getRightDate().toString());
    }
}
