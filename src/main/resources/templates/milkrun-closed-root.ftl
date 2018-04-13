<!DOCTYPE html>
<html lang="en">
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

    .mine4 {
        padding: 0;
        margin: 0;
        font-size: 14px;
        text-align: center;
        color: #000000;
            border-top: 0px solid #e9e9e9;
            border-bottom: 0px solid #e9e9e9;
    }
    .td-total {
        text-align: right;
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
                <h2>Closed MilkRun(s)</h2>
            </div>
            <div class="col-md-3">
            </div>
        </div>
    </div>

    <p></p>

    <div class="container-fluid">
        <div class="row">
            <div class="col-md-1">
                <table>
                    <thead>
                    <tr>
                        <th width="30px" >&nbsp;</th>
                    </tr>
                    </thead>
                <#list session.getClosedMilkRunTrees() as tree >
                    <#list tree.getNodes() as node >
                        <tr  >
                            <td>
                                <#if node.isMergeable() >
                                    <button style="height: 18px; padding 0px; margin:0px" onclick="merge('${node.getMilkRun().getId()}')">Merge</button>
                                    <#--<input type="checkbox" id="${node.getMilkRun().getId()}" onchange="mergeCheckChanged(this)"/>-->
                                <#else >
                                    &nbsp;
                                </#if>
                            </td>
                        </tr>
                    </#list>
                    <tr><td>&nbsp;</td></tr>
                </#list>
                </table>
            </div>
            <div class="col-md-11">
                <table>
                    <thead>
                    <tr>
                        <th width="30px" >&nbsp;</th>
                        <th width="30px" >&nbsp;</th>
                        <th width="30px" >Tree</th>
                        <th width="30px" >&nbsp;</th>
                        <th width="30px" >&nbsp;</th>
                        <th width="30px" >&nbsp;</th>
                        <th width="150px">Name</th>
                        <th width="170px">Date</th>
                        <th width="100px">State</th>
                        <th width="100px">CartOffers</th>
                        <th class="td-total" width="70px">Buy Total</th>
                        <th class="td-total" width="100px">Sell Total</th>
                        <th width="20px" >&nbsp;</th>
                        <th width="100px">ID</th>
                    </tr>
                    </thead>
                <#list session.getClosedMilkRunTrees() as tree >
                    <#list tree.getNodes() as node >
                        <tr  class='clickable-row' data-href='/milkrun/show2/${node.getMilkRun().getId()}'>
                            <#assign depth = node.getDepth() >
                            <!-- indent by depth -->
                            <#list 1..depth as d >
                                <td width="30px"></td>
                            </#list>
                            <td width="30px" style="background-color:${node.getMilkRunDB().getColor()}">
                            </td>
                            <#list 1..(5-depth) as d >
                                <td width="30px"></td>
                            </#list>
                            <td width="150px">
                            ${node.getMilkRun().getName()}
                            </td>
                            <td width="170px">
                            ${Util.formatTimestamp(node.getMilkRun().getTimestamp(), "MM/dd/YYYY HH:mm z")}
                            </td>
                            <td width="100px"
                                <#if MilkRunDB.findById(node.getMilkRun().getId()).hasIssues() >
                                style="background-color:#FF8080"
                                </#if>
                            >
                            ${node.getMilkRun().getStateAsString(session)}
                            </td>
                            <td width="100px">
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
                            ${node.getMilkRun().getShortId()}...
                            </td>
                        </tr>
                    </#list>
                    <tr><td>&nbsp;</td></tr>
                </#list>
                </table>
            </div>
        </div>
    </div>
    <p></p>

    <!--<a href="/milkrun-merge/id1/id2">Merge Test</a>-->

    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>

    <script>
        var selected = [];

        function unsplitMilkRun(but) {
            if (confirm("Are you sure? \nThe unsplit cannot be undone.")) {
                location.assign("/milkrun-unsplit/" + but.id);
            }
        }

        function mergeCheckChanged(check) {
            var checked = check.checked;
            var i = selected.indexOf(check.id);
            if (checked) {
                if (i < 0) {
                    selected.push(check.id);
                }
            }
            else {
                if (i > -1) {
                    selected.splice(i, 1);
                }
            }
        }

        function merge(id) {
            var url = "/milkruns-merge?milkRunId=" + id;
            window.location = url;
        }
    </script>
    </body>
</html>
