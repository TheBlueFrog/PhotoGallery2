<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Offer Manager</title>
    <@styleSheets/>

<#macro showOffer item offer >
    <div class="row">
        <form class="form-horizontal" method="post" >
            <input type="hidden" name="operation" value="saveOffer" />
            <#if offer.getTime()?? >
                <input type="hidden" name="offerId" value="${offer.getTimeAsId()}" />
            </#if>
            <button class="col-sm-1 btn" onclick="this.form.submit()">
                <#if offer.getTime()?? >
                    Update
                <#else >
                    Save
                </#if>
            </button>

            <div class="col-sm-1" style="text-align: center; vertical-align:middle">
                <#if item.getEnabled() >
                    <input type="checkbox" id="enabled" name="enabled"
                        <#if offer.getEnabled() >
                                   checked
                        </#if>
                    />
                <#else >
                    n/a
                </#if>
            </div>
            <div class="col-sm-3">
                <div class="col-sm-1"></div>
                <div class="col-sm-3" style="text-align: center; vertical-align:middle">
                    <input type="checkbox" id="visibleToEater" name="visibleToEater"
                        <#if OfferRoleDB.isVisibleTo(offer.getTime(), "Eater") >
                           checked
                        </#if>
                    />
                </div>
                <div class="col-sm-3" style="text-align: center; vertical-align:middle">
                    <input type="checkbox" id="visibleToFeeder" name="visibleToFeeder"
                        <#if OfferRoleDB.isVisibleTo(offer.getTime(), "Feeder") >
                           checked
                        </#if>
                    />
                </div>
                <div class="col-sm-3" style="text-align: center; vertical-align:middle">
                    <input type="checkbox" id="visibleToSeeder" name="visibleToSeeder"
                        <#if OfferRoleDB.isVisibleTo(offer.getTime(), "Seeder") >
                           checked
                        </#if>
                    />
                </div>
                <div class="col-sm-2"></div>
            </div>
            <div class="col-sm-2">   ${offer.units}    </div>
            <div class="col-sm-1 money">   ${offer.getOurBuyPriceAsString()}    </div>
            <div class="col-sm-1 money">   ${offer.getOurSellPriceAsString()}   </div>
        </form>
    </div>
</#macro>

<#-- these must always cope with any Item configuration -->

<#macro pricingModelPackaged item>
    <div id="packagedControls">
        Price
        <input class="form-control"
               id="itemPrice"
               type="number" min="0"
               name="itemPrice"
               style="width: 150px;"
               data-toggle="tooltip"
               title="Total cost to MilkRun for the item
For a $36.00 case of 24 jars of peanut butter this would be $36.00"
               value="${String.format("%.2f", itemPrice.getPrice())}"
               required>
        <br>
        Units
        <input class="form-control"
               id="itemUnits" type="text" name="itemUnits"
               style="width: 150px;"
               data-toggle="tooltip"
               title="Units of the sub-item
For a case of 24 jars of peanut butter this would be jar"
               value="${itemPrice.getUnits()}"
               required>
        <br>
        Quantity
        <input class="form-control"
               type="number" min="1"
               id="itemQuantity"
               name="itemQuantity"
               style="width: 150px;"
               data-toggle="tooltip"
               title="How many sub-items
For a case of 24 jars of peanut butter this would be 24"
               value="${itemPrice.getQuantity()}"
               required>
    </div>
</#macro>

<#macro pricingModelBulk item>
    <div id="bulkControls">
    </div>
</#macro>


    <style>
        hr {
            display: block;
            margin-top: 0.5em;
            margin-bottom: 0.5em;
            margin-left: auto;
            margin-right: auto;
            border-style: inset;
            border-width: 1px;
        }
        td {
            vertical-align: top;
        }
        img {
              display: block;
              max-width:200px;
              max-height:200px;
              width: auto;
              height: auto;
            }

        .quantity {
            text-align: center;
        }
        .money {
            margin: 0px;
            padding: 0px;
            text-align: right;
        }
        .money-input {
            width:90px;
            margin: 0px;
            padding: 0px;
            text-align: right;
        }
        .tooltip-inner {
            white-space:pre-wrap;
        }
        .mine1 {
            padding: 0;
            margin: 0;
            color: #000000;
            border-top: 1px solid #dddddd;
            border-bottom: 0px solid #b9b9b9;
        }
        .mine2 {
            padding: 0;
            margin: 0;
            color: #000000;
            border-top: 1px solid #dddddd;
            border-bottom: 0px solid #b9b9b9;
        }
    </style>
</head>
<body class="">
    <header class="header">
        <@topOfPageHeader/>
    </header>

    <#assign haveSupplier = false >
    <#assign haveItem = false >

    <#if session.getAttribute("adminOffer-supplier")?? >
        <#assign haveSupplier = true >
        <#assign supplier = session.getAttribute("adminOffer-supplier") >

        <#assign haveItem = session.getAttribute("adminOffer-itemId")?? >
        <#if session.getAttribute("adminOffer-itemId")?? >
            <#assign haveItem = true >
            <#assign item = Item.findById(session.getAttributeS("adminOffer-itemId")) >
            <#assign itemPrice = ItemPrice.findByItemIdOrderByTimestampDesc(item.getId())?first >
            <#assign units = itemPrice.getUnits() >
        </#if>
    </#if>

        <div class="container">
            <p></p>
            <div class="row col-md-12">
                <div class="col-md-3">
                    <a href="/"><strong>Home</strong></a>
                    <br>
                    <a href="/admin"><strong>Back to Admin</strong></a>
                </div>
                <div class="col-md-6">
                    <h2> Offer Management</h2>
                </div>
                <div class="col-md-3">
                    <a href="https://github.com/TheBlueFrog/milkrunDocs/blob/master/concepts-item-offer.md"  target="_blank">
                        <span class="docs pull-right">MilkRun Item & Offer Concepts</span></a>
                    <br>
                    <a href="https://github.com/TheBlueFrog/milkrunDocs/blob/master/admin-managing-offers.md"  target="_blank">
                        <span class="docs pull-right">Managing Items</span></a>
                    <br>
                </div>
            </div>
        </div>
        <@messageHeader2 session.getAttributeS("adminOffer-message") true />

    <div class="container">
        <div class="row" >
            <ul class="nav nav-tabs">
                <li class="active" ><a data-toggle="tab" href="#all">All</a></li>
                <li ><a data-toggle="tab" href="#bySeeder">Active Offers By Supplier</a></li>
                <li ><a data-toggle="tab" href="#missingOffers">Items Without Offers</a></li>
                <li ><a data-toggle="tab" href="#inventory">Inventory</a></li>
            </ul>
            <div class="tab-content">
                <div id="bySeeder" class="tab-pane fade">
                    <strong>Suppliers with active items with active offers</strong>
                    <p></p>

                    <div class="row">
                        <div  class="col-sm-2 mine1">Supplier       </div>
                        <div  class="col-sm-2 mine1">Item            </div>
                        <div  class="col-sm-2">
                            <div  class="col-sm-3 mine2"> Qty </div>
                            <div  class="col-sm-9 mine2"> Units </div>
                        </div>
                        <div  class="col-sm-1 mine2 money ">    Buy                        </div>
                        <div  class="col-sm-1 mine2 money">     Sell                 </div>
                        <div  class="col-sm-2 mine1 ">
                                <div  class="col-sm-3"> This                                </div>
                                <div  class="col-sm-3"> Last                                </div>
                                <div  class="col-sm-3"> Min                                </div>
                                <div  class="col-sm-3 money"> Max                                 </div>
                        </div>
                        <div  class="col-sm-1 mine1 money">   Available                        </div>
                    </div>

                    <#list User.findByRole("Seeder") as seeder >
                        <#list Item.findByUserIdAndActiveOrderByShortOne(seeder.getId(), true) as item >
                            <#list Offer.findByItemIdAndActiveOrderByTimestampDesc(item.getId(), true) as offer >
                                <div class="row">
                                    <div  class="col-sm-2 mine1">
                                        ${seeder.getCompanyName()}
                                    </div>
                                    <div  class="col-sm-2 mine1">
                                        <a href="/admin-offer-editor/edit?supplierId=${seeder.getId()}&itemId=${item.getId()}">
                                            ${item.getShortOne()}
                                        </a>                                    </div>
                                    <div  class="col-sm-2">
                                        <div  class="col-sm-3 mine2"> ${offer.getQuantity()} </div>
                                        <div  class="col-sm-9 mine2"> ${offer.getUnits()} </div>
                                    </div>
                                    <div  class="col-sm-1 mine2 money ">
                                        ${offer.getOurBuyPriceAsString()}
                                    </div>
                                    <div  class="col-sm-1 mine2 money">
                                        ${offer.getOurSellPriceAsString()}
                                    </div>
                                    <div  class="col-sm-2 mine1">
                                        <#assign volume = offer.getVolume() >
                                        <div class="row">
                                            <div  class="col-sm-3 money">
                                            ${volume.getThisWeek()}
                                            </div>
                                            <div  class="col-sm-3 money">
                                            ${volume.getLastWeek()}
                                            </div>
                                            <div  class="col-sm-3 money">
                                            ${volume.getMinWeek()}
                                            </div>
                                            <div  class="col-sm-3 money">
                                            ${volume.getMaxWeek()}
                                            </div>
                                        </div>
                                    </div>
                                    <div  class="col-sm-1 mine1 money">
                                        <#assign available = "Unlimited" >
                                        <#if offer.getAvailability()?? >
                                            <#assign available = offer.getAvailability().getAvailableQuantity() >
                                        </#if>
                                        ${available}
                                    </div>
                                </div>
                            </#list>
                        </#list>
                    </#list>

                </div>
                <div id="all" class="tab-pane fade in active">
                    <p></p>
                    <div class="row">
                        <div class="col-sm-4">
                            <h4>Suppliers</h4>
                            <select name="suppliers" onChange="supplierSelect(this.value)">
                                <option value="None" select
                                >None</option>
                            <#list User.findByRole("Seeder") as s >
                                <option value="${s.getId()}"
                                    <#if haveSupplier && (supplier.getId() == s.getId()) > selected </#if>
                                >
                                ${s.getCompanyName()}
                                </option>
                            </#list>
                            </select>
                        </div>
                    <#if haveSupplier >
                        <div class="col-sm-4">
                            <h4>Item</h4>
                            <select name="items" onChange="itemSelect(this.value)">
                                <option value="None" select
                                >None</option>
                                <#list Item.findByUserId(supplier.getId()) as i >
                                    <option value="${i.getId()}"
                                        <#if haveItem && (item.getId() == i.getId()) > selected </#if>
                                    >
                                    ${i.getShortOne()}
                                    </option>
                                </#list>
                            </select>
                        </div>
                    </#if>
                    </div>
                    <#if haveItem >
                        <div class="row">
                            <p>&nbsp;</p>
                            <div class="col-sm-10">
                                <div class="col-sm-5">
                                    <div class="col-sm-4">  Item Status <br>    </div>
                                    <div class="col-sm-8">
                                        <#if item.getEnabled() >
                                            Active
                                        <#else>
                                            Not active
                                        </#if>
                                        <br>
                                    </div>
                                    <div class="col-sm-4">  Item UUID <br>      </div>   <div class="col-sm-8">  ${String.format("%8.8s...", item.getId())} <br>  </div>
                                    <div class="col-sm-4">  Category <br>       </div>   <div class="col-sm-8">  ${Util.flatten(item.getCategories())} <br>  </div>
                                    <div class="col-sm-4">  Identification <br> </div>   <div class="col-sm-8">  ${item.getIdentification()} <br>  </div>
                                    <div class="col-sm-4">  ShortOne <br>       </div>   <div class="col-sm-8">  ${item.getShortOne()} <br>  </div>
                                </div>
                                <div class="col-sm-7">

                                    <div class="col-sm-4" data-toggle="tooltip" title="E.g. total cost of a case of jars of honey">
                                        MilkRun Cost <br>
                                    </div>
                                    <div class="col-sm-8">
                                    ${String.format("$ %.2f", itemPrice.getPrice())}
                                    </div>

                                    <div class="col-sm-4" data-toggle="tooltip" title="Sub-item units, e.g. jars">
                                        Supplier Units <br>
                                    </div>
                                    <div class="col-sm-8">
                                        <#if itemPrice.getUnits() == "?" >
                                            <span class="text-danger">Pricing methods of Percentage and Add Constant are not
                                        available because this is undefined.
                                    </span>
                                        <#else >
                                        ${itemPrice.getUnits()}
                                        </#if>
                                    </div>

                                    <div class="col-sm-4" data-toggle="tooltip" title="Sub-item quantity, e.g. 24 jars in a case">
                                        Supplier Quantity <br>
                                    </div>
                                    <div class="col-sm-8" >
                                        <#if itemPrice.getQuantity() == 0 >
                                            <span class="text-danger">Pricing methods of Percentage and Add Constant are not
                                        available because this is zero.
                                    </span>
                                        <#else >
                                        ${itemPrice.getQuantity()}
                                        </#if>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <p>&nbsp;</p>
                        <div class="row">
                            <form method="post">
                                <div class="col-sm-2">
                                    <span style="font-size: large">Available Quantity</span>
                                </div>
                                <div class="col-sm-2">
                                    <input type="hidden" name="operation" value="editAvailabiity" />
                                    <#if ItemAvailability.findByItemId(item.getId())?? >
                                        <#assign available = ItemAvailability.findByItemId(item.getId()).getAvailableQuantity() >
                                    <#else >
                                        <#assign available = "Unlimited" >
                                    </#if>
                                    <input class="form-control"
                                           id="quantity"
                                           name="quantity"
                                           type="text"
                                           data-toggle="tooltip"
title="How many of the
supplied Units above are avaliable for purchase.
Enter Unlimited or blank for an unlimited supply."
                                           value="${available}">
                                    <br>
                                </div>
                                <div class="col-sm-1">
                                    <input type="submit"
                                           data-toggle="tooltip"
title="Immediately changes the availble quantity to this value.
Regardless of the quantity currently in user's carts."

                                           value="Update">
                                </div>
                            </form>
                        </div>

                        <p>&nbsp;</p>
        <hr style="height: 1px; background-color: #e9e9e9">
                        <div class="row">
                            <div class="col-xs-2" >
                                <button class="btn" onclick="createOffer()">Create New Offer</button>
                            </div>

                            <#-- offer units selector, if this matches the item price units there is
                                no conversion, otherwise...
                            -->
                            <div class="col-xs-5" >
                                <select id="offerUnitsSelect" name="offerUnitsSelect" style="width: 175px"
                                        onchange="offerUnitsSelectChanged(this.value)"
                                        data-toggle="tooltip" title=""
                                        >
                                    <option value="noneUnits" selected >None</option>
                                    <option value="setUnits" >Set Units</option>
                                    <#if itemPrice.getUnits() != "?" >
                                        <option value="matchItem" >Match Item Units</option>
                                    </#if>
                                    <option value="convertUnits" >Convert Units</option>
                                </select>
                                <br>
                                <#-- there are three div's here only one of which is
                                    visible at a time.  which one depends on the item and
                                    the Select above
                                 -->
                                <div id="broken" ></div>
<#--
                                <div class="col-xs-12"  id="setControls" class="hidden">
                                    Consumer units
                                    <input type="text"
                                            id="offerUnitsSet"
                                            name="offerUnitsSet"
                                            style="width: 150px;"
                                            data-toggle="tooltip"
                                            title=""
                                            value="${itemPrice.getUnits()}"
                                            required>
                                </div>

                                <div class="col-xs-12" id="matchItemControls" class="hidden">
                                    <p></p>
                                    Consumer units
                                    <span id="offerUnitsMatch"> ${itemPrice.getUnits()} </span>
                                </div>

                                <div class="col-xs-12" id="convertControls" class="hidden">
                                    Consumer units
                                    <input type="text"
                                           id="offerUnitsConvert"
                                           name="offerUnitsConvert"
                                           style="width: 150px;"
                                           value="${itemPrice.getUnits()}"
                                           onchange="offerUnitsChanged(this.value)"
                                    >
                                    <br>
                                    How many <i> <span id="conversionText"></span> </i> per <i>${itemPrice.getUnits()}</i>?
                                    <input type="text"
                                           id="conversionFactor"
                                           name="conversionFactor"
                                           style="width: 150px;"
                                           data-toggle="tooltip"
                                           title=""
                                           value="1.0"
                                           required>
                                </div>
-->
                            </div>
                            <div class="col-xs-5">
                                <b>Convert Units</b> When the supplied item units are different than the consumer
                                item units use the Convert Units type.  Enter the final consumer units.  And then
                                a conversion factor from supplier units to consumer units.
                                <br>
                                <b>Match Item Units</b> When the supplied item units and the offer units are the same
                                use the Match Item type.
                                <br>
                                <b>Set Units</b> Use Set Units to override the supplied item information and set the consumer
                                units explicitly.  The buy price may not reflect the actual buy price.
                                <br>
                                <p></p>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-2"></div>
                            <div class="col-sm-5">
                                <select id="methodName" name="methodName" style="width: 175px"
                                        onchange="methodNameSelected(this.value)"  data-toggle="tooltip"
title="How to compute customer price.
Fraction and Constant require the units of the item and the offer to be identical.
(Will change when we add unit conversion)
Exact ignores the item units.">

                                    <option value="Exact" data-toggle="tooltip" selected
                                            title="Set a specific price MilkRun will sell this at, regardless of anything">
                                        Exactly      </option>

                                    <#if (itemPrice.getQuantity() != 0) && (itemPrice.getUnits() != "?") >
                                        <option value="Fraction" selected data-toggle="tooltip"
                                                title="(Should be percent) Add some percent to the MilkRun cost">
                                            Add Fraction </option>
                                        <option value="AddConstant" data-toggle="tooltip"
                                                title="Add a constant amount of money to the MilkRun item cost">
                                            Always Add $ </option>
                                    </#if>
                                </select>
                                <input class="money-input"
                                       id="value"
                                       name="value"
                                       style="width: 150px;"
                                       type="number" min="0"
                                       value="0.33"
                                       required
                                       data-toggle="tooltip" title="Fraction, constant or exact amount">
                            </div>
                            <div class="col-sm-5">
                                <b>Exactly</b> define the consumer price of the item exactly.  This overrides
                                any automatic setting of the price.
                                <br>
                                <b>Add Fraction</b> the consumer price is item price <b>plus</b> this fraction.
                                <br>
                                <b>Always Add $</b> specify fixed value to add to the item price.
                                <br>
                            </div>
                        </div>
        <hr style="height: 1px; background-color: #e9e9e9">
                        <div class="row">
                            <div class="col-sm-1">
                                <span style="font-size: large">Offers</span>
                            </div>
                            <div class="col-sm-4">
                                <form method="post">
                                    <input type="hidden" name="operation" value="showDisabledOffer" />
                                    <input type="checkbox" name="showDisabledOffers" onChange="this.form.submit()"
                                    <#if session.getAttributeB("seederOffer-showDisabledOffers") >
                                       checked
                                    </#if>
                                    > Show Inactive Offers
                                </form>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-2"></div>
                            <div class="col-sm-3" style="text-align: center">Visibility</div>
                        </div>

                        <div class="row">
                            <div class="col-sm-1"></div>
                            <div class="col-sm-1" data-toggle="tooltip"
title="Is this offer active.
Item must be active.">Active</div>
                            <div class="col-sm-3">
                                <div class="col-sm-1 "></div>
                                <div class="col-sm-3 " data-toggle="tooltip" title="Offer is visible to users with Eater role" >Eater</div>
                                <div class="col-sm-3 " data-toggle="tooltip" title="Offer is visible to users with Feeder role" >Feeder</div>
                                <div class="col-sm-3 " style="text-align: center" data-toggle="tooltip" title="Offer is visible to users with Seeder role" >Seeder</div>
                                <div class="col-sm-2 "></div>
                            </div>
                            <div class="col-sm-2">Units</div>
                            <div class="col-sm-1 money">Buy Price</div>
                            <div class="col-sm-1 money">Sell Price</div>
                        </div>

                        <div class="row">
                            <#if session.getAttribute("adminOffer-offer")?? && ( ! session.getAttribute("adminOffer-offer").isSaved()) >
                                <form class="form-horizontal" method="post" >
                                    <@showOffer item session.getAttribute("adminOffer-offer") />
                                </form>
                                <p></p>
                            </#if>
                        </div>

                        <div class="row">
                            <#list Offer.findByItemIdOrderByTimestampDesc(item.getId()) as offer>
                                <#if session.getAttributeB("seederOffer-showDisabledOffers") || offer.enabled>
                                    <@showOffer item offer />
                                </#if>
                            </#list>
                        </div>
                    </#if>
                </div>
                <div id="missingOffers" class="tab-pane fade">
                    <strong>Items without active offers</strong>
                    <br>
                    <table width="90%">
                        <#list User.findByRole("Seeder") as seeder >
                            <#list Item.findByUserIdAndActiveOrderByShortOne(seeder.getId(), true) as item >
                                <#assign hasOffer = false >
                                <#list Offer.findByItemIdAndActiveOrderByTimestampDesc(item.getId(), true) as offer >
                                    <#assign hasOffer = true >
                                </#list>
                                <#if ! hasOffer >
                                    <tr>
                                        <td width="30%">${seeder.getCompanyName()}</td>
                                        <td width="70%">
                                            <a href="/admin-offer-editor/edit?supplierId=${seeder.getId()}&itemId=${item.getId()}">
                                                ${item.getShortOne()}
                                            </a></td>
                                    </tr>
                                </#if>
                            </#list>
                        </#list>
                    </table>
                </div>
                <div id="inventory" class="tab-pane fade">
                    <strong>All Active Items with Active Offers</strong>
                    <p></p>

                    <div class="row">
                        <div  class="col-sm-3 mine1">Supplier       </div>
                        <div  class="col-sm-2 mine1">Category       </div>
                        <div  class="col-sm-4 mine1">Item           </div>
                    </div>

                    <#list User.findByRole("Seeder") as seeder >
                        <#list Item.findByUserIdAndActiveOrderByShortOne(seeder.getId(), true) as item >
                            <#list Offer.findByItemIdAndActiveOrderByTimestampDesc(item.getId(), true) as offer >
                                <div class="row">
                                    <div  class="col-sm-3 mine1">
                                        ${seeder.getCompanyName()}
                                    </div>
                                    <div  class="col-sm-2 mine1">
                                        ${Util.flatten(item.getCategories())}
                                    </div>
                                    <div  class="col-sm-4 mine1">
                                        <a href="/admin-offer-editor/edit?supplierId=${seeder.getId()}&itemId=${item.getId()}">
                                            ${item.getShortOne()}
                                        </a>
                                    </div>
                                </div>
                            </#list>
                        </#list>
                    </#list>

                </div>
            </div>
        </div>
    </div>

    <p>&nbsp;</p>
    <p>&nbsp;</p>
    <p>&nbsp;</p>

    <@jsIncludes/>

    <script>
        function supplierSelect(supplierId) {
            location.assign("/admin-offer-editor/edit?supplierId=" + supplierId);
        }
        function itemSelect(itemId) {
            location.assign("/admin-offer-editor/edit?itemId=" + itemId);
        }

        <#if haveSupplier && haveItem >
            function createOffer() {
                if (method !== 'None') {
                    var conversionFactorF = 1;
                    if ($('#conversionFactor')[0] !== undefined) {
                        conversionFactorF = $('#conversionFactor')[0].value;
                    }
                    var s = "";
                    if($('#offerUnits' + method) !== undefined) {
                        s = $('#offerUnits' + method)[0].innerText;
                    }

                    var url = "/admin-offer-editor/create?units=" + s
                            + '&conversionFactor=' + conversionFactorF
                            + '&scaleFactor=' + scaleFactorF
                            + "&methodName=" + $('#methodName')[0].value
                            + "&value=" + $('#value')[0].value;

                    location.assign(url);
                }
            }

            function methodNameSelected(priceModel) {
                if (priceModel == 'Fraction') {
                    $('#value')[0].value = "0.33";
                }
                else if (priceModel == 'AddConstant') {
                    $('#value')[0].value = "1.00";
                }
                else if (priceModel == 'Exact') {
                    $('#value')[0].value = "0.01";
                }
            }
        </#if>

        function offerUnitsSelectChanged(unitsType) {
            var node = document.getElementById('broken');
            if (unitsType == 'matchItem') {
                // $('#convertControls').addClass('hidden');
                // $('#setControls').addClass('hidden');
                // $('#matchItemControls').removeClass('hidden');

                node.innerHTML = theDivs[1];
                method = 'Match';
            }
            else if (unitsType == 'convertUnits') {
                // $('#matchItemControls').addClass('hidden');
                // $('#setControls').addClass('hidden');
                node.innerHTML = theDivs[2];
                method = 'Convert';

//                $('#convertControls').removeClass('hidden');
                <#if itemPrice?? >
                    var nu = decodeUnits('${itemPrice.getUnits()}');
                    $('#offerUnitsConvert')[0].value = nu;
                    offerUnitsChanged(nu);
                <#else >
                </#if>
            }
            else if (unitsType == 'setUnits') {
                // $('#setControls').removeClass('hidden');
                // $('#matchItemControls').addClass('hidden');
                // $('#convertControls').addClass('hidden');
                node.innerHTML = theDivs[0];
                method = 'Set';
            }
            else {
                node.innerHTML = '';
                method = 'None';
            }
        }

        var method = 'None';
        var scaleFactorF = 1.0;

        function decodeUnits(units) {
            var pattern = /[0-9]+/g;
            return units.replace(pattern, "");
        }
        function offerUnitsChanged(newUnits) {
            $('#conversionText')[0].innerText = newUnits;
        }


        $(document).ready(function(){
            // $('#convertControls').addClass('hidden');
            // $('#matchItemControls').addClass('hidden');
            // $('#setControls').addClass('hidden');
        });

        var theDivs =
        [
            <#if itemPrice?? >

                  '<div class="col-xs-12"  id="setControls">'
                +     'Consumer units'
                +     '<input type="text" id="offerUnitsSet" name="offerUnitsSet" style="width: 150px;"'
                +          'data-toggle="tooltip" title="" value="${itemPrice.getUnits()}" required >'
                + '</div>',

                  '<div class="col-xs-12" id="matchItemControls" class="hidden">'
                +     '<p></p>'
                +     'Consumer units'
                +     '<span id="offerUnitsMatch"> ${itemPrice.getUnits()} </span>'
                + '</div>',

                  '<div class="col-xs-12" id="convertControls" class="hidden">'
                +     'Consumer units'
                +     '<input type="text" id="offerUnitsConvert" name="offerUnitsConvert" style="width: 150px;"'
                +         'value="${itemPrice.getUnits()}" onchange="offerUnitsChanged(this.value)" >'
                +     '<br>'
                +     'How many <i> <span id="conversionText"></span> </i> per <i>${itemPrice.getUnits()}</i>?'
                +     '<input type="text" id="conversionFactor" name="conversionFactor" style="width: 150px;"'
                +         'data-toggle="tooltip" title="" value="1.0" required >'
                + '</div>'
            <#else>
            'a', 'b', 'c'
            </#if>
        ];

    </script>

</body>
</html>
