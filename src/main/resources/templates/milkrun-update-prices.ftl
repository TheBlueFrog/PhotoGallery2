<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Milkrun Update Offers</title>
    <@styleSheets/>

    <style>

    .cart-button {
            color: inherit;
            font-size: 11px;
            padding: 2px 12px;
            display: inline-block;
            margin 0;
            margin-top: 15px;
            border-top: 1px solid #e9e9e9;
            border-bottom: 1px solid #e9e9e9;
        }

    .mine1 {
        height: 25px;
        padding: 0;
        margin: 0;
        margin-top: -5px;
        margin-bottom: - 10px;
        color: #000000;
            border-top: 1px solid #a9a9a9;
            border-bottom: 0px solid #b9b9b9;
    }
    .mine2 {
        height: 25px;
        padding: 0;
        margin: 0;
        font-size: 12px;
        margin-top: -5px;
        margin-bottom: - 10px;
        color: #000000;
        border-top: 1px solid #a9a9a9;
        border-bottom: 0px solid #b9b9b9;
    }
    .mine4 {
        padding: 0;
        margin: 0;
        height: 18px;
        border: 0px;
        font-size: 12px;
        text-align: left;
        margin-top: -1px;
        margin-bottom: - 1px;
        vertical-align: baseline;
        color: #000000;
            border-top: 1px solid #e9e9e9;
            border-bottom: 0px solid #FF0000;
    }
    .mine5 {
        padding: 0;
        margin: 0;
        text-align: left;
    }
    .scrolled70 {
        verflow-y:scroll; overflow-x:hidden;
        max-height: 55vh;
    }
    .scrolled30 {
        verflow-y:scroll; overflow-x: hidden;;
        max-height: 15vh;
    }
    </style>

</head>
<div class="">
    <@pageHeader3 />

    <p></p>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-2">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="admin"><strong>Admin Home</strong></a>
            </div>
            <div class="col-md-6">
                <h4>MilkRun Offers</h4>
            </div>
            <div class="col-md-3">
                <a href="https://github.com/TheBlueFrog/milkrunDocs/blob/master/concepts-item-offer.md"  target="_blank">
                    <span class="docs pull-right">MilkRun Item & Offer Concepts</span></a>
                <br>
                <a href="https://github.com/TheBlueFrog/milkrunDocs/blob/master/admin-managing-offers.md"  target="_blank">
                    <span class="docs pull-right">Managing Offers</span></a>
                <br>
            </div>
        </div>
    </div>

    <p></p>

    <div class="container-fluid">
        <#--
        <div class="row scrolled30">
            <div class="col-sm-1" ></div>
            <div class="col-sm-5" >
                Set a new Buy price when the supplier changes his price to MilkRun.
                The new buy price will appear on the next MilkRun Pick list as the price we expect to pay
                the seller.
                <br>
                You can set a new Sell price at any time.
                A new sell price will be shown to customers from this point.
                <br>
                Note: changes of less than 0.5% are ignored.
                <br>
                The <i>This</i> column is the number of offers currently
                in user's carts for <i>this</i> week.  <i>Last</i> column is the number
                of offers delivered <i>last</i> week.  <i>Min and Max</i> are the limits
                of the number of offers delivered in any week.
            </div>
            <div class="col-sm-1" ></div>
            <div class="col-sm-4" >
                Offers can have limited or unlimited quantities.  This is specified in the
                Available Qty column.  As offers are put into carts this quantity will decrease.
                At zero the offer is not available.
                <p></p>
                <b>
                Setting a new price will disable the existing offer and create a new
                offer.  Customers who have already put the existing offer in their cart
                will continue to use the existing offer, they will not use the new
                offer.  See MR-193 comments for details.
                </b>
            </div>
            <div class="col-sm-1" ></div>
        </div>
        -->
        <p></p>
        <form method="post">
            <div class="scrolled70">
                <#list milkrun.getCurSuppliers() as seller >
                    <#assign name = seller.getCompanyName() >
                    <#if name == "" ><#assign name = seller.getId() ></#if>
                    <div class="row">
                        <div  class="col-sm-5"><h5>
                            <a class="btn btn-link" href="/admin-offer-editor/start?supplierId=${seller.getId()}"> ${name} </a></h5></div>
                    </div>
                    <div class="row">
                        <div class="col-sm-1" ></div>
                        <div  class="col-sm-2"><strong>Offer</strong></div>
                        <div  class="col-sm-1">
                            <div  class="col-sm-5 mine5">
                                Qty
                            </div>
                            <div  class="col-sm-7 mine5">
                                Units
                            </div>
                        </div>
                        <div  class="col-sm-1"><strong>Buy Price</strong></div>
                        <div  class="col-sm-1"><strong>Sell Price</strong></div>
                        <div  class="col-sm-2">
                            <div  class="col-sm-3 mine5">
                                This
                            </div>
                            <div  class="col-sm-3 mine5">
                                Last
                            </div>
                            <div  class="col-sm-3 mine5">
                                Min
                            </div>
                            <div  class="col-sm-3 mine5">
                                Max
                            </div>
                        </div>
                        <div  class="col-sm-2"><strong>Available Qty</strong></div>
                    </div>
                    <#list milkrun.getCurOffersOf(seller.getId()) as offer >
                        <#assign item = offer.getItem() >
                        <div class="row">
                            <div class="col-sm-1" ></div>
                            <div  class="col-sm-2 mine1">
                                <#if session.getUpdatePriceError(offer.getTime()) >
                                    <span class="text-danger">${item.getShortOne()}</span>
                                <#else>
                                    <a href="/admin-offer-editor/edit?offerId=${offer.getTimeAsId()}"
                                       class="btn btn-link btn-sm"
                                       data-toggle="tooltip" title="${item.getDescription()}"
                                    >
                                        ${item.getShortOne()}
                                    </a>
                                </#if>
                            </div>
                            <div  class="col-sm-1">
                                <div  class="col-sm-3 mine2"> ${offer.getQuantity()} </div>
                                <div  class="col-sm-9 mine2"> ${offer.getUnits()} </div>
                            </div>
                            <div  class="col-sm-1 mine2 ">
                                ${offer.getOurBuyPriceAsString()}
                            </div>
                            <div  class="col-sm-1 mine2">
                                ${offer.getOurSellPriceAsString()}
                            </div>
                            <div  class="col-sm-2 mine1">
                                <#assign volume = offer.getVolume() >
                                <div class="row">
                                    <div  class="col-sm-3">
                                        ${volume.getThisWeek()}
                                    </div>
                                    <div  class="col-sm-3">
                                        ${volume.getLastWeek()}
                                    </div>
                                    <div  class="col-sm-3">
                                        ${volume.getMinWeek()}
                                    </div>
                                    <div  class="col-sm-3">
                                        ${volume.getMaxWeek()}
                                    </div>
                                </div>
                            </div>
                            <div  class="col-sm-1 mine1">
                                <#assign available = "Unlimited" >
                                <#if offer.getAvailability()?? >
                                    <#assign available = offer.getAvailability().getAvailableQuantity() >
                                </#if>
                                    <input class="mine4"
                                           type="text"
                                           maxlength="10" size="10"
                                           name="avaliable-${offer.getTimeAsId()}"
                                           value="${available}"/>
                            </div>
                        </div>
                    </#list>
                    <p></p>
                </#list>
            </div>
            <div class="mine1">
                <p></p>
                <input type="submit" value="Update"/>
            </div>
        </form>
    </div>

    <p></p>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
</body>
</html>