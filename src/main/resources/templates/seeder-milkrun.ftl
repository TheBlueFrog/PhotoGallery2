<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<#include "macros-milkrun.ftl">
<head>
    <#if UI?? >
        <#assign milkRun = UI.milkRun >
    </#if>

    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>MilkRun</title>
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
        .docs {
            color: #88DD88;
            text-align: right;
            font-weight: bold;
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
    <@newTopOfPageHeader "<a href=\"/seeder-update-prices\" class=\"btn btn-link\"><b>MANAGE ITEMS</b></a>" />

    <div class="container">
        <div class="row col-md-12">
            <div class="col-md-3">
                <h3>${session.getUser().getCompanyName()}</h3>
            </div>
            <div class="col-md-2">
                <h3>MilkRun Items</h3>
            </div>
            <div class="col-md-7">
            </div>
        </div>
    </div>

    <p>&nbsp;</p>
    <p>&nbsp;</p>
    <div class="container">
        <div class="row">

            <div class="col-sm-4 well">
                MilkRuns
                <select class="mono" id="milkRun" onchange="milkRunSelected(this.value)">
                    <option value="None" selected >None</option>
                    <#list MilkRunDB.findAllOrderByNameDesc() as milkRunSelector >
                        <#if  ! (milkRunSelector.getState().toString() == "Split") >
                            <option value="${milkRunSelector.getId()}"
                                <#if milkRun?? && (milkRun.getId() == milkRunSelector.getId()) >
                                    selected
                                </#if>
                            >
                                <#assign s = String.format("%-12.12s %s %s %s",
                                milkRunSelector.getName(),
                                Util.formatTimestamp(milkRunSelector.getTimestamp(), "MMM dd, YYYY"),
                                milkRunSelector.getState().toString(),
                                String.format("%8.8s...", milkRunSelector.getId())).replace(" ", "&nbsp;") >
                                        ${s}
                            </option>
                        </#if>
                    </#list>
                </select>
            </div>

            <div class="col-sm-1"></div>
            <div class="col-sm-3 well">
                <#if milkRun?? >
                    <h4>Summary</h4>
                    Total Buy Price: ${UI.getSupplierGrandTotalAsString()}
                    <br>
                    Item Count: ${UI.getCartOfferCount()}
                    <br>
                    Eater Count: ${UI.getConsumerCount()}
                </#if>
            </div>
        </div>

        <#if milkRun?? >
            <div class="row">
                <div class="col-sm-12">
                    ${UI.getSupplierTable()}
                    <p></p>
                    <p></p>
                </div>
            </div>
        </#if>
    </div>

    <@jsIncludes/>
    <script>
        function milkRunSelected(id) {
            var url="/seeder-milkrun?milkRunId=" + id;
            location.assign(url);
        }
    </script>

</body>
</html>


