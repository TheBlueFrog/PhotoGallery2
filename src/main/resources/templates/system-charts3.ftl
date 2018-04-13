<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>System Charts 2</title>
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

    </style>

    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

    <script type="text/javascript">
        google.charts.load('current', {'packages':['corechart', 'bar', 'line' ]});
        google.charts.setOnLoadCallback(drawItemsVsOrdersHistogram);
        google.charts.setOnLoadCallback(drawLoginsPerHourHistogram);

        function drawItemsVsOrdersHistogram() {
            var data = google.visualization.arrayToDataTable([
                ['Items', 'Order Count'],
                <#list systemCharts.itemsVsOrdersHisto as row >
                    ['${row.item}', ${row.orders}]
                        <#if row?has_next >,</#if>
                </#list>
                ]);

            var options = {
                title: '${systemCharts.itemsVsOrdersHistoTitle}',
                legend: { position: 'none' },
                histogram: { bucketSize: 10 },
                minValue: 0,
                maxValue: 30
            };

            var chart = new google.visualization.Histogram(document.getElementById('chart_ItemsVsOrdersHisto'));
            chart.draw(data, options);
        }

        function drawLoginsPerHourHistogram() {
            var data = google.visualization.arrayToDataTable([
                ['Hour', 'Logins'],
                <#list systemCharts.loginsPerHour as row >
                    ['${row.hour}', ${row.logins}]
                       <#if row?has_next >,</#if>
                </#list>
            ]);

            var options = {
                title: '${systemCharts.loginsPerHourTitle}',
                legend: { position: 'none' },
                histogram: { bucketSize: 1 },
                minValue: 0,
                maxValue: 24
            };

            var chart = new google.visualization.ColumnChart(document.getElementById('chart_LoginsPerHour'));
            chart.draw(data, options);
        }

    </script>
</head>
<body class="">
    <@pageHeader3 />

    <div class="container-fluid">
        <p></p>
        <p></p>
        <h3>System Charts 3</h3>
        <p></p>
        <a href="/admin"><strong>Back to Admin</strong></a>
    </div>

    <div class="container-fluid">
        <row>
            <div class="col-sm-10" >
                <div id="chart_LoginsPerHour"></div>
            </div>
        </row>
        <row>
            <div class="col-sm-10" >
                <h2>THIS CHART IS BROKEN</h2>
                <br>
                <div id="chart_ItemsVsOrdersHisto"></div>
            </div>
        </row>
    </div>
    <p>
    </p>

    <p></p>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
</body>
</html>