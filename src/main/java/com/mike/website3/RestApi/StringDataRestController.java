package com.mike.website3.RestApi;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.db.StringData;
import com.mike.website3.db.repo.StringDataRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Optional;

/**
 * Created by mike on 2/13/2017.
 *

 /admin-api/get/outgoing-email
        return a list of outgoing email that needs to be sent

 */

@RestController
@RequestMapping("string-data")
public class StringDataRestController {

    private static final String TAG = StringDataRestController.class.getSimpleName();

    private StringDataRepo repository = null;

    @Autowired
    StringDataRestController(StringDataRepo repository) {
        this.repository = repository;
    }

    @RequestMapping(method = RequestMethod.GET)
    Collection<StringData> readBookmarks(HttpServletRequest request) {
        //this.validateUser(userId);
        String userId = request.getParameter("userId");
        String key = request.getParameter("key");

        if (key == null)
            return this.repository.findByUserId("mike");
        else {
            ArrayList<StringData> a = new ArrayList<>();
            Optional<StringData> x = repository.findByUserIdAndKey(userId, key);
            if (x.isPresent())
                a.add(x.get());
            return a;
        }
    }
}

