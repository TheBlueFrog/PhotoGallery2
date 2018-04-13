package com.mike.website3.pages.external;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.exceptions.InvalidAddressException;
import com.mike.website3.MySessionState;
import com.mike.website3.MySystemState;
import com.mike.website3.db.*;
import com.mike.website3.pages.BaseController2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;

@Controller
public class EaterAddressController extends BaseController2 {
    private static final String TAG = EaterAddressController.class.getSimpleName();

    private void setMessage(MySessionState state, String s) {
        state.setAttribute("eaterAddressController-message", s);
    }

    private boolean doPost(HttpServletRequest request, Model model) {

        MySessionState state = getSessionState(request);
        User user = state.getUser();
        setMessage(state, "");

        switch (request.getParameter("operation")) {
            case "updateAddress": {
                Address address = Address.findById(request.getParameter("addressId"));
                switch (address.getUsage()) {
                    case Default:
                        state.setAttribute("profileCurTab", "billingTab");
                        break;
                }

                String mailingAddress = address.getMailingAddress();
                Address.Usage usage = address.getUsage();
                String oldAddressId = address.getId();

                // construct a new record, we leave the existing one but
                // this will have a newer timestamp and so take precedence
                address = new Address(user.getId(), usage);

                if (set(user, request, address, oldAddressId)) {
                    String s = String.format("User updated address new record %8.8s... old address: %s, new address: %s",
                            address.getId(),
                            mailingAddress,
                            address.getMailingAddress());
                    SystemEvent.save(user, s);
                    //message = s;

// the milkrun takes care of iteself
//                    // if this address (user, usage) is used in a Closed or Delivering
//                    // MilkRun then we need to tell people
//                    MilkRunDB.addressChanged(mailingAddress, address);
                }
            }
            break;
            case "changePassword": {
                state.setAttribute("profileCurTab", "passwordTab");

                String loginName = state.getLoginName();
                user.resetPassword(loginName);
                try {
                    user.hashPassword(loginName, request.getParameter("password"));
                } catch (NoSuchAlgorithmException e) {
                    setMessage(state, String.format("Internal error, %s", e.toString()));
                }

                setSessionUser(request, loginName, user);
                user.login();

                // signal that we don't want normal page flow
                return false;
            }
//            break;
        }
        return true;
    }

    private boolean set(User user, HttpServletRequest request, Address address, String oldAddressId) {
        MySessionState state = getSessionState(request);

        address.setFirstName(request.getParameter("firstName"));
        address.setLastName(request.getParameter("lastName"));
        address.setStreet(request.getParameter("street"));
        address.setStreet2(request.getParameter("street2"));
        address.setCity(request.getParameter("city"));

        String s = request.getParameter("state");
        if ((s != null) && address.getUsage().equals(Address.Usage.Default))
            address.setState(s);
        else
            address.setState(MySystemState.getInstance().getDefaultState());

        // sometimes the address record ID is appended to the zipcode parameter name,
        // and sometimes it's appended to the value itself...
        String zip = request.getParameter("zip");
        if (zip == null)
            zip = request.getParameter("zip" + "-" + oldAddressId);
        else
            zip = zip.substring(0, zip.indexOf("-"));
        address.setZip(zip);

        try {
            address.geoCodeAddress();
            address.save();
            return true;
        } catch (InvalidAddressException e) {
            setMessage(state, "The address you entered cannot be geo-coded.  <br>" +
                    "You could try a simpler variant.  <br>" +
                    "You may have to contact customer support for assistance.");
            return false;
        }
    }

    @RequestMapping(value = "/eater-address-editor", method = RequestMethod.GET)
    public String get(HttpServletRequest request, Model model) {

        try {
            MySessionState state = getSessionState(request);
            if (state.getUser() == null)
                return "forward:/";

            // tell UI which tab

            if (request.getParameter("profileCurTab") != null)
                state.setAttribute("profileCurTab", request.getParameter("profileCurTab"));

            if (state.getAttribute("profileCurTab") == null) {
                state.setAttribute("profileCurTab", "deliverTab");
            }

            // make sure we have the defaults setup for the message tab

            if (state.getAttribute("msgStatusList") == null) {
                List<String> statusList = new ArrayList<>();
                statusList.add("Open");
                state.setAttribute("msgStatusList", statusList);
            }

            if (state.getAttribute("profileMsgShowClosed") == null)
                state.setAttribute("profileMsgShowClosed", false);

            // sync showClosed and the status list

            List<String> statusList = state.getAttributeSL("msgStatusList");
            if (statusList.contains("Routed") && ( ! state.getAttributeB("profileMsgShowClosed")))
                statusList.remove("Routed");
            if (( ! statusList.contains("Routed")) && state.getAttributeB("profileMsgShowClosed"))
                statusList.add("Routed");

            state.setAttribute("msgStatusList", statusList);

            return get2(request, model, "eater-address-editor");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

    @RequestMapping(value = "/eater-address-editor", method = RequestMethod.POST)
    public String post(HttpServletRequest request, Model model) {

        try {
            if (doPost(request, model))
                return get2(request, model, "redirect:/eater-address-editor");

            // bit of a hack
            return get2(request, model, "redirect:/general-message?title=Password Changed&message=Your password has been changed.");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }
}
