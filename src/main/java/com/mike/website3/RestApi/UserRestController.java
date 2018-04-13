package com.mike.website3.RestApi;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.Constants;
import com.mike.website3.MySessionState;
import com.mike.website3.db.*;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

import static com.mike.website3.Constants.appSession;

/**
 * Created by mike on 2/13/2017.
 *
 */

@RestController
@RequestMapping("user-api")
public class UserRestController {

    private static class OurResponse {

        private String name = "";
        private List<String> list = new ArrayList<>();

        public OurResponse(String name, String s) {
            this.name = name;
            this.list.add(s);
        }

        public OurResponse(String name, List<String> strings) {
            this.name = name;
            this.list.addAll(strings);
        }

        public String getName() {
            return name;
        }
        public List<String> getList() {
            return list;
        }
    }

    private static class UserResponse {

        private String name = "";
        public String getName() {
            return name;
        }

        private String uuid = "";
        public String getUUID() {
            return uuid;
        }

        public UserResponse(String name, String uuid) {
            this.uuid = uuid;
            this.name = name;
        }
    }

    @RequestMapping(value = "/list", method = RequestMethod.GET, produces = "application/json")
    public List<UserResponse> getWith1(HttpServletRequest request) {

        MySessionState ss = (MySessionState) request.getSession().getAttribute(appSession);
        if (ss != null) {
            User user = ss.getUser();
            if (user != null) {
                if (user.isAnAdmin()) {
                    List<UserResponse> list = new ArrayList<>();
                    User.findAllUsernames().forEach(username ->
                        list.add(new UserResponse(User.findByUsername(username).getName(), username)
                    ));
                    return list;
                }
            }
        }
        return new ArrayList<>();
    }

    @RequestMapping(value = "/get/{username}", method = RequestMethod.GET)//, produces = "application/json")
    public String getWithOp1(HttpServletRequest request, @PathVariable String username) {

        MySessionState ss = (MySessionState) request.getSession().getAttribute(appSession);
        if (ss != null) {
            User user = ss.getUser();
            if (user != null) {
                if (user.isAnAdmin() || (user.getUsername().equals(username))) {
                    // ok, we have a logged in user who has access rights
                    // or is the actual user
                    return getUser(user).toString(4);
                }
            }
        }
        return "/get/" + username + " failed";
    }

    @RequestMapping(value = "/add/{username}/{loginName}", method = RequestMethod.GET)//, produces = "application/json")
    public String getWithOp2(
            @PathVariable String username,
            @PathVariable String loginName,
            HttpServletRequest request) {

        MySessionState ss = (MySessionState) request.getSession().getAttribute(appSession);
        if (ss != null) {
            User user = ss.getUser();
            if (user != null) {
                if (user.isAnAdmin() || (user.getUsername().equals(username))) {
                    // ok, we have a logged in user who has access rights
                    // or is the actual user
                    LoginName x = new LoginName(user.getUsername(), loginName);
                    x.save();
                    x.resetPassword();
                    return getUser(user).toString(4);
                }
            }
        }
        return "/get/" + username + " failed";
    }

    @RequestMapping(value = "/get/{username}/{object}", method = RequestMethod.GET, produces = "application/json")
    public String getWithOp(HttpServletRequest request, @PathVariable String username, @PathVariable String object) {

        MySessionState ss = (MySessionState) request.getSession().getAttribute(appSession);
        if (ss != null) {
            User user = ss.getUser();
            if (user != null) {
                if (user.isAnAdmin() || (user.getUsername().equals(username))) {
                    // ok, we have a logged in user who has access rights
                    // or is the actual user
                    switch (object) {
//                        case "resetCodes":
//                            return getResetCodes(username);// actually login name
                            //break;

                        default: {
                            User target = User.findByUsername(username);
                            if (target != null) {
                                switch (object) {
//                                    case "drops":
//                                        return getDropsPickups(true, target);
//                                    case "pickups":
//                                        return getDropsPickups(false, target);
//                                    case "roles":
//                                        return getRoles(target);
//                                    case "phones":
//                                        return getPhones(target);
//                                    case "emails":
//                                        return getEmails(target);
//                                    case "photos":
//                                        return getPhotos(target);
//                                    case "notes":
//                                        return getNotes(target);
                                    case "name":
                                        return getName(target).toString();
                                    default:
                                        break;
                                }
                            }
                        }
                    }
                }
            }
        }

        return new JSONObject().toString();
    }

    @RequestMapping(value = "/{verb}/{username}/{object}/{value:.+}", method = RequestMethod.GET, produces = "application/json")
    public List<OurResponse> putWithOp(
            HttpServletRequest request,
            @PathVariable String verb,
            @PathVariable String username,
            @PathVariable String object,
            @PathVariable String value) {

        MySessionState ss = (MySessionState) request.getSession().getAttribute(appSession);
        if (ss != null) {
            User user = ss.getUser();
            if (user != null) {
                if (user.isAnAdmin() || (user.getUsername().equals(username))) {
                    // ok, we have a logged in user who has access rights
                    // or is the actual user
                    User target = User.findByUsername(username);
                    if (target != null) {
                        switch (verb) {
                            case "add":
                                return add(target, object, value);
                            case "delete":
                                return delete(user, target, object, value);
                            case "get":
                                return find(target, object, value);
                            case "set":
                                return set(user, target, object, value);
                        }
                    }
                }
            }
        }

        return new ArrayList<>();
    }

    private List<OurResponse> set(User user, User target, String object, String value) {
        switch(object) {
            case "enabled": {
                SystemEvent.save(user, String.format("User %s has setEnabled called with %s, authorized by %s",
                        target.getUsernameShort(), value, user.getUsernameShort()));
                target.setEnabled(Boolean.parseBoolean(value));
                target.save();
                List<OurResponse> x = new ArrayList<>();
                x.add(new OurResponse("user", getUser(target).toString(4)));
                return x;
            }
        }
        return new ArrayList<>();
    }

    @RequestMapping(value = "/{verb}/{username}/{object}/{id}/{value:.+}", method = RequestMethod.GET, produces = "application/json")
    public List<OurResponse> putWithOps(
            HttpServletRequest request,
            @PathVariable String verb,
            @PathVariable String username,
            @PathVariable String object,
            @PathVariable String id,
            @PathVariable String value) {

        MySessionState ss = (MySessionState) request.getSession().getAttribute(appSession);
        if (ss != null) {
            User user = ss.getUser();
            if (user != null) {
                if (user.isAnAdmin() || (user.getUsername().equals(username))) {
                    // ok, we have a logged in user who has access rights
                    // or is the actual user
                    User target = User.findByUsername(username);
                    if (target != null) {
                        switch (verb) {
                            case "set":
                                return set(user, target, object, id, value);
                        }
                    }
                }
            }
        }

        return new ArrayList<>();
    }

    @RequestMapping(value = "/reset/{loginname}/{object}", method = RequestMethod.GET, produces = "application/json")
    public List<OurResponse> putWithOp2(
            HttpServletRequest request,
            @PathVariable String loginname,
            @PathVariable String object) {

        MySessionState ss = (MySessionState) request.getSession().getAttribute(appSession);
        if (ss != null) {
            LoginName loginName = LoginName.findByLoginName(loginname).get(0);
            User user = ss.getUser();
            if (user != null) {
                if (user.isAnAdmin() || (user.getUsername().equals(loginName.getUserId()))) {
                    // ok, we have a logged in user who has access rights
                    // or is the actual user
                    User target = User.findByUsername(loginName.getUserId());
                    if (target != null) {
                        switch (object) {
                            case "password":
                                SystemEvent.save(user, String.format("User %s password reset, authorized by %s",
                                        target.getUsernameShort(), user.getUsernameShort()));
                                return resetPassword(loginname, target);
                        }
                    }
                }
            }
        }

        return new ArrayList<>();
    }

    private List<OurResponse> resetPassword(String loginname, User user) {
        List<OurResponse> results = new ArrayList<>();
        user.resetPassword(loginname);
        results.add(new OurResponse("password", ""));
        return results;
    }

    private List<OurResponse> set(User auth, User user, String object, String id, String value) {
        List<OurResponse> results = new ArrayList<>();
        switch (object) {
            default:
                break;
        }
        return results;
    }

    private List<OurResponse> add(User user, String object, String value) {
        List<OurResponse> results = new ArrayList<>();
        switch (object) {
            case "role": {
                user.addRole(UserRole.Role.valueOf(value));
                return getRoles(user);
            }
            case "phone": {
                PhoneNumber p = new PhoneNumber(user, value);
                p.save();
                return getPhones(user);
            }
            case "email": {
                EmailAddress p = new EmailAddress(user, value);
                p.save();
                return getEmails(user);
            }
            case "photo": {
                UserImage p = new UserImage(user, "", value, "");   // empty caption
                p.save();
                return getPhotos(user);
            }

            default:
                break;
        }
        return results;
    }

    private List<OurResponse> delete(User auth, User user, String object, String value) {
        List<OurResponse> results = new ArrayList<>();
        switch (object) {
            case "roles": {
                SystemEvent.save(user, String.format("User %s has role deleted %s, authorized by %s",
                        user.getUsernameShort(), value, auth.getUsernameShort()));
                user.removeRole(UserRole.Role.valueOf(value));
                return getRoles(user);
            }
            case "phones": {
                user.removePhone(value);
                return getPhones(user);
            }
            case "emails": {
                user.removeEmail(value);
                return getEmails(user);
            }
            case "photos": {
                user.removeMatchingImages(value);
                return getPhotos(user);
            }

            default:
                break;
        }
        return results;
    }

    private List<OurResponse> find(User user, String object, String value) {
        List<OurResponse> results = new ArrayList<>();
        switch (object) {
            case "notes": {
                List<String> list = new ArrayList<>();
                results.add(new OurResponse("Notes", list));
                return results;
            }

            default:
                break;
        }
        return results;
    }

    private List<OurResponse> getRoles(User user) {
        List<OurResponse> results = new ArrayList<>();
        String rs = "";
        for (UserRole role : UserRole.findAllByUserId(user.getUsername()))
            rs = rs.concat(" ").concat(role.getRole().toString());
        results.add(new OurResponse("Roles", rs));
        return results;
    }

    private JSONObject getUser(User user) {
        JSONObject u = new JSONObject();
        u.put("username", user.getUsername());
        u.put("companyName", user.getCompanyName());
        u.put("enabled", user.getEnabled());

        {
            JSONArray logins = new JSONArray();
            LoginName.findAllByUserId(user.getUsername()).forEach(login -> {
                JSONObject loginJ = new JSONObject();
                loginJ.put("name", login.getLoginName());
                if (login.hasPasswordBeenReset()) {
                    loginJ.put("resetCode", login.getPwHash());
                    loginJ.put("resetURL", String.format(
                            "http://%s/reset-password/%s/%s",
                            Constants.Web.DNS_NAME,
                            login.getLoginName(),
                            login.getPwHash()));
                }
                logins.put(loginJ);
            });
            u.put("logins", logins);
        }
        {
            JSONArray emails = new JSONArray();
            EmailAddress.findByUserId(user.getUsername()).forEach(email -> {
                JSONObject emailJ = new JSONObject();
                emailJ.put("email", email.getEmail());
                emails.put(emailJ);
            });
            u.put("emails", emails);
        }

        return u;
    }

    private List<OurResponse> getNotes(User user) {
        List<OurResponse> results = new ArrayList<>();
        List<String> list = new ArrayList<>();
        results.add(new OurResponse("Notes", list));
        return results;
    }

    private JSONObject getName(User user) {
        JSONObject j = new JSONObject();
        j.put("username", user.getUsername());

        Address address = user.getAddress(Address.Usage.Default);
        j.put("firstName", address.getFirstName());
        j.put("lastName", address.getLastName());
        return j;
    }

    private List<OurResponse> getPhones(User user) {

        List<OurResponse> results = new ArrayList<>();
        List<String> list = new ArrayList<>();
        user.getPhoneNumbers().forEach(pn -> list.add(pn.getPhoneNumber()));
        results.add(new OurResponse("Phones", list));
        return results;
    }

    private List<OurResponse> getEmails(User user) {

        List<OurResponse> results = new ArrayList<>();
        List<String> list = new ArrayList<>();
        user.getEmailAddresses().forEach(pn -> list.add(pn.getEmail()));
        results.add(new OurResponse("Emails", list));
        return results;
    }

    private List<OurResponse> getPhotos(User user) {

        List<OurResponse> results = new ArrayList<>();
        List<String> list = new ArrayList<>();
        UserImage x = user.getMainImage();
        if (x != null) {
            list.add(x.toString());
        }
        results.add(new OurResponse("Photos", list));
        return results;
    }

    private List<OurResponse> getResetCodes(String loginname) {

        List<OurResponse> results = new ArrayList<>();
        List<String> list = new ArrayList<>();

        List<LoginName> loginName = LoginName.findByLoginName(loginname);
        if (loginName.size() == 1) {
            if (loginName.get(0).getPwHash().length() == Constants.Code.RESET_PW_LENGTH) {
                // this login has been reset
                list.add(String.format("%s", loginName.get(0).getPwHash()));
            }
        }
        results.add(new OurResponse("resetCode", list));
        return results;
    }

//    public List<Stop> getStopsOf(Route route, boolean delivery, User user) {
//
//        String username = user.getUsername();
//
//        List<Stop> s = new ArrayList<>();
//        if (delivery) {
//            route.getStops().stream()
//                    .filter(stop -> (stop.isDelivery()))
//                    .filter(stop -> (stop.getBuyer().getUsername().equals(username)))
//                    .forEach(stop -> s.add(stop)
//                    );
//        }
//        else {
//            route.getStops().stream()
//                    .filter(stop -> (stop.isPickup()))
//                    .filter(stop -> (stop.getSeller().getUsername().equals(username)))
//                    .forEach(stop -> s.add(stop)
//                    );
//        }
//        return s;
//    }

}

