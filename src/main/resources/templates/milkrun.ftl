<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>MilkRun Information</title>
    <@styleSheets/>
    <style>
        th {
            text-align: left;
            border-bottom:1pt solid gray;
        }
        td {
            text-align: left;
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
    <#if milkrunUI?? >

        <div class="container">
            <#if milkrunUI.milkRun.id == "" >
                <h3 >MilkRun Status as of now</h3>
            <#else>
                <h3 >MilkRun ${milkrunUI.milkRun.id} <br> Made on ${milkrunUI.milkRun.timeAsHumanReadableString}</h3>
                <p></p>
            </#if>
            <div class="row">
                <div class="col-sm-8">
                    <p></p>
                    <h4 class="crimson-text font-italic">Route</h4>

                    <table style="width:90%">
                        <#list milkrunUI.milkRun.route.stops as stop >
                            <tr>
                                <td style="width:5%">${stop.number}</td>
                                <td style="width:10%">${stop.type}</td>
                                <td style="width:30%">${stop.name}</td>
                                <#if stop.streetAddress?contains("Unknown") >
                                    <td style="width:55%"><span class="text-danger">${stop.streetAddress}</span></td>
                                <#else>
                                <td style="width:55%">${stop.streetAddress}</td>
                                </#if>
                            </tr>
                        </#list>
                    </table>
                    <p></p>
                </div>

                <div class="col-sm-4">
                    <p></p>
                    <a href="milkrun-map"><strong>Pickup/Delivery Map</strong></a>
                    <p></p>
                    <p></p>

                    <#if milkrunUI.milkRun.id == "" >
                        <strong>Execute the Milk Run</strong>
                        <p>This will commit the MilkRun below to the database.</p>
                        <a href="milkrun-commit"><p class="mine">Commit</p></a>
                    <#else>
                        <p></p>
                        <strong>Discrepancies</strong>
                        <br>
                        <#list milkrunUI.milkRun.discrepancies as discrepancy>
                            ${discrepancy.cartOfferIndex}&nbsp;&nbsp;${discrepancy.discrepancy}
                            <br>
                        </#list>

                        <form name="discrepancy" method="post">
                        <input type="hidden" name="operation" value="AddDiscrepancy" />
                        <input type="hidden" name="milkrunId" value="${milkrunUI.milkRun.id}" />
                        <input type="number" name="cartOfferIndex" min="0" max="99">
                        <input type="text" class="milkRunRecord-text" name="discrepancy" placeholder="New Discrepancy" size="50"/>
                        <br>
                        <input type="submit" class="milkRunRecord-button" value="Add" />
                        </form>
                    </#if>
                </div>
            </div>
        </div>
        <div class="container">
            <div class="row">
                <div class="col-sm-12">
                    <h4>Packing/Pickup List</h4>
                    Note: ID numbers are unique to this MilkRun.  They allow matching
                    <br>
                    pickup and and delivery items within this particular MilkRun.

                    <table style="width:90%">
                        <#list 1..milkrunUI.supplierRows as row>
                            <tr>
                                <#list 1..milkrunUI.supplierCols as col>
                                    ${milkrunUI.getSupplierCell(row,col)}
                                </#list>
                            </tr>
                        </#list>
                    </table>

                    <p></p>
                    <p></p>
                    <hr>
                    <h4>Delivery List</h4>

                    <#assign row = 0 >
                    <table style="width:90%">
                        <#list 1..milkrunUI.deliveryRows as row>
                            <tr>
                                <#list 1..milkrunUI.deliveryCols as col>
                                    ${milkrunUI.getDeliveryCell(row,col)}
                                </#list>
                            </tr>
                        </#list>
                    </table>
                </div>
            </div>
        </div>
    <#else>
        <h2>No delivery information.</h2>
    </#if>

    <@jsIncludes/>
</body>
</html>