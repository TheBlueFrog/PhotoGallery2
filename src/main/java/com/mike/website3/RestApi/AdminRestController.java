package com.mike.website3.RestApi;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.util.Log;
import com.mike.util.Util;
import com.mike.website3.MySessionState;
import com.mike.website3.Website;
import com.mike.website3.db.*;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import static com.mike.website3.Constants.appSession;

/**
 * Created by mike on 2/13/2017.
 *

 /admin-api/get/outgoing-email
        return a list of outgoing email that needs to be sent

 */

@RestController
@RequestMapping("admin-api")
public class AdminRestController {

    private static final String TAG = AdminRestController.class.getSimpleName();


    @RequestMapping(value = "/pending-accounts/get", method = RequestMethod.GET, produces = "application/json")
    public String get3(HttpServletRequest request, Model model) {
        try {
            JSONObject j = new JSONObject();
            JSONArray jpending = new JSONArray();
            j.put("pendingAccounts", jpending);

            User.findPending(false).forEach(user -> {
                JSONObject juser = new JSONObject();
                juser.put("id", user.getUsername());
                juser.put("name", user.getName());

                jpending.put(juser);

                Log.d(TAG, String.format("Checked for pending users"));
            });

            return j.toString();
        } catch (Exception e) {
            JSONObject j = new JSONObject();
            j.put("status", e.getMessage());
            return j.toString();
        }
    }

    @RequestMapping(value = "enable", method = RequestMethod.GET, produces = "application/text")
    public String get4a(HttpServletRequest request, Model model) {
        try {
            boolean emailOnStage = request.getParameter("emailOnStage").equals("true");
            Website.setEmailEnabled(emailOnStage);
            return "ok";
        } catch (Exception e) {
            return e.toString();
        }
    }

//    var url = "/admin-api/get-user-list?filters=" + filters + "&columns=" + columns;
    @RequestMapping(value = "/get-user-list", method = RequestMethod.GET, produces = "application/text")
    public String get4b(HttpServletRequest request, Model model) {
        try {
            // assemble filtered list of users
            String filtersS = request.getParameter("filters");
            String[] filters = filtersS.split("[,]"); // "eater, seeder..."
            List<UserRole.Role> roles = new ArrayList<>();
            for (String f : filters)
                roles.add(UserRole.Role.valueOf(f));

            List<User> x = User.findByEnabled(true).stream()
                    .filter(user -> filterByRoles(user, roles))
                    .collect(Collectors.toList());

            List<User> list = Util.sortByLoginName(x);

            // assemble columns
            String columnsS = request.getParameter("columns");
            String[] columns = columnsS.split("[,]"); // "email, lastName..."

            return "";//MySystemState.dump(list, Arrays.asList(columns));
        }
        catch (Exception e) {
            return e.toString();
        }
    }

    private boolean filterByRoles(User user, List<UserRole.Role> roles) {
        for(UserRole.Role r : roles)
            if (user.doesRole2(r))
                return true;
        return false;
    }

//    @RequestMapping(value = "/delete/address", method = RequestMethod.GET, produces = "application/text")
//    public String get4f(HttpServletRequest request, Model model) {
//        try {
//            MySessionState ss = (MySessionState) request.getSession().getAttribute(appSession);
//
//            User admin = ss.getUser();
//            if ((admin == null || ( ! admin.isAnAdmin())))
//                return "Unauthorized Access";
//
//            String addressId = request.getParameter("addressId");
//
//            Address address = Address.findById(addressId);
//            if (address == null)
//                return "No such record " + addressId;
//
//            if (MilkRunDB.inUseByActiveMilkRun(address))
//                return "In use by active MilkRun";
//
//            List<Address> addresses = Address.findByUserIdOrderById(address.getUserId());
//            // remove the one being dropped from the list
//            addresses.remove(findIndexOf(address, addresses));
//
//            // see if this is a good configuration
//
//            User user = User.findByUserId(address.getUserId());
//            if (   user.doesRole2(UserRole.Role.Eater)
//                && ( ! user.doesRole2(UserRole.Role.Seeder))
//                && hasAddress(addresses, Address.Usage.Default)
//                && hasAddress(addresses, Address.Usage.Delivery))
//            {
//                address.delete();
//                return "OK";
//            }
//
//            if (   hasAddress(addresses, Address.Usage.Default)
//                && hasAddress(addresses, Address.Usage.Delivery)
//                && hasAddress(addresses, Address.Usage.Pickup))
//            {
//                address.delete();
//                return "OK";
//            }
//
//            return "Prohibited";
//        } catch (Exception e) {
//            return e.toString();
//        }
//    }

    @RequestMapping(value = "/reset-login", method = RequestMethod.GET, produces = "application/text")
    public String get4g(HttpServletRequest request, Model model) {
        try {
            MySessionState ss = (MySessionState) request.getSession().getAttribute(appSession);

            String loginNameS = request.getParameter("loginName");
            User user = User.findByLoginName(loginNameS);

            if (user.hasPasswordBeenReset()) {
                return String.format("The login %s has already been reset.");
            }

            user.resetPassword();

            SystemEvent.save(user, String.format("LoginName %s reset by user.",
                    user.getLoginName(),
                    user.getId()));

            return "OK";

        } catch (Exception e) {
            return e.toString();
        }
    }

//    var url = "/stripe-charge-user/set?userId=" + userId;
    @RequestMapping(value = "/stripe-charge-user/set", method = RequestMethod.GET, produces = "application/text")
    public String get4h(HttpServletRequest request, Model model) {
        try {
            MySessionState ss = (MySessionState) request.getSession().getAttribute(appSession);

            String loginNameS = request.getParameter("userId");
            ss.setAttribute(request, "testStripeChargeUserId");

            return "OK";

        } catch (Exception e) {
            return e.toString();
        }
    }

}


