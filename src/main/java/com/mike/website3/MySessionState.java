package com.mike.website3;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.util.Util;
import com.mike.website3.db.Image;
import com.mike.website3.db.User;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by mike on 12/11/2016.
 */
public class MySessionState {

    static private long nextSerialNumber = 1;
    private long serialNumber = nextSerialNumber++;
    public long getSerialNumber() {
        return serialNumber;
    }

    private User user = null;
    private String loginName = null;
    private User pushedUser = null;

    public MySessionState() {

        Website.autoLogin(this);
    }

    public User getUser() {
        return user;
    }
    public void setUser(String loginName, User user) {
        this.user = user;
        this.loginName = loginName;
    }

    public String getId() {
        return String.format("%08d", serialNumber);
    }

    public String getLoginName() {
        return loginName;
    }

    public User getPushedUser() {
        return pushedUser;
    }
    public void setPushedUser(User pushedUser) {
        this.pushedUser = pushedUser;
    }


    public void setLastError(String error) {
        setAttribute("lastError", error);
    }
    public void clearLastError() {
        removeAttribute("lastError");
    }
    public String getLastError() {
        return getAttributeS("lastError");
    }

    /** get all users, sorted by name */
    public List<User> getSortedUsers() {
        return User.getSortedUsers(
                new User.UserSelector() {
                    @Override
                    public boolean select(User user) {
                        return true;
                    }
                },
                Util::sortByLoginName);
    }

    // recover the SessionState object from the request the current thread
    // is processing...useful when you're in some random place
    //
    public static MySessionState get() {
        ServletRequestAttributes sra = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (sra != null) {
            HttpServletRequest request = sra.getRequest();
            MySessionState ss = (MySessionState) request.getSession().getAttribute(Constants.appSession);
            return ss;
        }
        return null;
    }

    private Map<String, PageState> pageState = new HashMap<>();

    public PageState getPageState(String pageTag) {
        PageState x = pageState.get(pageTag);
        return x;
    }
    public void putPageState(String pageTag, PageState state) {
        pageState.put(pageTag, state);
    }


    private Map<String, Object> attributes = new HashMap<>();

    public Object getAttribute(String name) {
        return attributes.get(name);
    }
    public String getAttributeS(String name)  {
        String s = (String) attributes.get(name);
        if (s == null)
            return "";
        return s;
    }
    public boolean getAttributeB(String name)  {
        Boolean b = (Boolean) attributes.get(name);
        if (b == null)
            return false;
        return b;
    }

    public void setAttribute(HttpServletRequest request, String name) {
        attributes.put(name, request.getParameter(name));
    }
    public void setAttributeIf(HttpServletRequest request, String name) {
        Object o = request.getParameter(name);
        if (o != null)
            attributes.put(name, o);
    }
    public void setAttribute(String name, Object value) {
        attributes.put(name, value);
    }
    public void setAttributeBoolean(HttpServletRequest request, String name) {
        // HTML doesn't post a value if a checkbox is off, only when on
        if (request.getParameter(name) == null)
            attributes.put(name, false);
        else
            attributes.put(name, true);
    }

    public void putAttribute (String name, List<String> stringList) {
        attributes.put(name, stringList);
    }
    public List<String> getAttributeSL (String name) {
        return (List<String>) attributes.get(name);
    }

    public void removeAttribute(String name) {
        attributes.remove(name);
    }

    public List<Image> getPublicImages() {
        List<Image> images = Image.findByVisibilityOrderByTimestampDesc(Image.Visibility.Public);
        return images;
    }
}
