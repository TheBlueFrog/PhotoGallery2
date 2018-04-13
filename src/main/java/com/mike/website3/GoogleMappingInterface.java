package com.mike.website3;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.google.maps.GeoApiContext;
import com.google.maps.GeocodingApi;
import com.google.maps.model.GeocodingResult;
import com.mike.exceptions.InvalidAddressException;
import com.mike.util.Location;
import com.mike.util.Log;
import com.mike.website3.db.Address;

/**
 * Created by mike on 12/11/2016.
 */

/*
https://maps.googleapis.com/maps/api/directions/json?
                    origin=45.241249,-122.630608&
                    destination=45.241249,-122.630608&
                    waypoints=optimize:true|45.544849,-122.804584|45.305396,-122.766336&
                    key=AIzaSyC3Nr29CX8z1ELKyCsGs2WVdAEGdDadflY

https://maps.googleapis.com/maps/api/directions/json?
                    origin=45.241249,-122.630608&
                    destination=45.241249,-122.630608&
                    waypoints=optimize:true|45.544849,-122.804584|45.305396,-122.766336&
                    key=AIzaSyC3Nr29CX8z1ELKyCsGs2WVdAEGdDadflY

https://maps.googleapis.com/maps/api/directions/json?origin=45.241249,-122.630608&destination=45.544849,-122.804584&key=AIzaSyC3Nr29CX8z1ELKyCsGs2WVdAEGdDadflY

*/

public class GoogleMappingInterface {

    static private final String APIKey = "AIzaSyC3Nr29CX8z1ELKyCsGs2WVdAEGdDadflY";

    private static String loc(Location location) {
        return Double.toString(location.y) + "," + Double.toString(location.x);
    }

    public static Location geocode(Address address) throws InvalidAddressException {
        GeocodingResult[] results = new GeocodingResult[0];

        try {
            GeoApiContext context = new GeoApiContext.Builder()
                    .apiKey(APIKey)
                    .build();
            results = GeocodingApi.geocode(context, address.getGoogleStreetAddress()).await();
        } catch (Exception e) {
            Log.d(e);
        }

//        System.out.println(results[0].formattedAddress);
        if (results.length > 0)
            return new Location(results[0].geometry.location.lng, results[0].geometry.location.lat);

        throw new InvalidAddressException(
                String.format("Google address lookup failed for user %s",
                        address.getName()));
//        else
//            return new Location(-122.679372, 45.518859);    // Pioneer Square, feed the homeless
    }
}


