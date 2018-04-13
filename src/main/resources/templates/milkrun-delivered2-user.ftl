<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<#include "macros-milkrun.ftl">
<head>
    <#assign UI = milkrunDeliveredUI >

    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Delivered MilkRun</title>
    <@styleSheets/>
    <style>
        th {
            border-bottom:1pt solid gray;
        }
        td {
            vertical-align: text-top;
        }
        .td-total {
            text-align: right;
        }
        .td-sub-total {
            text-align: right;
            font-weight: bold;
        }
        .td-grand-total {
            text-align: right;
            border-top:1pt solid gray;
            font-weight: bold;
        }
        .mine {
            text-align: center;
            color: #FFFFFF;
            background-color: #8888FF
        }

        .pick-list {
            width: 100%;
        }
        .pick-list td.price {
            text-align: right;
        }

    </style>
    <style type="text/css">
       <!--
           @page { size : landscape }

           h4 { page-break-before }
       -->
    </style>
</head>
<body class="">
    <p></p>
    <p></p>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-3">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="/my-pages">Back to My Pages</a>
                <br>
            </div>
            <div class="col-md-6">
                <h2>Ordered by ${session.user.name}</h2>
                MilkRun on ${Util.formatTimestamp(UI.milkRun.getTimestamp(), "MMM dd, YYYY")}
                <br>${UI.milkRun.getId()}
            </div>
            <div class="col-md-3">
            </div>
        </div>
    </div>

    <div class="container-fluid">
        <div class="col-sm-12">
            <div class="col-sm-12">
                &nbsp;
            </div>

            <div class="col-sm-12" >
                <#assign needHeaders = true >
                <table class=pick-list" width="90%">
                    <#list UI.getUserConsumerRows() as row >
                        <#if needHeaders >
                            <#assign needHeaders = false >
                            <thead>
                                <td>Reorder</td>
                                <#list row.getHeaders() as header >
                                    <td>
                                        <strong>${header.getName()}</strong>
                                    </td>
                                </#list>
                            </thead>
                        </#if>
                        <tr>
                            <td>
                                <#if row.getOffer().getEnabled() >
                                    <input type="checkbox" id="${row.getOffer().getTimeAsId()}"
                                           onchange="addToCart(${row.getOffer().getTimeAsId()})"
                                        <#if row.isPresentInCart() >
                                            checked
                                        </#if>
                                    >
                                <#else>
                                    <a href="/shop-list-view2/similar/${row.getOffer().getTimeAsString()}">n/a Search</a>
                                </#if>
                            </td>

                            <td>${row.getSeller().getCompanyName()}</td>
                            <td>${Util.flatten(row.getItem().getCategories())}</td>
                            <td>${row.getItem().getShortOne()}</td>
                            <td>${row.getCartOffer().getQuantity()}</td>
                            <td>${row.getOffer().getQuantity()}</td>
                            <td>${row.getTotalQuantity()}</td>
                            <td>${row.getOffer().getUnits()}</td>
                            <td class="td-sub-total">${String.format("$ %.2f", row.getCartOffer().getOurSellPrice())}</td>
                        </tr>
                    </#list>
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td class="td-grand-total"><strong>${String.format("$ %.2f", UI.getConsumerTotal())}</strong></td>
                    </tr>
                </table>
            </div>
        </div>
    </div>

    <@jsIncludes/>

    <script>
    function addToCart(offerId) {
        var add = document.getElementById(offerId).checked;

        var url;
        if (add) {
            url = "/shop-api/addToCart/" + offerId + "/1/once";
        } else {
            url = "/shop-api/removeOfferFromCart/" + offerId;
        }

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