package com.mike.website3.RestApi;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.MySessionState;
import com.mike.website3.Website;
import com.mike.website3.db.User;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

import static com.mike.website3.Constants.appSession;

/**
 * Created by mike on 2/13/2017.
 *
 * /verify-api/users/db-disk        synch the db and the /users directory
 *
 */
@RestController
@RequestMapping("verify-api")
public class VerifyUsersRequestController {

    private static class OurResponse {

        private String name = "";
        private List<String> list = new ArrayList<>();

        public OurResponse(String name) {
            this.name = name;
        }

        public OurResponse(String name, String s) {
            this.name = name;
            this.list.add(s);
        }

        public OurResponse(String name, List<String> strings) {
            this.name = name;
            this.list.addAll(strings);
        }

        public void add(String s) {
            list.add(s);
        }

        public String getName() {
            return name;
        }
        public List<String> getList() {
            return list;
        }

    }

    @RequestMapping(value = "/{what}/{operation}", method = RequestMethod.GET, produces = "application/json")
    public OurResponse getWithOp(
            HttpServletRequest request,
            @PathVariable String what,
            @PathVariable String operation) {

        MySessionState ss = (MySessionState) request.getSession().getAttribute(appSession);
        if (ss != null) {
            User user = ss.getUser();
            if (user != null) {
                if (user.isAnAdmin()) {

                    switch (what) {
                        case "users":
                            return verifyUsers(operation);

                        default: {
                            return new OurResponse("error", "unsupported " + what);
                        }
                    }
                }
                else
                    return new OurResponse("error", "You must be logged in with Admin rights");
            }
            else
                return new OurResponse("error", "Not logged in");
        }
        else
            return new OurResponse("error", "No session state");
    }

    private OurResponse verifyUsers(String operation) {
        OurResponse response = new OurResponse("Verify");
        switch (operation) {
            case "db-disk": {
                List<String> diskUsers = new ArrayList<>();
                Arrays.asList(Website.getUserDir().listFiles()).forEach(
                        file -> diskUsers.add(file.getName())
                );

                // filter out some random junk

                diskUsers.remove("users.iml");
                diskUsers.remove("src");


                List<User> dbUsers = User.findByEnabled(true);
                dbUsers.stream()
                    .sorted(new Comparator<User>() {
                        @Override
                        public int compare(User o1, User o2) {
                            return o1.getUsername().compareTo(o2.getUsername());
                        }
                    })
                    .forEach(user -> {
                        checkUserDir(user, response);
                        diskUsers.remove(user.getUsername());
                    });

                diskUsers.forEach(d -> response.add(String.format("Extra on-disk user %s", d)));
                return response;
            }
        }
        return new OurResponse("Error", "unsupported " + operation);
    }

    private void checkUserDir(User user, OurResponse response) {
        File dir = new File(Website.getUserDir(), user.getUsername());
        if (dir.exists())
            response.add(String.format("Exists %s", dir.getPath()));
        else {
            response.add(String.format("Create %s", dir.getPath()));
            dir.mkdir();
        }

        subDir (dir, "images", response);
        subDir (dir, "www", response);
    }

    private void subDir(File parent, String dirName, OurResponse response) {
        File dir = new File(parent, dirName);
        if (dir.exists())
            response.add(String.format("Exists %s", dir.getPath()));
        else {
            response.add(String.format("Create %s", dir.getPath()));
            dir.mkdir();
        }

        File[] files = dir.listFiles();
        for (File f : files)
            response.add(String.format("  %s", f.getName()));
        response.add(String.format("Has %d in %s", files.length, dirName));
    }

}

