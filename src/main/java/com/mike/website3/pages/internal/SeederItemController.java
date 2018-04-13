package com.mike.website3.pages.internal;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.Constants;
import com.mike.website3.MySessionState;
import com.mike.website3.Website;
import com.mike.website3.db.*;
import com.mike.website3.milkrun.SeederMilkRunUI;
import com.mike.website3.pages.BaseController2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

import static com.mike.website3.db.ItemPrice.findByItemIdOrderByTimestampDesc;

/**
 * Created by mike on 11/23/2016.
 */
@Controller
public class SeederItemController extends BaseController2 {

    private static final String TAG = SeederItemController.class.getSimpleName();

    @RequestMapping(value = "/seeder-item-editor", method = RequestMethod.GET)
    public String get(HttpServletRequest request, Model model) {
        try {
            MySessionState state = getSessionState(request);
            User user = state.getUser();
            if (user == null)
                return get2(request, model, Constants.Web.REDIRECT_INDEX_HOME);

            Item item = (Item) state.getAttribute("seederItem-item");
            assert item != null;
            if (item == null)
                return get2(request, model, Constants.Web.REDIRECT_INDEX_HOME);

            assert item.getSupplierId().equals(user.getUsername());

            state.setAttribute("seederItem-imageFiles", addImageFiles(model, user));

            return get2(request, model, "seeder-item-editor");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }
//    @RequestMapping(value = "/admin-offer-editor", method = RequestMethod.GET)
//    public String geta(HttpServletRequest request, Model model) {
//        try {
//            MySessionState state = getSessionState(request);
//            User user = state.getUser();
//            if (user == null)
//                return get2(request, model, Constants.Web.REDIRECT_INDEX_HOME);
//
////            Offer offer = (Offer) state.getAttribute("seederItem-offer");
////            assert offer != null;
////            if (offer == null)
////                return get2(request, model, Constants.Web.REDIRECT_INDEX_HOME);
//
////            state.setAttribute("seederItem-imageFiles", addImageFiles(model, user));
//
//            return get2(request, model, "admin-offer-editor");
//        }
//        catch (Exception e) {
//            return showExceptionPage(e, request, model);
//        }
//    }

//    @RequestMapping(value = "/admin-offer-editor/start", method = RequestMethod.GET)
//    public String get11(HttpServletRequest request, Model model) {
//        try {
//            MySessionState state = getSessionState(request);
//            User user = state.getUser();
//            if (user == null)
//                return get2(request, model, Constants.Web.REDIRECT_INDEX_HOME);
//
//            state.setAttribute("adminOffer-supplier", User.findByUserId(request.getParameter("supplierId")));
//            state.removeAttribute("adminOffer-item");
//            state.removeAttribute("adminOffer-offer");
//
//            return "redirect:/admin-offer-editor";
//        }
//        catch (Exception e) {
//            return showExceptionPage(e, request, model);
//        }
//    }
    @RequestMapping(value = "/seeder-item-editor/create", method = RequestMethod.GET)
    public String get1(HttpServletRequest request, Model model) {
        try {
            MySessionState state = getSessionState(request);
            User user = state.getUser();
            if (user == null)
                return get2(request, model, Constants.Web.REDIRECT_INDEX_HOME);

            Item item = new Item(user);
//            item.save();

            state.setAttribute("seederItem-item", item);
            return "redirect:/seeder-item-editor";
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }
    @RequestMapping(value = "/seeder-item-editor/edit", method = RequestMethod.GET)
    public String get4(HttpServletRequest request, Model model) {
        try {
            MySessionState state = getSessionState(request);
            User user = state.getUser();
            if (user == null)
                return get2(request, model, Constants.Web.REDIRECT_INDEX_HOME);

            Item item = Item.findById(request.getParameter("itemId"));
            state.setAttribute("seederItem-item", item);

            return "redirect:/seeder-item-editor";
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

////    var url="/admin-offer-editor/create?unitsId=" + units + "&buyPrice=" + buyPrice + "&sellPrice=" + sellPrice;
//    @RequestMapping(value = "/admin-offer-editor/create", method = RequestMethod.GET)
//    public String get1a(HttpServletRequest request, Model model) {
//        try {
//            MySessionState state = getSessionState(request);
//            User user = state.getUser();
//            if (user == null)
//                return get2(request, model, Constants.Web.REDIRECT_INDEX_HOME);
//
//            Item item = (Item) state.getAttribute("adminOffer-item");
//            assert item != null;
//
//            Offer offer = new Offer(item.getSupplierId(), item);
//            offer.setUnitsId(request.getParameter("units"));
//
//            ItemPrice itemPrice = findByItemIdOrderByTimestampDesc(item.getId()).get(0);
//            switch(itemPrice.getPricingModel()) {
//                case Packaged: {
//                    double d = Double.parseDouble(request.getParameter("packagedValue"));
//                    switch (request.getParameter("packagedPriceModel")) {
//                        case "Fraction":
//                            offer.setOurBuyPrice(itemPrice.getPrice());
//                            offer.setOurSellPrice(itemPrice.getPrice() + (itemPrice.getPrice() * d));
//                            break;
//                        case "Fixed":
//                            offer.setOurBuyPrice(itemPrice.getPrice());
//                            offer.setOurSellPrice(itemPrice.getPrice() + d);
//                            break;
//                        default:
//                            return showErrorPage(
//                                    "Unsupported packagedPricingModel " + request.getParameter("packagedPriceModel"),
//                                    request, model);
//                    }
//                }
//                break;
//                case Bulk:
//                    offer.setOurBuyPrice(Double.parseDouble(request.getParameter("buyPrice")));
//                    offer.setOurSellPrice(Double.parseDouble(request.getParameter("sellPrice")));
//                    break;
//                default:
//                    return showErrorPage("Unsupported ItemPricingModel " + itemPrice.getPricingModel().toString(),
//                            request, model);
//            }
//
//            state.setAttribute("seederItem-offer", offer);
//
//            return "redirect:/admin-offer-editor";
//        }
//        catch (Exception e) {
//            return showExceptionPage(e, request, model);
//        }
//    }
//    @RequestMapping(value = "/admin-offer-editor/edit", method = RequestMethod.GET)
//    public String get4a(HttpServletRequest request, Model model) {
//        try {
//            MySessionState state = getSessionState(request);
//            User user = state.getUser();
//            if (user == null)
//                return get2(request, model, Constants.Web.REDIRECT_INDEX_HOME);
//
//            // may have an ItemId or an OfferId, ensure the adminOffer-supplier is correct
//            Item item;
//            String offerId = request.getParameter("offerId");
//            if (offerId == null) {
//                // have an item to edit but no offer
//                item = Item.findById(request.getParameter("itemId"));
//                state.setAttribute("adminOffer-item", item);
//            }
//            else {
//                // have an offer to edit, also pickup the item
//
//                Offer offer = Offer.findByTimeAsId(offerId);
//                state.setAttribute("adminOffer-offer", offer);
//
//                item = Item.findById(offer.getItemId());
//                state.setAttribute("adminOffer-item", item);
//            }
//
//            state.setAttribute("adminOffer-supplier", item.getSupplier());
//
//            return "redirect:/admin-offer-editor";
//        }
//        catch (Exception e) {
//            return showExceptionPage(e, request, model);
//        }
//    }

    private List<String> addImageFiles(Model model, User user) {
        List<String> paths = new ArrayList<>();
        Website.getStorageService().loadAll(user).forEach(path -> {
            String s = path.toFile().getName();
            paths.add(path.toFile().getName());
        });
        return paths;
    }

    @RequestMapping(value = "/seeder-item-editor", method = RequestMethod.POST)
    public String supportPost(HttpServletRequest request, Model model) {
        try {
            MySessionState state = getSessionState(request);
            User user = state.getUser();
            if ((user == null) || (!user.doesRole2(UserRole.Role.Seeder)))
                return showErrorPage("Unauthorized Access", request, model);

            Item item = (Item) state.getAttribute("seederItem-item");

            String operation = request.getParameter("operation");
            switch (operation) {
                case "editGeneral": {
                    item.setEnabled(request.getParameter("enabled") != null);   // checkbox not sent if off, sent if on
                    item.setIdentification(request.getParameter("identification"));
//                    item.setCategory(request.getParameter("category"));
                    item.setShortOne(request.getParameter("shortOne"));
                    item.setShortTwo(request.getParameter("shortTwo"));
                    item.setDescription(request.getParameter("description"));
                    item.setNote(request.getParameter("note"));

                    String newPrimaryCategory = request.getParameter("category1");

                    if (( ! item.isBlank()) && ( ! newPrimaryCategory.equals("None"))) {
                        item.save();

                        // remove from all category bindings for item, rebuild them
                        ItemCategoryBinding.findByItemId(item.getId())
                                .forEach(itemCategoryBinding -> itemCategoryBinding.delete());

                        // link to primary category
                        {
                            ItemCategory x = ItemCategory.findByCategory(newPrimaryCategory);
                            new ItemCategoryBinding(item.getId(), x.getId(), ItemCategoryBinding.BindingLevel.Primary)
                                    .save();
                        }

                        // and link to secondary, do not allow the secondary category to
                        // be the same as the primary
                        {
                            String newSecondaryCategory = request.getParameter("category2");
                            if (   ( ! newPrimaryCategory.equals(newSecondaryCategory))
                                    && ( ! newSecondaryCategory.equals("None"))) {
                                ItemCategory x = ItemCategory.findByCategory(newSecondaryCategory);
                                new ItemCategoryBinding(item.getId(), x.getId(), ItemCategoryBinding.BindingLevel.Secondary)
                                        .save();
                            }
                        }
                    }
                }
                break;
                case "editPricing": {
                    if (item.isSaved()) {
                        List<ItemPrice> itemPrices = findByItemIdOrderByTimestampDesc(item.getId());
                        ItemPrice itemPrice = itemPrices.get(0);    // use the latest price

                        double price = Double.parseDouble(request.getParameter("itemPrice"));
                        double quantity = Double.parseDouble(request.getParameter("itemQuantity"));
                        String units = request.getParameter("itemUnits");

                        if ( ! ((Math.abs(itemPrice.getPrice() - price) < 0.005) &&
                                (itemPrice.getQuantity() == quantity) &&
                                itemPrice.getUnits().equals(units))) {
                            // something changed, make new record
                            itemPrice = new ItemPrice(item.getId(),
                                    price,
                                    units,
                                    quantity);
                            itemPrice.save();
                        }
                    }
                }
                break;
                case "editAvailability": {
                    if (item.isSaved()) {
                        ItemAvailability.updateQuantity(item, request.getParameter("quantity"));
                    }
                }
                break;
//                case "showDisabledOffer": {
//                    state.setAttribute("seederOffer-showDisabledOffers",
//                            ! state.getAttributeB("seederOffer-showDisabledOffers"));
//                }
//                break;
//                case "createOffer": {
//                    Offer offer = new Offer(getSessionUser(request).getUsername(),
//                            item,
//                            true,//(request.getParameter("enabled") != null),
//                            Units.getUnitsId(request.getParameter("units")),
////                                Double.parseDouble(request.getParameter("quantity")),
//                            Double.parseDouble(request.getParameter("ourBuyPrice")),
//                            Double.parseDouble(request.getParameter("ourSellPrice")));
//                    offer.save();
//                }
//                break;
//                case "editOffer": {
//                    Offer offer = Offer.findByTimestamp(request.getParameter("offerId"));
//                    offer.setEnabled((request.getParameter("enabled") != null));
//                    offer.save();
//
//                    OfferRoleDB.findByOfferId(offer.getTime()).forEach(offerRoleDB -> offerRoleDB.delete());
//                    if (request.getParameter("visibleToEater") != null)
//                        new OfferRoleDB(offer.getTime(), UserRole.Role.Eater)
//                                .save();
//                    if (request.getParameter("visibleToFeeder") != null)
//                        new OfferRoleDB(offer.getTime(), UserRole.Role.Feeder)
//                                .save();
//                    if (request.getParameter("visibleToSeeder") != null)
//                        new OfferRoleDB(offer.getTime(), UserRole.Role.Seeder)
//                                .save();
//                }
//                break;
                case "createImageLink": {
                    ItemImage itemImage = new ItemImage(item,
                            request.getParameter("caption"),
                            request.getParameter("filename"),
                            request.getParameter("usage"));
                    itemImage.save();
                }
                break;
                case "updateImageLink": {
                    ItemImage itemImage = ItemImage.findById(request.getParameter("imageId"));
                    itemImage.setFilename(request.getParameter("filename"));
                    itemImage.setCaption(request.getParameter("caption"));
                    itemImage.setUsage(request.getParameter("usage"));
                    itemImage.save();
                }
                break;
                case "deleteImageLink": {
                    ItemImage itemImage = ItemImage.findById(request.getParameter("imageId"));
                    itemImage.delete();
                }
                break;
            }

            return get2(request, model, "redirect:/seeder-item-editor");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

//    @RequestMapping(value = "/admin-offer-editor", method = RequestMethod.POST)
//    public String supportPost2(HttpServletRequest request, Model model) {
//        try {
//            MySessionState state = getSessionState(request);
//            User user = state.getUser();
//            if ((user == null) || (!user.doesRole2(UserRole.Role.Admin)))
//                return showErrorPage("Unauthorized Access", request, model);
//
//            Item item = (Item) state.getAttribute("adminOffer-item");
//
//            // there are two scenarios, if we are saving the new offer or
//            // saving an existing offer that's being updated
//            String offerIdS = request.getParameter("offerId");
//            Offer offer;
//            if (offerIdS == null)
//                offer = (Offer) state.getAttribute("seederItem-offer");
//            else
//                offer = Offer.findByTimeAsId(offerIdS);
//
//            String operation = request.getParameter("operation");
//            switch (operation) {
////                case "createOffer": {
////                    Offer offer = new Offer(getSessionUser(request).getUsername(),
////                            item,
////                            true,//(request.getParameter("enabled") != null),
////                            Units.getUnitsId(request.getParameter("units")),
//////                                Double.parseDouble(request.getParameter("quantity")),
////                            Double.parseDouble(request.getParameter("ourBuyPrice")),
////                            Double.parseDouble(request.getParameter("ourSellPrice")));
////                    offer.save();
////                }
////                break;
//                case "showDisabledOffer": {
//                    state.setAttribute("seederOffer-showDisabledOffers",
//                            ! state.getAttributeB("seederOffer-showDisabledOffers"));
//                }
//                break;
//                case "saveOffer": {
//                    offer.setEnabled((request.getParameter("enabled") != null));
//                    offer.save();
//
//                    OfferRoleDB.findByOfferId(offer.getTime()).forEach(offerRoleDB -> offerRoleDB.delete());
//                    if (request.getParameter("visibleToEater") != null)
//                        new OfferRoleDB(offer.getTime(), UserRole.Role.Eater)
//                                .save();
//                    if (request.getParameter("visibleToFeeder") != null)
//                        new OfferRoleDB(offer.getTime(), UserRole.Role.Feeder)
//                                .save();
//                    if (request.getParameter("visibleToSeeder") != null)
//                        new OfferRoleDB(offer.getTime(), UserRole.Role.Seeder)
//                                .save();
//                }
//                break;
//            }
//
//            return get2(request, model, "redirect:/admin-offer-editor");
//        }
//        catch (Exception e) {
//            return showExceptionPage(e, request, model);
//        }
//    }

    @RequestMapping(value = "/seeder-update-prices", method = RequestMethod.GET)
    public String get2(HttpServletRequest request, Model model) {
        try {
            MySessionState state = getSessionState(request);
            User user = state.getUser();
            if (user == null)
                return get2(request, model, Constants.Web.REDIRECT_INDEX_HOME);

            SeederUpdatePriceUI seederUpdatePriceUI = new SeederUpdatePriceUI(user);
            model.addAttribute("priceData", seederUpdatePriceUI);
//            if (getSessionState(request).getUpdatePriceErrors() != null)
//                model.addAttribute("priceErrors", getSessionState(request).getUpdatePriceErrors());

            return get2(request, model, "seeder-update-prices");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }


//    "/seeder-milkrun?milkRunId=xxx"
    @RequestMapping(value = "/seeder-milkrun", method = RequestMethod.GET)
    public String get3(HttpServletRequest request, Model model) {
        try {
            MySessionState state = getSessionState(request);
            User user = state.getUser();
            if (user == null)
                return get2(request, model, Constants.Web.REDIRECT_INDEX_HOME);

            String milkRunId = request.getParameter("milkRunId");
            state.setAttribute("seederItemController-milkRunId", milkRunId);

            if (milkRunId != null) {
                SeederMilkRunUI ui = new SeederMilkRunUI(milkRunId, user);
                model.addAttribute("UI", ui);
                return get2(request, model, ui.getFTL());
            }

            return get2(request, model, "seeder-milkrun");
        }
        catch (Exception e) {
            return showExceptionPage(e, request, model);
        }
    }

}
