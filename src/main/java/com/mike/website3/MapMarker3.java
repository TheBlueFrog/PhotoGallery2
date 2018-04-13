package com.mike.website3;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 *
 * in various bits of the UI we present Google maps, this class
 * is a marker on such a map
 */

import com.mike.website3.db.Address;

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
public class MapMarker3 {

    public static enum Color { gray, green , orange, purple, red, white, yellow, black, blue, brown };

    public double lat;
    public double lng;
    public String title;
    public String label;
    public Color color;
    public String url;

    public MapMarker3(Address address, int number, Color color, String title, String url, boolean fuzz) {
        if (fuzz) {
            this.lat = fuzz(address.getLatitude());
            this.lng = fuzz(address.getLongitude());
        }
        else {
            this.lat = address.getLatitude();
            this.lng = address.getLongitude();
        }
        this.label = Integer.toString(number);
        this.title = title;
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
    public String getTitle() { return title; }
    public String getColor() { return "mm_20_" + color.name(); }
    public String getUrl() { return url; }
}

