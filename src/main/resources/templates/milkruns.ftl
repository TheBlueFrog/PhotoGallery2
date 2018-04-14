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

    </style>

    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
      google.charts.load('current', {'packages':['corechart', 'bar']});
      google.charts.setOnLoadCallback(drawPieChart);
      google.charts.setOnLoadCallback(drawPieChart2);
      google.charts.setOnLoadCallback(drawCountsChart);

      function drawCountsChart() {
        var data = google.visualization.arrayToDataTable([
           ['Date', 'Pickup $', 'Delivery $', 'Items', 'Seeders', 'Eaters'],

           <#assign i = 0 >
            <#list chartData.counts as row>
                ['${row.date}', ${row.pickupTotal}, ${row.deliveryTotal}, ${row.itemCount}, ${row.seederCount}, ${row.eaterCount} ]
                <#if row?has_next >,
                </#if>
                <#assign i++ >
            </#list>

            <#if (i == 0) >
                ['06/01/2017', '20', '30', 17, 2, 5 ]
            </#if>
        ]);

        var options = {
          chart: {
            title: 'Information about each MilkRun',
            subtitle: 'Pickup and Delivery money and some counts',
          }
        };

        var chart = new google.charts.Bar(document.getElementById('countsChart'));
        chart.draw(data, options);
      }

      function drawPieChart() {

        var data = google.visualization.arrayToDataTable([
          ['Seeder', 'Items'],
            <#list chartData.seederShare as row>
                ['${row.name}', ${row.count} ]
                <#if row?has_next >,
                </#if>
            </#list>
//          ['Work',     11]
        ]);

        var options = {
          title: 'Seeder Share of Items for all MilkRuns'
        };

        var chart = new google.visualization.PieChart(document.getElementById('piechart'));
        chart.draw(data, options);
      }

      function drawPieChart2() {

        var data = google.visualization.arrayToDataTable([
          ['Eater', 'Items'],
            <#list chartData.eaterShare as row>
                ['${row.name}', ${row.count} ]
                <#if row?has_next >,
                </#if>
            </#list>
//          ['Work',     11]
        ]);

        var options = {
          title: 'Eater Share of Items for all MilkRuns'
        };

        var chart = new google.visualization.PieChart(document.getElementById('piechart2'));
        chart.draw(data, options);
      }
    </script>
</head>
<body class="">
    <@pageHeader3 "milkruns.ftl"/>

    <p>
    </p>

    <div class="container-fluid">
        <row>
            <div class="col-sm-4" >
                <div id="countsChart" style="width: 400px; height: 300px;"></div>
            </div>
            <div class="col-sm-4" >
                <div id="piechart" style="width: 400px; height: 300px;"></div>
            </div>
            <div class="col-sm-4" >
                <div id="piechart2" style="width: 400px; height: 300px;"></div>
            </div>
        </row>
    </div>

    <p>
    </p>

    <div class="container-fluid">
        <p></p>
        <h4>Past MilkRuns</h4>
        <p></p>
        <p></p>
        <#list milkruns as milkrun>
            <div class="row">
            <div class="col-sm-2" > ${milkrun.timeAsHumanReadableString}</div>
            <div class="col-sm-2" > ${milkrun.deliverer.username}</div>
            <div class="col-sm-1" >
            </div>
            <div class="col-sm-6" > <a href="milkrun?milkRunId=${milkrun.id}">${milkrun.id}</a></div>
            </div>
        </#list>
    </div>

    <p></p>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
</body>
</html>