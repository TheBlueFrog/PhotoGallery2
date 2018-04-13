package com.mike.util;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import org.json.JSONObject;

/**
 * Created by mike on 11/22/2016.
 */
public class Version {

    private String myVersion = "";
    public String getVersion () {
        return myVersion;
    }

    /**
     * construct an as-built code version
     */
    public Version(String v) {
        myVersion = v;
    }

    @Override
    public String toString() {
        return myVersion;
    }

    public Version(JSONObject j) {
        myVersion = j.getString("version");
    }

    public JSONObject toJSON() {

        JSONObject j = new JSONObject();
        j.put("version", myVersion);
        return j;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Version version = (Version) o;

        return myVersion != null ? myVersion.equals(version.myVersion) : version.myVersion == null;
    }

    @Override
    public int hashCode() {
        return myVersion != null ? myVersion.hashCode() : 0;
    }

    public int getMajor() {
        String a[] = myVersion.split("[.]");
        return Integer.parseInt(a[0]);
    }
    public int getMinor() {
        String a[] = myVersion.split("[.]");
        return Integer.parseInt(a[1]);
    }

    public int getBuild() {
        String a[] = myVersion.split("[.]");
        return Integer.parseInt(a[2]);
    }
}
