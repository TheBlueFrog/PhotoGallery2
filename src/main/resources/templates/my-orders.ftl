<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<#include "macros-js-inc-dec-qty.ftl" >

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Administration</title>
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

    td {
            text-align: left;
            vertical-align: text-top;
    }

    </style>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>


</head>
<body class="">
    <#assign user = session.user >
    <#assign milkRun = MilkRunDB.findOpen() >
    <#assign openMilkRunId = milkRun.getId() >
    <#assign deliveryDate = Util.formatTimestamp(milkRun.getEstDeliveringTimestamp(), "MMM dd, YYYY") >

    <@pageHeader "cart.html"/>
    <section class="banner banner-short banner-cart bg-parallax">
        <div class="overlay"></div>
        <div class="container">
            <div class="banner-content text-center">
                <h2 class="page-title">${user.getName()}'s Order History</h2>
                <div class="breadcrumbs">
                    <a href="/">Home</a>
                    <span>ORDER HISTORY</span>
                </div>
            </div>
        </div>
    </section>


    <p></p>
    <div class="container">
        <div class="row alert-message-container">
            <div class="alert alert-success alert-dismissible" role="alert">
                <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <span class="alert-message"></span> has been removed from your cart.
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="col-sm-10" >
                    <label>
                        <input type="checkbox" id="showOrderHistory" onchange="showOrderHistoryChanged(this.checked)"
                               <#if session.getAttributeB("showOrderHistory") >
                                   checked
                               </#if>
                        >
                        Show ordering history details
                    </label>
                </div>
            </div>
<p>&nbsp;</p>
            <div class="row">
                <div class="col-md-12">
                    <div class="col-md-4">

                    </div>
                    <div class="col-md-1">
                        <div class="col-md-6">
                            Runs
                        </div>
                        <div class="col-md-6">
                            Qty
                        </div>
                    </div>
                </div>
            </div>
            <#assign openMilkRun = MilkRunDB.findOpen() >
            <#list PastOrder.findByUser(user) as pastOrder >
                <#assign offer = pastOrder.getOffer() >
                <div class="row">
                    <div class="col-md-12">
                        <div class="col-md-4">
                            <#if offer.getEnabled() >
                                <@quantitySteppers offer getCartOfferQuantity(offer.getTime(), user.getId(), openMilkRun.getId()) />

                                <#--<input type="checkbox" name="${offer.getTimeAsId()}"-->
                                       <#--onchange="addToCart(${offer.getTimeAsId()})"-->
                                       <#--<#if session.user.cartContains(openMilkRun.getId(), offer.getTimeAsId()) >-->
                                            <#--checked-->
                                       <#--</#if>-->
                                       <#-->-->
                            <#--<#else>-->
                                <#--<a class="btn btn-link" href="/shop-list-view2/similar/${offer.getTimeAsString()}">Search</a>-->
                            </#if>
                        </div>
                        <div class="col-md-1">
                            <div class="col-md-6">
                                ${pastOrder.getNumOrders()}
                            </div>
                            <div class="col-md-6">
                                ${pastOrder.getQuantity()}
                            </div>
                        </div>
                        <div class="col-md-2">
                            <#if offer.getEnabled() >
                                <a class="btn btn-link" href="/single-product?offerId=${offer.getTimeAsString()}">
                                    ${pastOrder.getOffer().getItem().getShortOne()}
                                </a>
                            <#else>
                                <a class="btn btn-link" href="/shop-list-view2/similar/${offer.getTimeAsString()}">
                                    ${pastOrder.getOffer().getItem().getShortOne()}
                                </a>
                            </#if>
                        </div>

            <#--
                        <div class="col-md-5">
                                    <#list pastOrder.getCartOffers() as cartoffer >
                                        <div class="pastOrderDiv">
                                            <#if cartoffer.getOffer().getEnabled() >
                                                ${Util.formatTimestamp(cartoffer.getTime(), "MM/dd/YYYY")}
                                            <#else>
                                                <i>${Util.formatTimestamp(cartoffer.getTime(), "MM/dd/YYYY")}</i>
                                            </#if>
                                            <br>
                                        </div>
                                    </#list>
                        </div>
            -->
                            <#--${pastOrder.getOffer().getItem().getDescription()}-->
                    </div>
                    <hr >
                </div>

            </#list>
        </div>
    </div>

    <p>&nbsp;</p>
    <p>&nbsp;</p>
    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>

    <@incDecOfferQty 0 />

    <script>
        $(document).ready(function() {
            <#if session.getAttributeB("showOrderHistory") >
                showOrderHistoryChanged(true);
            <#else >
                showOrderHistoryChanged(false);
            </#if>
        })

        function showOrderHistoryChanged(check) {
            var url = "/session-api/set-attribute?name=showOrderHistory&type=boolean&value=" + check;
            $.get(url, function(data, status){
            });

            if (check) {
                $('.pastOrderDiv').show();
            } else {
                $('.pastOrderDiv').hide();
            }
        }

        function showDisabledOrderHistoryChanged() {
            var x = document.getElementById('showDisabledOrderHistory').checked;
            if (x) {
                $('.PastOrderDivDisabled').show();
            } else {
                $('.PastOrderDivDisabled').hide();
            }
        }

        function addToCart(offerId) {
            var url = "/shop-api/addToCart2?qty=1&offerId=" + offerId;
            $.get(url, function(data, status){
                var x = 0;
                if(status == "success") {
                    var y = 0;
                }
                if (status == "error") {
                    var y = 0;
                }
            });

        }

    </script>
</body>
</html>