<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<#include "macros-js-inc-dec-qty.ftl" >

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>My Order Grid</title>
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
            <table width="99%">
                <thead>
                    <th width="25%">Item</th>
                    <#list MilkRunDB.findByParentMilkRunIdOrderByNameDesc("") as milkRun >
                        <th width="5%">
                            ${milkRun.getName()}
                        </th>
                    </#list>
                </thead>
                <#list PastOrder.findByUser(session.user) as pastOrder >
                    <#assign offer = pastOrder.getOffer() >
                    <tr>
                        <td>
                            ${String.format("%20.20s", offer.getItem().getShortOne())}
                        </td>
                        <#list MilkRunDB.findByParentMilkRunIdOrderByNameDesc("") as milkRun >
                            <#if pastOrder?is_even_item >
                                <td style="background-color: blanchedalmond">
                            <#else >
                                <td style="background-color: lightcyan">
                            </#if>

                            <#assign i = pastOrder.getQuantity(milkRun.getId()) >
                            <#if (i > 0) > ${i} </#if>
                            </td>
                        </#list>
                    </tr>
                </#list>
            </table>
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
        })

//        function showOrderHistoryChanged(check) {
//            var url = "/session-api/set-attribute?name=showOrderHistory&type=boolean&value=" + check;
//            $.get(url, function(data, status){
//            });
//
//            if (check) {
//                $('.pastOrderDiv').show();
//            } else {
//                $('.pastOrderDiv').hide();
//            }
//        }
//
//        function showDisabledOrderHistoryChanged() {
//            var x = document.getElementById('showDisabledOrderHistory').checked;
//            if (x) {
//                $('.PastOrderDivDisabled').show();
//            } else {
//                $('.PastOrderDivDisabled').hide();
//            }
//        }
//
//        function addToCart(offerId) {
//            var url = "/shop-api/addToCart2?qty=1&offerId=" + offerId;
//            $.get(url, function(data, status){
//                var x = 0;
//                if(status == "success") {
//                    var y = 0;
//                }
//                if (status == "error") {
//                    var y = 0;
//                }
//            });
//
//        }

    </script>
</body>
</html>