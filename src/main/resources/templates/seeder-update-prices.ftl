<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<#include "macros-milkrun.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Seeder Update Items</title>
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
        margin-bottom:  5px;
        color: #000000;
            border-top: 1px solid #cccccc;
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
            border-top: 0;
            border-bottom: 0;
    }
    .mine5 {
        padding: 0;
        margin: 0;
        text-align: left;
    }
    .mine5r {
        padding: 0;
        margin: 0;
        text-align: right;
    }
    .mine5c {
        padding: 0;
        margin: 0;
        text-align: right;
    }
    .scrolled70 {
        verflow-y:scroll; overflow-x:hidden;
        max-height: 55vh;
    }
    .scrolled30 {
        verflow-y:scroll; overflow-x:hidden;
        max-height: 10vh;
    }
    </style>

    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

    <script type="text/javascript">
        google.charts.load('current', {'packages':['corechart', 'bar', 'line' ]});
        google.charts.setOnLoadCallback(drawSales);

        function drawSales() {
            var data = new google.visualization.DataTable();

            ${priceData.getChartData()}

//            data.addColumn('date', 'Date');
//            data.addColumn('number', 'Sales');
//
//            data.addRows([
//                [new Date(2017, 8, 1), 10 ],
//                [new Date(2017, 9, 1), 11 ],
//                [new Date(2017, 10, 1), 12 ],
//            ]);

            var options = {
                title: 'Item Quantity Ordering History',
                isStacked: false,
                bar: {groupWidth: "99%"},
                hAxis: {
                    title: 'Date',
                    format: 'MMM/d/yy',
                    viewWindow: {
                        min: new Date(2017, 0, 1),
                        max: new Date(2018, 0, 1)
                    }
                },
                vAxis: {
                    title: ''
                },
                chartArea: {  width: "60%", height: "75%" }
            };

            var chart = new google.visualization.LineChart(document.getElementById('chart_UserAccountsStacked'));
            chart.draw(data, options);
        }

    </script>

</head>
<body class="">
    <@newTopOfPageHeader "" />

    <#assign user = session.getUser() >
    <#assign name = session.getUser().getCompanyName() >

    <div class="container">
        <div class="row col-md-12">
            <div class="col-md-3">
                <h3>${user.getName()}</h3>
            </div>
            <div class="col-md-2">
                <h3>Manage Items</h3>
            </div>
            <div class="col-md-7">
            </div>
        </div>
    </div>

    <p></p>

    <div class="container">
        <div class="row">
            <div class="col-sm-5 ">
                <button class="btn" onclick="createItem()">
                    Create New Item
                </button>
            </div>
        </div>
        <hr style="height: 1px; background-color: #e9e9e9">
    </div>
    <div class="container">
        <p></p>
        <form method="post">
            <p></p>
            <div class="row">
                <div class="col-sm-3" ></div>
                <div  class="col-sm-2" style="text-align: center"> <strong>MilkRun Sales Volume </strong></div>
                <#--<div  class="col-sm-2" style="text-align: center"> <strong>Pricing</strong> </div>-->
            </div>
            <div class="row">
                <div  class="col-sm-3"><h4>Active Items</h4></div>
                <div  class="col-sm-2">
                    <div  class="col-sm-3 mine5"> This </div>
                    <div  class="col-sm-3 mine5"> Last </div>
                    <div  class="col-sm-3 mine5"> Min  </div>
                    <div  class="col-sm-3 mine5"> Max  </div>
                </div>
                <div  class="col-sm-1 mine5c"> Cost  </div>
            </div>

            <!-- put out 2 lists, active and then inactive items -->
            <#list Item.findByUserIdAndActiveOrderByShortOne(user.getId(), true) as item >
                <div class="row ">
                    <div  class="col-sm-3 ">
                        <a href="/seeder-item-editor/edit?itemId=${item.getId()}"
                           class="btn btn-link btn-sm"
                           data-toggle="tooltip" title="${item.getDescription()}"
                        >
                            <#if item.getShortOne().length() == 0>
                                &lt; blank &gt;
                            <#else >
                                ${item.getShortOne()}
                            </#if>
                        </a>
                    </div>
                    <div  class="col-sm-2 ">
                        <#assign volume = item.getVolume() >
                        <div  class="col-sm-11">
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
                    <div class="col-sm-1 mine5r" data-toggle="tooltip" title="Cost to MilkRun">
                    </div>
                </div>
            </#list>
            <div class="row ">
                <p></p>
                <div  class="col-sm-3"><h4>Inactive Items</h4></div>
            </div>
            <#list Item.findByUserIdAndActiveOrderByShortOne(user.getId(), false) as item >
                <div class="row ">
                    <div  class="col-sm-3 ">
                        <a href="/seeder-item-editor/edit?itemId=${item.getId()}"
                           class="btn btn-link btn-sm"
                           data-toggle="tooltip" title="${item.getDescription()}"
                        >
                            <#if item.getShortOne().length() == 0>
                                &lt; blank &gt;
                            <#else >
                                ${item.getShortOne()}
                            </#if>
                        </a>
                    </div>
                </div>
            </#list>
        </form>
    </div>

    <p>&nbsp;</p>

    <div class="container">
        <row>
            <div class="col-sm-12">
                <hr style="height: 2px; background-color: lightgray">
                <div id="chart_UserAccountsStacked" style="height: 400px"></div>
            </div>
        </row>
    </div>

    <p>&nbsp;;</p>
    <p>&nbsp;;</p>
    <@jsIncludes/>

    <script>
        function createItem() {
            var url="/seeder-item-editor/create";
            location.assign(url);
        }
        function itemSelect(itemId) {
            location.assign("/seeder-item-editor/edit?itemId=" + itemId);
        }

    </script>
</body>
</html>