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
      google.charts.setOnLoadCallback(drawStacked);
      google.charts.setOnLoadCallback(drawLoginsPerDayChart);
      google.charts.setOnLoadCallback(drawCountCostChart);
      google.charts.setOnLoadCallback(drawCartOfferMetricsByDayChart);
      google.charts.setOnLoadCallback(drawMilkRunAveragesChart);

        function drawStacked() {
          var data = new google.visualization.DataTable();
          data.addColumn('date', 'Date');
          data.addColumn('number', 'Seeders');
          data.addColumn('number', 'Feeders');
          data.addColumn('number', 'Eaters');

          data.addRows([
          <#list systemCharts.userRows as row >
            [new Date(${row.year}, ${row.month}, ${row.day}), ${row.seeder}, ${row.feeder}, ${row.eater}]
            <#if row?has_next >,
            </#if>
          </#list>
          ]);

          var options = {
            title: 'User accounts',
            isStacked: true,
            hAxis: {
              title: 'Date',
              format: 'M/d/yy',
            viewWindow: {
                min: new Date(2017, 1, 1),
                max: new Date(2017, 3, 1)
              }
            },
            vAxis: {
              title: ''
            }
          };

          var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
          chart.draw(data, options);
        }

        function drawLoginsPerDayChart() {
          var data = new google.visualization.DataTable();
          data.addColumn('date', 'Date');
          data.addColumn('number', 'Logins');
          data.addColumn('number', 'Fails');
          data.addColumn('number', 'CartOffers');

          data.addRows([
          <#list systemCharts.loginsPerDayRows as row >
            [new Date(${row.year}, ${row.month}, ${row.day}), ${row.logins}, ${row.fails}, ${row.cartOffers} ]
            <#if row?has_next >,
            </#if>
          </#list>
          ]);

          var options = {
            title: 'Daily Counts',
//            isStacked: true,
            hAxis: {
              title: 'Date',
                format: 'M/d/yy',
//              format: 'h:mm a',
              viewWindow: {
                min: new Date(2017, 1, 1),
                max: new Date(2017, 3, 1)
              }
            },
            vAxis: {
              title: 'Counts'
            }
          };

          var chart = new google.visualization.ColumnChart(document.getElementById('loginsPerDay_div'));
          chart.draw(data, options);
        }

      function drawCountCostChart() {
        var data = google.visualization.arrayToDataTable([
          ['Cart Offer quantity', 'Cart Offer Price'],
            <#list systemCharts.offerCostCountRows as row>
                [ ${row.count}, ${row.price} ]
                <#if row?has_next >,
                </#if>
            </#list>
//          [ 8,      12],
//          [ 4,      5.5],
//          [ 6.5,    7]
        ]);

        var options = {
          title: 'Cart Offer price vs quantity',
          hAxis: {title: 'Cart Offer Quantity', minValue: ${systemCharts.offerCostCountOptions.hMin}, maxValue: ${systemCharts.offerCostCountOptions.hMax}},
          vAxis: {title: 'Cart Offer Price ($)', minValue: ${systemCharts.offerCostCountOptions.vMin}, maxValue: ${systemCharts.offerCostCountOptions.vMax}},
          legend: 'none'
        };

        var chart = new google.visualization.ScatterChart(document.getElementById('countCostChart'));
        chart.draw(data, options);
      }


      function drawCartOfferMetricsByDayChart() {
          var data = new google.visualization.DataTable();
          data.addColumn('date', 'Date');
          data.addColumn('number', 'Price');
          data.addColumn('number', 'Quantity');

          data.addRows([
          <#list systemCharts.cartOfferMetricsByDayRows as row >
            [new Date(${row.year}, ${row.month}, ${row.day}), ${row.price}, ${row.quantity} ]
            <#if row?has_next >,
            </#if>
          </#list>
          ]);

          var options = {
            title: 'Average DeliveredCartOffer price and quantity by day',
//            isStacked: true,
            hAxis: {
              title: 'Date',
                format: 'M/d/yy',
//              format: 'h:mm a',
              viewWindow: {
                min: new Date(2017, 1, 1),
                max: new Date(2017, 3, 1)
              }
            },
            vAxis: {
              title: ''
            }
          };

          var chart = new google.visualization.ColumnChart(document.getElementById('cartOfferMetricsByDay_div'));
          chart.draw(data, options);
      }

      function drawMilkRunAveragesChart() {
        var data = google.visualization.arrayToDataTable([
           ['Date', '$/pickup', '$/drop'],

           <#assign i = 0 >
            <#list systemCharts.milkRunAveragesRows as row>
                ['${row.date}', ${row.pickDollars}, ${row.dropDollars} ]
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
            title: 'Averages of each MilkRun',
            subtitle: '$ per Pick and $ per Drop',
          }
        };

        var chart = new google.charts.Bar(document.getElementById('milkRunAverages_div'));
        chart.draw(data, options);
      }


    </script>
</head>
<body class="">
    <@pageHeader3 "system.ftl"/>

    <p></p>
    <div class="container-fluid">
        <p></p>
        <h3>System Management Links</h3>
        <p></p>
        <a href="offer-markup-editor"><h4>Offer Markup Editor</h4></a>
        <p></p>
    </div>


    <div class="container-fluid">
        <p></p>
        <p></p>
        <h3>System Summary Charts</h3>
        <p></p>
    </div>

    <div class="container-fluid">
        <row>
            <div class="col-sm-10" >
                <div id="chart_div"></div>
            </div>
        </row>
        <row>
            <div class="col-sm-10" >
                <div id="loginsPerDay_div"></div>
            </div>
        </row>
        <row>
            <div class="col-sm-10" >
                <div id="cartOfferMetricsByDay_div"></div>
            </div>
        </row>
        <row>
            <div class="col-sm-1" ></div>
            <div class="col-sm-10" >
                <div id="milkRunAverages_div"></div>
            </div>
        </row>

        <row>
            <div class="col-sm-10" >
                <div id="countCostChart" ></div>
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