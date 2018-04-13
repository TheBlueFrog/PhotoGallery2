package com.mike.website3.db;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.util.Util;
import com.mike.website3.MySystemState;
import com.mike.website3.Website;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Created by mike on 11/6/2016.
 *
 * database CRUD class to hold database configuration notes
 * to myself.
 */
@Entity
@Table(name="database_config")
public class DatabaseConfig implements Serializable {

    private static final String TAG = DatabaseConfig.class.getSimpleName();

    @Id
    @Column(name = "timestamp")                 private Timestamp timestamp;
    @Column(name = "defect")                    private String defect;
    @Column(name = "text")                      private String note;

    public Timestamp getTimestamp() { return timestamp; }
    public String getDefect() { return defect; }
    public String getNote() {
        return note;
    }

    public String getTimestampAsString() { return Util.timestamp2String(timestamp); }

    public void setNote(String note) {
        this.note = note;
    }


    protected DatabaseConfig() { }

    public DatabaseConfig(String defect, String note) {

        timestamp = new Timestamp(MySystemState.getInstance().now());
        this.defect = defect;
        this.note = note;
    }

    public void save() {
        Website.getRepoOwner().getDatabaseConfigRepo().save(this);
        String s = String.format("Database configuration changed: %s, %s", this.defect, this.note);
        SystemEvent.save("system", s);
    }
    public void delete() {
        Website.getRepoOwner().getDatabaseConfigRepo().delete(this);
    }

    public static DatabaseConfig findByDefect(String defect) {
        return Website.getRepoOwner().getDatabaseConfigRepo().findByDefect(defect);
    }


}
