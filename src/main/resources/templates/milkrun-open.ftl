<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<#include "macros-milkrun.ftl">
<head>
    <#assign UI = milkrunOpenUI >
    <#assign milkRun = UI.milkRun >
    <#assign showButtons = session.user.doesRole("OpenPhaseAdmin") && ( ! MilkRunDB.haveClosing()) >

    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Open MilkRun</title>
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
    <header class="header">
        <@topOfPageHeader/>
    </header>

    <div class="container">
        <div class="row">
            <div class="col-md-3">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="/admin"><strong>Admin Home</strong></a>
                <br>
                <a href="/charge-milkrun?milkRunId=${milkRun.getId()}"><strong>View Charges</strong></a>
            </div>
            <div class="col-md-6">
                <h2>The Open MilkRun Cart Offer View</h2>
                <#if showButtons >
                    <input type="text"
                           id="milkRunName"
                           value="${milkRun.getName()}"
                           onchange="updateMilkRunName(this.value)"
                    />
                <#else >
                    ${milkRun.getName()}
                </#if>
                &nbsp;&nbsp;&nbsp;       ${String.format("%8.8s...", milkRun.getId())}
            </div>
            <div class="col-md-3">
                <a href="https://github.com/TheBlueFrog/milkrunDocs/blob/master/the-open-milkrun.md"  target="_blank">
                    <span class="docs pull-right">The Open MilkRun</span></a>
                <br>
            </div>
        </div>
    </div>
<p></p>
    <div class="container">
        <div class="row">
            <div class="col-sm-5">
                <p>&nbsp;</p>
                <div class="col-sm-12 well" >
                    <div class="col-sm-7">
                        <h4>Summary</h4>
                        <table width="95%">
                            <tr>
                                <td width="60%"> Total Buy </td>
                                <td width="40%" class="td-total"> ${String.format("$ %.2f", UI.getSupplierGrandTotal(true))}  </td>
                            </tr>
                            <tr>
                                <td width="60%"> Total Sell </td>
                                <td width="40%" class="td-total"> ${String.format("$ %.2f", UI.getConsumerGrandTotal(true))}  </td>
                            </tr>
                            <tr>
                                <td width="60%"> Stripe Total Buy </td>
                                <td width="40%" class="td-total"> ${String.format("$ %.2f", UI.getSupplierGrandTotal(false))}  </td>
                            </tr>
                            <tr>
                                <td width="60%"> Stripe Total Sell </td>
                                <td width="40%" class="td-total"> ${String.format("$ %.2f", UI.getConsumerGrandTotal(false))}  </td>
                            </tr>
                        </table>
                    </div>
                    <div class="col-sm-5">
                        <h4>&nbsp;</h4>
                        <table width="95%">
                            <tr>
                                <td width="80%">CartOffer Count</td>
                                <td width="20%" class="td-total"> ${UI.getCartOfferCount()} </td>
                            </tr>
                            <tr>
                                <td width="80%">Supplier Count</td>
                                <td width="20%" class="td-total"> ${UI.getSupplierCount()} </td>
                            </tr>
                            <tr>
                                <td width="80%">Eater Count</td>
                                <td width="20%" class="td-total"> ${UI.getConsumerCount()} </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div class="col-sm-7">
                <div id="chart_WeeklyOrdering"></div>
            </div>
        </div>
        <p></p>
        <div class="row">
            <div class="col-sm-8" >
                <div class="row">
                    <div class="col-sm-3">
                        Planned closing date
                    </div>
                    <div class="col-sm-4">
                        <input type="date"
                               id="estClosingDate"
                               value="${Util.formatTimestamp(milkRun.getMilkRunDB().getEstClosingTimestamp(), "YYYY-MM-dd")}"
                        />
                    </div>
                    <div class="col-sm-3">
                        <#if  showButtons >
                                <button onclick="updateEstClosing()">Update</button>
                        </#if>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-3">
                        Planned delivery date
                    </div>
                    <div class="col-sm-4">
                        <input type="date"
                               id="estDeliveringDate"
                               value="${Util.formatTimestamp(milkRun.getMilkRunDB().getEstDeliveringTimestamp(), "yyyy-MM-dd")}"
                        />
                    </div>
                    <div class="col-sm-3">
                        <#if  showButtons >
                            <button onclick="updateEstDelivering()">Update</button>
                        </#if>
                    </div>
                </div>
                <div class="row">
                    <p></p>
                    <div class="col-sm-1"></div>
                    <div class="col-sm-6">
                        <#if  showButtons >
                            <button onclick="closeMilkRun()" style="background-color:#BBBBFF">&nbsp;&nbsp;Mark the MilkRun Closing&nbsp;&nbsp;</button>
                        </#if>
                    </div>
                </div>
            </div>
            <p>&nbsp;</p>
        </div>
        <p>&nbsp;</p>
        <div class="row">
            <div class="col-md-2">
                <a href="/extra-stops/edit?milkRunId=${milkRun.getId()}">
                    <strong>Extra Stops (${milkRun.getExtraStopCount()})</strong></a>
            </div>
            <div class="col-md-8">
                <@showNotes milkRun, true />
            </div>
        </div>
        <div class="row">
            <div class="col-sm-12">
                <p>&nbsp;</p>
                ${UI.getSupplierTable()}
                <p></p>
                <p></p>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-12">
                <p>&nbsp;</p>
                ${UI.getConsumerTable()}
                <p></p>
                <p></p>
            </div>
        </div>
    </div>

    <@jsIncludes/>
    <script>
    function verifyFunction(txt) {
        if (confirm(txt) == true) {
            return true;
        } else {
            return false;
        }
    }
    function closeMilkRun() {
        var estClosingDate = document.getElementById('estClosingDate').value;
        var estDeliveringDate = document.getElementById('estDeliveringDate').value;
        var s = "Are you sure?\n" +
                "Estimated Closing date is " + estClosingDate +
                ".\nEstimated Delivering date is " + estDeliveringDate +
                ".\nMarking the MilkRun Closing is not undo-able.";

        if (verifyFunction(s)) {
            location.assign("/milkrun-set-closing?milkRunId=${milkRun.getId()}");
        }
    }

    //    var url = "/milkrun-api2/set-closing-date?milkRunId=xxx&date=YYYY/MM/DD
    function updateEstClosing() {
        var estClosingDate = document.getElementById('estClosingDate').value;
        var url = '/milkrun-api2/set-closing-date?milkRunId=${milkRun.getId()}'
                + '&date=' + encodeURI(estClosingDate);

        $.get(url, function(data, status) {
            if (data === 'OK') {
                location.assign("/milkruns2/show-open")
            }
            else {
                alert(data);
            }
        });
    }
    //    var url = "/milkrun-api2/set-delivering-date?milkRunId=xxx&date=YYYY/MM/DD
    function updateEstDelivering() {
        var estDeliveringDate = document.getElementById('estDeliveringDate').value;
        var url = '/milkrun-api2/set-delivering-date?milkRunId=${milkRun.getId()}'
                + '&date=' + encodeURI(estDeliveringDate);

        $.get(url, function(data, status) {
            if (data === 'OK') {
                location.assign("/milkruns2/show-open")
            }
            else {
                alert(data);
            }
        });
    }

    function updateMilkRunName(name) {
        // make sure it looks about right
        var number = new RegExp("[0-9]");
        var letter = new RegExp("[a-z]");
        var dash = new RegExp("[-]");
        var res = number.test(name.slice(0, 1));
        if (number.test(name.slice(0, 2)) &&
                number.test(name.slice(3, 5)) &&
                letter.test(name.slice(6,7)) &&
                dash.test(name.slice(2,3)) &&
                dash.test(name.slice(5,6)) &&
                (name.length == 7)) {

            var url = '/milkrun-api2/set-name?milkRunId=${milkRun.getId()}'
                    + '&name=' + name;
            $.get(url, function(data, status) {
                location.reload("/milkruns2/show-open")
            });
        }
        else {
            alert("Bad name");
        }
    }
    </script>

    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

    <script type="text/javascript">
        google.charts.load('current', {'packages':['corechart', 'bar', 'line' ]});
        google.charts.setOnLoadCallback(drawWeeklyOrderingChart);


        function drawWeeklyOrderingChart() {
            var data = new google.visualization.DataTable();
            data.addColumn('number', 'Hours');
            <#list charts.weeklyOrderingMilkRuns as run >
                data.addColumn('number', '${run}' );
            </#list>

            data.addRows([
            <#list charts.weeklyOrderingRows as row>
                [ <#list row as value >
                    ${value} <#if value?has_next >, </#if>
                </#list>
                ] <#if row?has_next >, </#if>
            </#list>
            ]);

            var options = {
                title: 'CartOffers accumulating over the week',
                'height':300,
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

    </script>

</body>
</html>


