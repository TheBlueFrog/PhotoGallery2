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
    google.charts.setOnLoadCallback(drawUserAccountsStacked);
    google.charts.setOnLoadCallback(drawSpendHistogram);
    google.charts.setOnLoadCallback(drawLatestSpendHistogram);
    google.charts.setOnLoadCallback(drawMilkRunTotalsChart);
    google.charts.setOnLoadCallback(drawMilkRunOrdersChart);
    google.charts.setOnLoadCallback(drawMilkRunOrders2Chart);
    google.charts.setOnLoadCallback(drawWeeklyOrderingChart);
    google.charts.setOnLoadCallback(drawStripeChargesChart);
    google.charts.setOnLoadCallback(drawChartLogins);
    google.charts.setOnLoadCallback(drawChartFailsFirsts);
    google.charts.setOnLoadCallback(orderingActivityHisto);
    google.charts.setOnLoadCallback(drawOrderingSinceJoinChart);

    function drawUserAccountsStacked() {

        var data = new google.visualization.DataTable();
        data.addColumn('date', 'Date');
        data.addColumn('number', 'Seeders');
        data.addColumn('number', 'Feeders');
        data.addColumn('number', 'Eaters');

        data.addRows([
      <#list systemCharts.userRows as row >
        [ new Date(${row.year},${row.month},${row.day}), ${row.seeder}, ${row.feeder}, ${row.eater} ]
        <#if row?has_next >,
        </#if>
      </#list>
      ]);

      var options = {
        title: 'Accounts',
        isStacked: true,
         bar: {groupWidth: "60%"},
        hAxis: {
          title: 'Week of Year'
//            viewWindow: {
//                min: 0,
//                max: 52
//              }
        },
        vAxis: {
          title: ''
        }
      };

        var chart = new google.visualization.ColumnChart(document.getElementById('chart_UserAccountsStacked'));
        chart.draw(data, options);
    }

    function drawSpendHistogram() {
        var data = google.visualization.arrayToDataTable([
          ['User', 'Spend'],
          <#list systemCharts.allOrderPriceHisto as row >
            ['${row.user}', ${row.spend} ]
            <#if row?has_next >,
            </#if>
          </#list>
          ]);

        var options = {
            title: '${systemCharts.allOrderPriceHistoTitle}',
            legend: { position: 'none' },
            histogram: { bucketSize: 10 },
            minValue: 0,
            maxValue: 300
        };

        var chart = new google.visualization.Histogram(document.getElementById('chart_SpendHistogram'));
        chart.draw(data, options);
    }

    function drawLatestSpendHistogram() {
        var data = google.visualization.arrayToDataTable([
              ['User', 'Spend'],
              <#list systemCharts.latestOrderPriceHisto as row >
                ['${row.user}', ${row.spend}]
                <#if row?has_next >,
                </#if>
              </#list>
              ]);

        var options = {
            title: 'User spend in latest MilkRun',
            'height':400,
            legend: { position: 'none' },
            histogram: { bucketSize: 10 },
            minValue: 0,
            maxValue: 300,
            hAxis: {
                title: 'Spend $'
            },
            vAxis: {
                title: 'Count'
            }
        };

        var chart = new google.visualization.Histogram(document.getElementById('chart_LatestSpendHistogram'));
        chart.draw(data, options);
    }

    function orderingActivityHisto() {
        var data = google.visualization.arrayToDataTable([
            ['User', 'Activity'],
        <#list systemCharts.OrderingActivityHisto as row >
            ['${row.user}', ${row.activity}]
            <#if row?has_next >,
            </#if>
        </#list>
        ]);

        var options = {
            title: 'User Ordering Activity  (Includes only people who have actually ordered)',
            'height':400,
            legend: { position: 'none' },
            histogram: { bucketSize: 0.01 },
            minValue: 0,
            maxValue: 1.0,
            hAxis: {
                title: 'Activity, fraction of possible MilkRuns in which the user ordered'
            },
            vAxis: {
                title: 'Count'
            }
        };

        var chart = new google.visualization.Histogram(document.getElementById('chart_orderingActivityHisto'));
        chart.draw(data, options);
    }

    function drawMilkRunTotalsChart() {
        var data = google.visualization.arrayToDataTable([
            ['Date', 'COGS', 'GMV', 'Net $' ],

            <#assign i = 0 >
            <#list systemCharts.milkRunTotalsRows as row>
                ['${row.name}', ${row.buyPrice}, ${row.sellPrice}, ${row.netDollars} ]
                <#if row?has_next >,
                </#if>
                <#assign i++ >
            </#list>
        ]);

        var options = {
            title: 'Per MilkRun',
            'height':400,
            hAxis: {
                title: 'MilkRun'
            },
            vAxis: {
                title: ''
            }
        };

        var chart = new google.visualization.LineChart(document.getElementById('chart_MilkRunTotals'));
        chart.draw(data, options);
    }

    function drawMilkRunOrdersChart() {
        var data = google.visualization.arrayToDataTable([
            ['MilkRun', 'Items', 'Items per Cart' ],

        <#assign i = 0 >
        <#list systemCharts.milkRunTotalsRows as row>
            ['${row.name}', ${row.orders}, ${row.ordersPerCart} ]
            <#if row?has_next >,
            </#if>
            <#assign i++ >
        </#list>
        ]);

        var options = {
            title: 'Item Metrics',
            'height':400,
            series: {
                0: {targetAxisIndex: 0},
                1: {targetAxisIndex: 1},
            },
            vAxes: {
                // Adds titles to each axis.
                0: {title: 'Total Items'},
                1: {title: 'Items per Cart'}
            },
            hAxis: {
                title: 'Run'
            }
        };

        var chart = new google.visualization.LineChart(document.getElementById('chart_MilkRunAverages'));
        chart.draw(data, options);
    }
    function drawMilkRunOrders2Chart() {
        var data = google.visualization.arrayToDataTable([
        ['MilkRun', '$ per Cart', 'Number of Carts'],

        <#assign i = 0 >
        <#list systemCharts.milkRunTotalsRows as row>
            ['${row.name}', ${row.dollarsPerCart}, ${row.numCarts} ]
            <#if row?has_next >,
            </#if>
            <#assign i++ >
        </#list>
        ]);

        var options = {
        title: 'Cart Metrics',
        'height':400,
        series: {
        0: {targetAxisIndex: 0},
        1: {targetAxisIndex: 1},
        },
        vAxes: {
        // Adds titles to each axis.
        0: {title: '$ per Cart'},
        1: {title: 'Number of Carts'}
        },
        hAxis: {
        title: 'MilkRun'
        }
        };

        var chart = new google.visualization.LineChart(document.getElementById('chart_MilkRunAverages2'));
        chart.draw(data, options);
        }

    function drawChartLogins() {
        var data = new google.visualization.DataTable();
        data.addColumn('date', 'Date');
        data.addColumn('number', 'Logins');

        data.addRows([
            <#list systemCharts.LoginRows as row>
                [ new Date(${row.year},${row.month},${row.day}), ${row.logins} ] <#if row?has_next >, </#if>
            </#list>
        ]);

        var options = {
            title: 'Logins Per Day (last 90 days)',
            'height':300,
            lineWidth: 0,
            pointSize: 3,
            hAxis: {
                title: 'Date'
            },
            vAxis: {
                title: 'Counts'
                }
        };

        var chart = new google.visualization.LineChart(document.getElementById('chart_Logins'));
        chart.draw(data, options);
    }
    function drawChartFailsFirsts() {
        var data = new google.visualization.DataTable();
        data.addColumn('date', 'Date');
        data.addColumn('number', 'Failed Login');
        data.addColumn('number', 'First Login');

        data.addRows([
            <#list systemCharts.FailFirstRows as row>
                [ new Date(${row.year},${row.month},${row.day}), ${row.fails}, ${row.firsts} ] <#if row?has_next >, </#if>
            </#list>
        ]);

        var options = {
            title: 'Failed Logins and First Logins Per Day (last 90 days)',
            'height':300,
            lineWidth: 0,
            pointSize: 3,
            hAxis: {
                title: 'Date'
            },
            vAxis: {
                title: 'Counts'
            }
        };

        var chart = new google.visualization.LineChart(document.getElementById('chart_FailsFirsts'));
        chart.draw(data, options);
        }

    function drawStripeChargesChart() {
        var data = new google.visualization.DataTable();
        data.addColumn('number', 'Week');
        data.addColumn('number', 'Charges' );

        data.addRows([
            <#list systemCharts.stripeChargesRows as row>
                [ ${row} ] <#if row?has_next >, </#if>
            </#list>
        ]);

        var options = {
            title: 'Stripe Charges',
            'height':400,
            hAxis: {
                title: 'Week',
                viewWindow: {
                min: 1,
                max: 53
            }
        },
        vAxis: {
            title: '$'
            }
        };

        var chart = new google.visualization.ColumnChart(document.getElementById('chart_StripeCharges'));
        chart.draw(data, options);
    }

    function drawWeeklyOrderingChart() {
        var data = new google.visualization.DataTable();
        data.addColumn('number', 'Hours');
        <#list systemCharts.weeklyOrderingMilkRuns as run >
            data.addColumn('number', '${run}' );
        </#list>

        data.addRows([
            <#list systemCharts.weeklyOrderingRows as row>
                [ <#list row as value >
                    ${value} <#if value?has_next >, </#if>
                  </#list>
                ] <#if row?has_next >, </#if>
            </#list>
        ]);

        var options = {
            title: 'CartOffers accumulating over the week',
            'height':400,
            bar: {groupWidth: "95%"},
            hAxis: {
                title: 'Days before MilkRun closed',
                viewWindow: {
                    min: -7,
                    max: 0
                },
                gridlines: {
                    count: 14
                }
            },
            vAxis: {
              title: 'CartOffer Count'
            }
        };

        var chart = new google.visualization.LineChart(document.getElementById('chart_WeeklyOrdering'));
         chart.draw(data, options);
    }


    function drawOrderingSinceJoinChart() {
        var data = new google.visualization.DataTable();
//        data.addColumn('number', 'Hours');
        <#list systemCharts.orderingSinceJoinColumns as user >
              data.addColumn('number', '${user}' );
        </#list>

        data.addRows([
            <#list systemCharts.orderingSinceJoin as row>
                [ <#list row as value >${value}<#if value?has_next >, </#if></#list> ]<#if row?has_next >, </#if>
            </#list>
        ]);

        var options = {
            title: 'Average number of items ordered vs MilkRuns since join',
            'height':400,
            hAxis: {
                title: 'MilkRuns since join'
            },
            vAxis: {
                title: 'Average Item Count'
            },
            lineWidth: 0,
            pointSize: 3
        };

        var chart = new google.visualization.LineChart(document.getElementById('chart_OrderingSinceJoin'));
        chart.draw(data, options);
    }


    </script>
</head>
<body class="">
    <@pageHeader3 />

    <div class="container-fluid">
        <p></p>
        <p></p>
        <h3>System Charts 2</h3>
        <p></p>
        <a href="/admin"><strong>Back to Admin</strong></a>
    </div>

    <div class="container-fluid">
        <row>
            <div class="col-sm-10" >
                <div id="chart_UserAccountsStacked"></div>
            </div>
        </row>
    </div>
    <div class="container-fluid">
        <row>
            <div class="col-sm-10" >
                <div id="chart_LatestSpendHistogram"></div>
            </div>
        </row>
    </div>
    <div class="container-fluid">
        <row>
            <div class="col-sm-12" >
                <div id="chart_MilkRunTotals"></div>
            </div>
        </row>
    </div>

    <div class="container-fluid">
        <row>
            <div class="col-sm-12">
                <div id="chart_MilkRunAverages"></div>
            </div>
        </row>
    </div>
    <div class="container-fluid">
        <row>
            <div class="col-sm-12">
                <div id="chart_MilkRunAverages2"></div>
            </div>
        </row>
    </div>
    <div class="container-fluid">
        <row>
            <div class="col-sm-12" >
                <div id="chart_orderingActivityHisto"></div>
            </div>
        </row>
    </div>
    <div class="container-fluid">
        <row>
            <div class="col-sm-10" >
                <div id="chart_WeeklyOrdering"></div>
            </div>
        </row>
    </div>
    <div class="container-fluid">
        <row>
            <div class="col-sm-10" >
                <div id="chart_StripeCharges"></div>
            </div>
        </row>
    </div>
    <div class="container-fluid">
        <row>
            <div class="col-sm-10" >
                <div id="chart_Logins"></div>
            </div>
        </row>
    </div>
    <div class="container-fluid">
        <row>
            <div class="col-sm-10" >
                <div id="chart_FailsFirsts"></div>
            </div>
        </row>
    </div>
    <div class="container-fluid">
        <row>
            <div class="col-sm-10" >
                <div id="chart_OrderingSinceJoin"></div>
            </div>
        </row>
    </div>
    <p></p>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
</body>
</html>