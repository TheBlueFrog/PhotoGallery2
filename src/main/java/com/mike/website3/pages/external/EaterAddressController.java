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

import static com.mike.website3.db.UserNote.Status.Open;


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
                    case Delivery:
                        state.setAttribute("profileCurTab", "deliverTab");
                        break;
                    case Pickup:
                        state.setAttribute("profileCurTab", "pickupTab");
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

            case "updateCompanyName": {
                state.setAttribute("profileCurTab", "deliveryTab");

                user.setCompanyName(request.getParameter("companyName"));
                user.save();
                String s = String.format("User changed the company name to %s", user.getCompanyName());
                SystemEvent.save(user, s);
                setMessage(state,"");
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

                return false;
            }
//            break;
            case "setEmailing": {
                state.setAttribute("profileCurTab", "emailTab");

                UserPrefs userPrefs = user.getPrefs();

//                String id = request.getParameter("sendOnOpen");
//                userPrefs.setSendOnOpenEmailAddressId(id.equals("None") ? "" : id);

                String id = request.getParameter("sendOnClose");
                userPrefs.setSendOnCloseEmailAddressId(id.equals("None") ? "" : id);

                if (user.doesRole2(UserRole.Role.UserAdmin)) {
                    id = request.getParameter("sendOnPending");
                    userPrefs.setSendOnPendingAccountEmailAddressId(id.equals("None") ? "" : id);
                }

                userPrefs.save();
            }
            break;
            case "closeNote": {
                state.setAttribute("profileCurTab", "messageTab");
                UserNote note = UserNote.findById(request.getParameter("noteId"));
                note.setStatus(UserNote.Status.Closed);
                note.save();
            }
            break;
            case "openNote": {
                state.setAttribute("profileCurTab", "messageTab");
                UserNote note = UserNote.findById(request.getParameter("noteId"));
                note.setStatus(Open);
                note.save();
            }
            break;
            case "msgCloseAll": {
                state.setAttribute("profileCurTab", "messageTab");
                UserNote.findByUserIdAndColorAndStatusOrderByTimestampDesc(
                        user.getId(),
                        "Private",
                        "Open").forEach(note -> {
                        note.setStatus(UserNote.Status.Closed);
                        note.save();
                });
            }
            break;
            case "msgShowClosed": {
                state.setAttribute("profileCurTab", "messageTab");
                boolean show = request.getParameter("msg-showClosed") != null;
                state.setAttribute("profileMsgShowClosed", show);
            }
            break;
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

        String userInstruction = request.getParameter("userInstruction");
        if (userInstruction != null) {

            // the supplied instructions are now the current, note that if the
            // new instructions are "" that's important because the user is saying
            // any previous instructions are not valid anymore

            List<UserNote> x = UserNote.findByUserIdAndColorAndStatusOrderByTimestampDesc(
                    user.getId(),
                    UserNote.Color.UserInstruction,
                    Open);
            if (x.size() > 0) {
                x.get(0).setBody(userInstruction);
                x.get(0).save();
            }
            else {
                UserNote userNote = new UserNote(userInstruction);
                userNote.setUserId(user.getId());
                userNote.setColor(UserNote.Color.UserInstruction);
                userNote.save();
            }
        }

        try {
            address.geoCodeAddress();
            address.save();

            if (address.getUsage().equals(Address.Usage.Delivery)) {
                Address defaultAddress = Address.findNewestByUserIdAndUsage(address.getUserId(), Address.Usage.Default);
                if (   (defaultAddress.getFirstName().length() == 0)
                    && (defaultAddress.getLastName().length() == 0)
                    && (defaultAddress.getStreet().length() == 0)
                    && (defaultAddress.getCity().length() == 0))
                //    && (defaultAddress.getZip().length() == 0))
                {
                    // the user is setting the Delivery and the Default is blank
                    // make a new default also
                    defaultAddress = new Address(user.getId());
                    defaultAddress.setFirstName(address.getFirstName());
                    defaultAddress.setLastName(address.getLastName());
                    defaultAddress.setStreet(address.getStreet());
                    defaultAddress.setCity(address.getCity());
                    defaultAddress.setState(address.getState());
                    defaultAddress.setZip(address.getZip());
                    defaultAddress.save();
                }
            }

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

            // cover a bug, for a while new Seeders were not getting made
            // with Pickup address records, ensure we have one
            String userId = state.getUser().getId();
            if (state.getUser().doesRole2(UserRole.Role.Seeder)
                && (Address.findNewestByUserIdAndUsage(userId, Address.Usage.Pickup) == null)) {
                Address.duplicate(Address.findNewestByUserIdAndUsage(userId, Address.Usage.Default), Address.Usage.Pickup);
            }

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
