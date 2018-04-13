<!DOCTYPE html>
<html lang="en" xmlns:text-align="http://www.w3.org/1999/xhtml">
<#include "macros.ftl">
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta charset="UTF-8">
        <title>Support</title>
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
    .td-total {
        text-align: right;
    }

    .mine4 {
        padding: 0;
        margin: 0;
        font-size: 14px;
        text-align: center;
        color: #000000;
            border-top: 0px solid #e9e9e9;
            border-bottom: 0px solid #e9e9e9;
    }

    </style>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>

    <script>
        $(document).ready(function(){
            $(".clickable-row").click(function() {
                window.location = $(this).data("href");
            });
        });

    </script>

    </head>
    <body class="">
    <@pageHeader3 />

    <p></p>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-3">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="admin"><strong>Admin Home</strong></a>
            </div>
            <div class="col-md-6">
                <h2>Delivered MilkRuns</h2>
            </div>
            <div class="col-md-3">
            </div>
        </div>
    </div>

    <p></p>

    <div class="container-fluid">
        <table>
        <thead>
            <tr>
                <th width="30px" ></th>
                <th width="30px" ></th>
                <th width="30px" >Tree</th>
                <th width="30px" ></th>
                <th width="30px" ></th>
                <th width="30px" ></th>
                <th width="100px" >Name</th>
                <th width="170px">Date</th>
                <th width="100px">State</th>
                <th width="60px">CartOffers</th>
                <th class="td-total" width="90px">Buy Total</th>
                <th class="td-total" width="100px">Sell Total</th>
                <th width="20px"></th>
                <th width="100px">ID</th>
            </tr>
        </thead>
        <!--
            we have two collections to display
             one is for version 3 MilkRuns and below that
             version 2 MilkRuns
        -->
            <#list session.getPostDeliveringMilkRunTreeV3() as tree>
                <#list tree.getNodes() as node >
                    <tr  class='clickable-row' data-href='/milkrun/show2/${node.getMilkRun().getId()}'>
                        <!-- indent by depth -->
                        <#assign depth = node.getDepth() >
                        <#list 1..depth as d >
                            <td width="30px"></td>
                        </#list>

                        <td width="30px" style="background-color:${node.getMilkRunDB().getColor()}">
                        </td>

                        <#list 1..(5-depth) as d >
                            <td width="30px"></td>
                        </#list>

                        <td>
                            ${node.getMilkRun().getName()}
                        </td>
                        <td width="170px">
                            ${Util.formatTimestamp(node.getMilkRun().getTimestamp(), "MM/dd/YY HH:mm z")}
                        </td>
                        <td width="100px">
                            ${node.getMilkRun().getStateAsString(session)}
                        </td>
                        <td class="td-total" >
                            ${node.getCartOfferCount()}
                        </td>
                        <td class="td-total" width="70px">
                            ${node.getBuyTotal()}
                        </td>
                        <td class="td-total" width="100px">
                            ${node.getSellTotal()}
                        </td>
                        <td></td>
                        <td width="100px">
                            ${String.format("%8.8s...", node.getMilkRun().getId())}
                        </td>
                    </tr>
                </#list>
                <tr><td>&nbsp;</td></tr>
            </#list>
        </table>

        <#list session.getPostDeliveringMilkRunTreeV2() as milkrun>
            <div class="row">
                <#if milkrun.getParent()?? >
                <#else>
                    <p></p>
                </#if>
                <div class="col-sm-2"></div>
                <a href="/milkrun/show2/${milkrun.id}" >
                    <div class="col-sm-1" >
                        ${milkrun.getName()}</div>
                    <div class="col-sm-1" >
                    ${milkrun.getTimeAsHumanReadableString("MM/dd/YYYY")}</div>
                    <div class="col-sm-1 ">
                        ${milkrun.getStateAsString(session)}
                    </div>
                    <div class="col-sm-1" style="background-color:${milkrun.getColor()}">
                        ${milkrun.getShortId()}...
                    </div>
                    <div class="col-sm-1" style="text-align: right">
                        <span >${milkrun.getCartOfferCount()},</span>
                    </div>
                    <div class="col-sm-1 ">
                        ${milkrun.getPickTotalAsString()},
                    </div>
                    <div class="col-sm-1 ">
                        ${milkrun.getDropTotalAsString()}
                    </div>
                </a>
                <div class="col-sm-1" >
                    ${milkrun.closer.username}
                </div>
            </div>
        </#list>
    </div>

    <p></p>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
    </body>
</html>
