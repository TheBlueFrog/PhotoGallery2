<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Charts for ${user.getName()}</title>
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
    google.charts.setOnLoadCallback(drawMilkRunSpendChart);


    function drawMilkRunSpendChart() {
    var data = google.visualization.arrayToDataTable([
        ['Date', 'Spend' ],

        <#list userCharts.milkRunSpendRows as row>
            ['${row.date}', ${row.spend} ]
            <#if row?has_next >,</#if>
        </#list>
    ]);

    var options = {
        chart: {
            title: 'Spend by MilkRun',
            subtitle: 'x',
            hAxis: {
                title: 'Date',
                format: 'M/d/yy',
                viewWindow: {
                    min: new Date(2017, 1, 1),
                    max: new Date(2018, 1, 1)
                }
            },
            vAxis: {
                title: '$'
            }
        }
    };

    var chart = new google.visualization.LineChart(document.getElementById('chart_MilkRunSpend'));
        chart.draw(data, options);
    }

    </script>

</head>
<body class="">
    <@pageHeader3 />

    <div class="container-fluid">
        <p></p>
        <p></p>
        <h3>Charts for ${user.getName()}</h3>
        ${String.format("%8.8s", user.getId())}
        <p></p>
        <a href="/admin"><strong>Back to Admin</strong></a>
        <br>
        <a href="/user-details/${user.getId()}"><strong>Back to Details</strong></a>
    </div>

    <div class="container-fluid">
        <row>
            <div class="col-sm-10" >
                <div id="chart_MilkRunSpend"></div>
            </div>
        </row>
    </div>

    <p></p>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
</body>
</html>