package com.mike.website3.pages.internal;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.pages.BaseController;
import org.springframework.stereotype.Controller;

/**
 * Created by mike on 11/23/2016.
 */
@Controller
public class SeederHomeController extends BaseController {

    private static final String TAG = SeederHomeController.class.getSimpleName();

//    @RequestMapping(value = "/seeder-home", method = RequestMethod.GET)
//    public String get(HttpServletRequest request, Model model) {
//        return super.get(request, model, "seeder-home");
//    }
//
//
//    @RequestMapping(value = "/seeder-home", method = RequestMethod.POST)
//    public String supportPost(HttpServletRequest request, Model model) {
//
//        String nextPage = "redirect:/seeder-home";
//        try {
//            String operation = request.getParameter("operation");
//
//            switch (operation) {
//                case "showDisabledItem": {
//                    MySessionState ss = getSessionState(request);
//                    ss.setShowDisabledItems( ! ss.getShowDisabledItems());
//                }
//                break;
//                case "createItem": {
//                    Item item = new Item(getSessionUser(request));
//                    item.save();
//                    nextPage = String.format("redirect:/seeder-item-editor?itemId=%s", item.getId());
//                }
//                break;
//                case "changeItemEnable": {
//                    String itemId = request.getParameter("itemId");
//                    Item item = Item.findById(itemId);
//                    item.setEnabled(request.getParameter("itemEnable") != null);
//                    item.save();
//                }
//                break;
//                default:
//                    Log.e(TAG, String.format("Unsupported operation ", operation));
//                    break;
//            }
//
//            addAttributes(request, model);
//            Log.d(TAG, String.format("Post %s, next page %s", request.getPathInfo(), nextPage));
//        } catch (Exception e) {
//            Log.d(e);
//        }
//        return nextPage;
//    }
}
