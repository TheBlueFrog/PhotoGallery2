<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>System Charts for Pitch Deck</title>
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
    <#--
    google.charts.setOnLoadCallback(drawUserAccountsEaters);
    google.charts.setOnLoadCallback(drawUserAccountsFeeders);
    google.charts.setOnLoadCallback(drawUserAccountsSeeders);
    google.charts.setOnLoadCallback(drawMilkRunTotalsChart);
    google.charts.setOnLoadCallback(drawMilkRunOrdersChart);
    google.charts.setOnLoadCallback(drawMilkRunOrders2Chart);
    google.charts.setOnLoadCallback(drawWeeklyOrderingChart);
    google.charts.setOnLoadCallback(orderingActivityHisto);
    google.charts.setOnLoadCallback(drawOrderingSinceJoinChart);
    -->
    google.charts.setOnLoadCallback(drawCLVChart);
    google.charts.setOnLoadCallback(drawWAUChart);
    google.charts.setOnLoadCallback(drawRPRChart);
    google.charts.setOnLoadCallback(drawLiquidityChart);

    <#--
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

    function drawUserAccountsEaters() {

        var data = new google.visualization.DataTable();
        data.addColumn('date', 'Date');
        data.addColumn('number', 'Eaters');

        data.addRows([
      <#list systemCharts.userRows as row >
        [ new Date(${row.year},${row.month},${row.day}), ${row.eater} ]
        <#if row?has_next >,
        </#if>
      </#list>
      ]);

      var options = {
        title: 'Accounts - Eaters',
        isStacked: true,
         bar: {groupWidth: "60%"},
        hAxis: {
          title: 'Week of Year'
        },
        vAxis: {
          title: ''
        }
      };

        var chart = new google.visualization.ColumnChart(document.getElementById('chart_UserAccountsEaters'));
        chart.draw(data, options);
    }

    function drawUserAccountsSeeders() {

        var data = new google.visualization.DataTable();
        data.addColumn('date', 'Date');
        data.addColumn('number', 'Seeders');

        data.addRows([
      <#list systemCharts.userRows as row >
        [ new Date(${row.year},${row.month},${row.day}), ${row.seeder} ]
        <#if row?has_next >,
        </#if>
      </#list>
      ]);

      var options = {
        title: 'Accounts - Seeders',
        isStacked: true,
         bar: {groupWidth: "60%"},
        hAxis: {
          title: 'Week of Year'
        },
        vAxis: {
          title: ''
        }
      };

        var chart = new google.visualization.ColumnChart(document.getElementById('chart_UserAccountsSeeders'));
        chart.draw(data, options);
    }

    function drawUserAccountsFeeders() {

        var data = new google.visualization.DataTable();
        data.addColumn('date', 'Date');
        data.addColumn('number', 'Feeders');

        data.addRows([
      <#list systemCharts.userRows as row >
        [ new Date(${row.year},${row.month},${row.day}), ${row.feeder} ]
        <#if row?has_next >,
        </#if>
      </#list>
      ]);

      var options = {
        title: 'Accounts - Feeders',
        isStacked: true,
         bar: {groupWidth: "60%"},
        hAxis: {
          title: 'Week of Year'
        },
        vAxis: {
          title: ''
        }
      };

        var chart = new google.visualization.ColumnChart(document.getElementById('chart_UserAccountsFeeders'));
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
    -->

    function drawCLVChart() {
        var data = google.visualization.arrayToDataTable([
            <#assign withGMV = false >
            <#if withGMV >
                ['MilkRun', 'GMV', 'AOV', 'CLV'],
            <#else>
                ['MilkRun', 'AOV', 'CLV'],
            </#if>

            <#list data.clvRows as row>
                <#if withGMV >
                    ['${row.name}', ${row.GMV}, ${row.AOV}, ${row.CLV} ]
                <#else>
                    ['${row.name}', ${row.AOV}, ${row.CLV} ]
                </#if>
                <#if row?has_next >, </#if>
            </#list>
        ]);

        var options = {
            title: 'Average Order Value (AOV) & Customer Lifetime Value (CLV)',
            'height':400,

            // different scales on left/right
            series: {
                0: {targetAxisIndex: 0},
                1: {targetAxisIndex: 1},
            },
            vAxes: {
                // Adds titles to each axis.
                0: {title: 'AOV in $'},
                1: {title: 'CLV in $'}
            },
            hAxis: {
                <#assign x = String.format("$%.0f", data.clvAvgCLV) >
                <#assign y = String.format("$%.0f", data.clvAvgAOV) >
                title: 'MilkRun - Avg AOV ${y}, Avg CLV ${x} (gross)'
            },
            // vAxis: {
            //     title: '$'
            // },
            lineWidth: 1,
            pointSize: 4

//            trendlines: { 0: {}, 1: {} } can't do with discrete horizontal axis, has to be continuous
        };

        var chart = new google.visualization.LineChart(document.getElementById('chart_CLV'));
        chart.draw(data, options);
    }

    function drawWAUChart() {
        var data = new google.visualization.arrayToDataTable(
            [
                [ 'MilkRun', 'Existing Users', 'New Users' ],
                <#list data.wauRows as row >
                    [ '${row.name}', ${row.existingUsers}, ${row.newUsers} ]
                    <#if row?has_next > , </#if>
                </#list>
            ]
        );


        var options = {
            title: 'Weekly Active Users (WAU)',
            isStacked: true,
            bar: {groupWidth: "60%"},
            'height':400,

            hAxis: {
                title: 'MilkRun'
//            viewWindow: {
//                min: 0,
//                max: 52
//              }
            },
            vAxis: {
                title: 'Consumer Count'
            }
        };

        var chart = new google.visualization.ColumnChart(document.getElementById('chart_WAU'));
        chart.draw(data, options);
    }

    function drawRPRChart() {
        var data = new google.visualization.arrayToDataTable(
                [
                    [ 'MilkRun', 'Existing User Revenue', 'New User Revenue', 'Existing User Revenue %' ],
                <#list data.rprRows as row >
                    [ '${row.name}', ${row.existingUsers}, ${row.newUsers}, ${row.existingUserPercent} ]
                    <#if row?has_next > , </#if>
                </#list>
                ]
        );


        var options = {
            title: 'Repeat Purchase Ratio',
            isStacked: true,
            bar: {groupWidth: "60%"},
            'height':400,
            // different scales on left/right
            series: {
                0: {targetAxisIndex: 0},
                1: {targetAxisIndex: 0},
                2: {targetAxisIndex: 1, type: 'line'}
            },
            vAxes: {
                // Adds titles to each axis.
                0: {title: 'Revenue $'},
                1: {title: 'Avg Existing User Revenue %'}
            },
            hAxis: {
                <#assign x = String.format("$%.0f", data.rprAvgExistingUserRevenue) >
                title: 'MilkRun'
//            viewWindow: {
//                min: 0,
//                max: 52
//              }
            }
            // vAxis: {
            //     title: '$'
            // }
        };

        var chart = new google.visualization.ColumnChart(document.getElementById('chart_RPR'));
        chart.draw(data, options);
    }


    function drawLiquidityChart() {
        var data = google.visualization.arrayToDataTable([
            ['MilkRun', 'Liquidity'],

            <#list data.liquidityRows as row>
                ['${row.name}', ${row.liquidity} ]
                <#if row?has_next >, </#if>
            </#list>
        ]);

        var options = {
            title: 'Liquidity)',
            'height':400,

            hAxis: {
                title: 'MilkRun - Liquidity'
            },
            // vAxis: {
            //     title: '$'
            // },
            lineWidth: 1,
            pointSize: 4
        };

        var chart = new google.visualization.LineChart(document.getElementById('chart_Liquidity'));
        chart.draw(data, options);
    }


    </script>
</head>
<body class="">
    <@pageHeader3 />

    <div class="container-fluid">
        <p></p>
        <p></p>
        <h3>System Charts for Pitch Deck</h3>
        <p></p>
        <a href="/admin"><strong>Back to Admin</strong></a>
    </div>
    <#--
    <div class="container-fluid">
        <row>
            <div class="col-sm-10" >
                <div id="chart_UserAccountsEaters"></div>
            </div>
        </row>
    </div>
    <div class="container-fluid">
        <row>
            <div class="col-sm-10" >
                <div id="chart_UserAccountsFeeders"></div>
            </div>
        </row>
    </div>
    <div class="container-fluid">
        <row>
            <div class="col-sm-10" >
                <div id="chart_UserAccountsSeeders"></div>
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
                <div id="chart_OrderingSinceJoin"></div>
            </div>
        </row>
    </div>
    -->
    <div class="container-fluid">
        <row>
            <div class="col-sm-10" >
                <div id="chart_CLV"></div>
            </div>
        </row>
    </div>
    <div class="container-fluid">
        <row>
            <div class="col-sm-10" >
                <div id="chart_WAU"></div>
            </div>
        </row>
    </div>
    <div class="container-fluid">
        <row>
            <div class="col-sm-10" >
                <div id="chart_RPR"></div>
            </div>
        </row>
    </div>
    <div class="container-fluid">
        <row>
            <div class="col-sm-10" >
                <div id="chart_Liquidity"></div>
            </div>
        </row>
    </div>
    <p></p>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
</body>
</html>