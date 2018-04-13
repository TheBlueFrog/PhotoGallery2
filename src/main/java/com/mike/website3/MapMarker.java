package com.mike.website3;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 *
 * in various bits of the UI we present Google maps, this class
 * is a marker on such a map
 */

import com.mike.website3.db.Address;
import com.mike.website3.db.User;
import com.mike.website3.db.UserRole;

/**
 * Created by mike on 12/9/2016.
 *
 * from here
 * https://sites.google.com/site/gmapsdevelopment/
 *
     mm_20_gray
     mm_20_green
     mm_20_orange
     mm_20_purple
     mm_20_red
     mm_20_white
     mm_20_yellow
     mm_20_black
     mm_20_blue
     mm_20_brown
 */
public class MapMarker {

    public static enum Color { gray, green , orange, purple, red, white, yellow, black, blue, brown };

    public double lat;
    public double lng;
    public String label;
    public Color color;
    public String url;

    public MapMarker(double lat, double lng, String label, Color color, String url) {
        this.lat = fuzz(lat);
        this.lng = fuzz(lng);
        this.label = label;
        this.color = color;
        this.url = url;
    }

    public MapMarker(Address address, Color color, String label) {
        this.lat = fuzz(address.getLocation().y);
        this.lng = fuzz(address.getLocation().x);
        this.label = label;
        this.color = color;
        this.url = "";
    }
    public MapMarker(Address address, Color color, String label, boolean fuzz) {
        if (fuzz) {
            this.lat = fuzz(address.getLatitude());
            this.lng = fuzz(address.getLongitude());
        }
        else {
            this.lat = address.getLatitude();
            this.lng = address.getLongitude();
        }
        this.label = label;
        this.color = color;
        this.url = "";
    }
    public MapMarker(Address address, Color color, String label, String url, boolean fuzz) {
        if (fuzz) {
            this.lat = fuzz(address.getLatitude());
            this.lng = fuzz(address.getLongitude());
        }
        else {
            this.lat = address.getLatitude();
            this.lng = address.getLongitude();
        }
        this.label = label;
        this.color = color;
        this.url = url;
    }

    public MapMarker(User user) {
        Color color = user.doesRole2(UserRole.Role.Seeder)
                ? Color.red
                : user.doesRole2(UserRole.Role.Feeder)
                    ? Color.blue
                    : Color.green;
        init (user.getAddress(),
                color,
                user.getCompanyName().length() > 0
                        ? user.getCompanyName()
                        : user.getName(),
                user.getPublicHomePageURL(),
                user.locationFuzzRequested());
    }

    public MapMarker(User user, Color color) {
        init (user.getAddress(), color, "", "", false);
    }
    public MapMarker(User user, Color color, String url) {
        init (user.getAddress(),
                color,
                user.getCompanyName().length() > 0
                ? user.getCompanyName()
                : user.getName(),
                url,
                user.locationFuzzRequested());
    }


    private void init(Address address, Color color, String label, String url, boolean fuzz) {
        if (fuzz) {
            this.lat = fuzz(address.getLatitude());
            this.lng = fuzz(address.getLongitude());
        }
        else {
            this.lat = address.getLatitude();
            this.lng = address.getLongitude();
        }

        this.label = label;
        this.color = color;
        this.url = url;
    }

    /** for user privacy we fuzz the location some
     *
     * my house location is
     *
         45.54491695209853  45.560657
        -122.8046093131127  -122.640623

        a nearby place the is the edge of the area we
        want to fuzz my location to

        45.543923 -122.804465

        so we multiply up, round and divide back down to
        lose enough precision.
     */

    private double fuzzFactor = 600.0;


    private double fuzz(double d) {
        return  Math.round(d * fuzzFactor) / fuzzFactor;
    }

    public double getLat() { return lat; }
    public double getLng() { return lng; }
    public String getLabel() { return label; }
    public String getColor() { return "mm_20_" + color.name(); }
    public String getUrl() { return url; }
}

