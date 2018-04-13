package com.mike.website3.RestApi;

import com.mike.website3.MySessionState;
import com.mike.website3.db.UserRole;

import javax.servlet.http.HttpServletRequest;

import java.util.Collection;

import static com.mike.website3.Constants.appSession;

public class BaseRestController {
    protected boolean validate(HttpServletRequest request) {
        MySessionState state = (MySessionState) request.getSession().getAttribute(appSession);
        return (state != null) && state.getUser().doesRole2(UserRole.Role.Admin);
    }

}
