package com.mike.website3.pages.external;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.util.Location;
import com.mike.util.Log;
import com.mike.website3.Constants;
import com.mike.website3.MapMarker;
import com.mike.website3.db.Address;
import com.mike.website3.db.User;
import com.mike.website3.db.UserRole;
import com.mike.website3.pages.BaseController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Created by mike on 11/23/2016.
 */
@Controller
public class MapController extends BaseController {

    private static final String TAG = MapController.class.getSimpleName();

    @RequestMapping(value = "/user-map", method = RequestMethod.GET)
    public String get(HttpServletRequest request, Model model) {

        String nextPage = "user-map";
        try {
            List<MapMarker> markers = new ArrayList<>();

            String userId = request.getParameter("userId");
            if (userId == null) {
                // all users
                User.findByEnabled(true)
                        .stream()
                        .map(user -> {
                            return new MapMarker(user);
                        })
                        .forEach(m -> markers.add(m));

                model.addAttribute("zoom", 8);
            }
            else {
                // one user, maybe some others
                User u = User.findById(userId);
                Location loc = u.getAddress().getLocation();
                if (request.getParameter("closest") != null) {
                    Map<Integer, List<User>> close = User.findByEnabled(true).stream()
                            .filter(user -> ! user.doesRole2(UserRole.Role.AccountPending))
                            .collect(Collectors.groupingBy(user -> (int) (user.getAddress().getLocation().distance(loc) / 100.0)));

                    List<Integer> sortedClose = new ArrayList<>(close.keySet());
                    Collections.sort(sortedClose);
                    while (sortedClose.size() > 6)
                        sortedClose.remove(6);

                    sortedClose.forEach(distance -> {
                                close.get(distance).forEach(user -> {
                                    Address address = user.getAddress();
                                    markers.add(new MapMarker(
                                            address,
                                            MapMarker.Color.white,
                                            user.getName(),
                                            false));
                                });
                            });

                    model.addAttribute("zoom", 8);
                }

                String addressId = request.getParameter("addressId");
                if (addressId == null) {
                    Address.findNewestByUserIdOrderByUsageDesc(u.getId()).forEach(address -> {
                        markers.add(new MapMarker(
                                address,
                                getColor(u, address),
                                getLabel(u, address),
                                false));
                    });
                }
                else {
                    Address address = Address.findById(addressId);
                    markers.add(new MapMarker(
                            address,
                            getColor(u, address),
                            getLabel(u, address),
                            false));
                }

                model.addAttribute("zoom", 10);
            }

            double lat = 0.0;
            double lng = 0.0;
            for (MapMarker mapMarker : markers) {
                lat += mapMarker.getLat();
                lng += mapMarker.getLng();
            }

            model.addAttribute("mapMarkers", markers);
            model.addAttribute("mapLines", false);
            model.addAttribute("centerLat", lat / markers.size());
            model.addAttribute("centerLng", lng / markers.size());
        }
        catch (Exception e) {
            Log.e(TAG, e);
            nextPage = Constants.Web.REDIRECT_EATER_ALPHA_HOME;
        }

        return super.get(request, model, nextPage);
    }

    private String getLabel(User u, Address address) {
        return String.format("%s, %s", address.getName(), address.getUsage().toString());
    }
    private MapMarker.Color getColor(User u, Address address) {
        switch(address.getUsage()) {
            case Default:
                return MapMarker.Color.red;
            default:
                return MapMarker.Color.yellow;
        }
    }


}
