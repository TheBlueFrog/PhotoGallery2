package com.mike.website3.pages.internal;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.util.DuplicateKeyException;
import com.mike.website3.Constants;
import com.mike.website3.PageState;
import com.mike.website3.db.StringData;
import com.mike.website3.db.UserRole;
import com.mike.website3.pages.BaseController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;

import static com.mike.website3.pages.internal.SystemStringEditorController.SystemStringPageState.Events.Get;
import static com.mike.website3.pages.internal.SystemStringEditorController.SystemStringPageState.Events.Post;
import static com.mike.website3.pages.internal.SystemStringEditorController.SystemStringPageState.State.Running;
import static com.mike.website3.pages.internal.SystemStringEditorController.SystemStringPageState.State.Start;


/**
 * Created by mike on 11/23/2016.
 */
@Controller
public class SystemStringEditorController extends BaseController {

    private static final String TAG = SystemStringEditorController.class.getSimpleName();

    public static class SystemStringPageState extends PageState {

        static public Factory factory = new Factory() {
            @Override
            public PageState makeNew(String tag, BaseController controller, HttpServletRequest request) {
                return new SystemStringPageState(controller, request);
            }
        };

        private SystemStringPageState(BaseController owner, HttpServletRequest request) {
            super(owner, owner.getSessionState(request));
        }

        @Override
        public void clear() {
            state = Running;
            clearMessage();
        }

        static public enum Events {
            Get,
            Post,
        };
        static public enum State {
            Start,
            Running,
        }

        // return FTL to load given the current state
        @Override
        public String getFTL(HttpServletRequest request) {
            if ( ! sessionState.getUser().isAnAdmin())
                return Constants.Web.INDEX_HTML;

            return "system-string-editor";
        }

        private State state = Start;

        public String clock(Events event, HttpServletRequest request, Model model) {
            return clock(new Event(event.toString()), request, model);
        }
        @Override
        public String clock(Event event, HttpServletRequest request, Model model) {
            switch (state) {
                case Start:
                    get(request, model);
                    break;
                case Running:
                    switch (Events.valueOf(event.getValue())) {
                        case Get:
                            get(request, model);
                            break;
                        case Post:
                            post (request, model);
                            break;
                    }
                    break;
            }
            return go(request, model);
        }

        private void get(HttpServletRequest request, Model model) {
            if ( ! UserRole.is(sessionState.getUser().getId(), UserRole.Role.Admin)) {
                state = Start;
                return;
            }

            clearMessage();
            state = Running;
        }

        private void post(HttpServletRequest request, Model model) {
            if ( ! UserRole.is(sessionState.getUser().getId(), UserRole.Role.Admin)) {
                state = Start;
                return;
            }

            String id = request.getParameter("id");

            try {
                switch (request.getParameter("operation")) {
                    case "Create": {
                        StringData perUserStringData = new StringData("", "");
                        perUserStringData.save();
                    }
                    break;
                    case "Delete": {
                        StringData perUserStringData = StringData.findById(id);
                        perUserStringData.delete();
                    }
                    break;
                    case "Update": {
                        String key = request.getParameter("Key");
                        StringData existing = StringData.findByUserIdAndKey("", key);
                        if ((existing != null) && ( ! existing.getId().equals(id))) {
                            setMessage(String.format("Key %s already exists for different record.", key));
                            return;
                        }

                        if (existing != null) {
                            // updating the existing record
                            existing.setValue(request.getParameter("Value"));
                            existing.save();
                        }
                        else {
                            // no such key, create one
                            StringData perUserStringData = new StringData("", key, request.getParameter("Value"));
                            perUserStringData.save();
                        }
                    }
                    break;
                }
            } catch (DuplicateKeyException e) {
                setMessage("Duplicate key " + request.getParameter("Key"));
                return;
            }

            clearMessage();
        }
    }

    @RequestMapping(value = "/system-string-editor", method = RequestMethod.GET)
    public String get(HttpServletRequest request, Model model) {

        try {
            SystemStringPageState pageState = (SystemStringPageState) PageState.get(SystemStringPageState.factory, TAG, this, request);
            return pageState.clock(Get, request, model);
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

    @RequestMapping(value = "/system-string-editor", method = RequestMethod.POST)
    public String post1(HttpServletRequest request, Model model) {

        try {
            SystemStringPageState pageState = (SystemStringPageState) PageState.get(SystemStringPageState.factory, TAG, this, request);
            return pageState.clock(Post, request, model);
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

}
