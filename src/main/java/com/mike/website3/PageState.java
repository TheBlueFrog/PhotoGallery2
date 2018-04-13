package com.mike.website3;

import com.mike.website3.db.SystemEvent;
import com.mike.website3.db.SystemNotice;
import com.mike.website3.pages.BaseController;
import org.springframework.ui.Model;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public abstract class PageState {

    protected void setInternalError(String s) {
        setMessage(s);
        new SystemEvent("system", s)
                .save();
    }

    static public interface Factory {
        public PageState makeNew(String tag, BaseController controller, HttpServletRequest request);
    }

    static public PageState get(Factory fact, String tag, BaseController controller, HttpServletRequest request) {
        MySessionState sessionState = controller.getSessionState(request);
        PageState pageState = sessionState.getPageState(tag);
        if (pageState == null) {
            pageState = fact.makeNew(tag, controller, request);
            sessionState.putPageState(tag, pageState);
        }
        return pageState;
    }

    static public class Event {
        private String value = null;
        public Event (String value) {
            this.value = value;
        }
        public String getValue() {
            return value;
        }
    }

    protected PageState(BaseController owner, MySessionState sessionState) {
        this.owner = owner;
        this.sessionState = sessionState;
    }

    /** figure out the FTL to load given the state */
    public String go(HttpServletRequest request, Model model) {
        return owner.get(request, model, this, getFTL(request));
    }

    /** clear all state back to base condition */
    public abstract void clear();

    /** return FTL to load given the current state */
    public abstract String getFTL(HttpServletRequest request);

    /** remove this PageState from the session */
    protected void remove(String tag) {
        sessionState.putPageState(tag, null);
    }

    /** given a new event 'do-the-needfull' as they say */
    public abstract String clock(Event event, HttpServletRequest request, Model model);

    // state data common to all pages
    protected final BaseController owner;
    protected MySessionState sessionState;


    protected String message;
    public String getMessage() {
        if (message != null)
            return message.length() > 0 ? message : null;
        return null;
    }
    public void setMessage(String message) {
        this.message = message;
    }
    public void clearMessage() {
        setMessage(null);
    }

    // System notices are from the system, not from the clocking of page state

    public List<SystemNotice> getSystemNotice() {
        return MySystemState.getInstance().getNotices(sessionState);
    }
    public void clearSystemNotice(String id) {
        MySystemState.getInstance().clearNotice(sessionState, id);
    }


}
