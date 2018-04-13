package com.mike.website3;

import com.mike.util.Location;
import com.mike.website3.db.Address;
import com.mike.website3.db.User;

import java.util.Set;

/* a supplier has a bunch of consumers, assemble
    some info about this
 */
public class Centroid {

    private final double width;
    private final double height;
    double x = 0;
    double y = 0;


    public Centroid(User supplier, Set<User> consumers) {

        double minX = 10000000000.0;
        double maxX = -10000000000.0;
        double minY = 10000000000.0;
        double maxY = -10000000000.0;

        // find centroid
        for (User consumer : consumers) {
            Location location = consumer.getAddress(Address.Usage.Delivery).getLocation();
            x += location.x;
            y += location.y;

            if (location.x < minX)
                minX = location.x;
            if (location.x > maxX)
                maxX = location.x;
            if (location.y < minY)
                minY = location.y;
            if (location.y > maxY)
                maxY = location.y;
        }

        x = x / (double) consumers.size();
        y = y / (double) consumers.size();

        width = Location.deg2MeterX(maxX - minX);
        height = Location.deg2MeterY(maxY - minY);
    }

    public double distance(Location location) {
        Location loc = new Location(x, y);
        return loc.distance(location);
    }

    // call it (width + height) / 4
    public double radius() {
        return (width + height) / 4.0;
    }
}
