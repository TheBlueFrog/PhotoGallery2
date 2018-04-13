<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<#include "macros-milkrun.ftl">

<head>
    <#assign UI = milkrunDeliveredUI >
    <#assign milkRun = UI.milkRun >

    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Delivered ${milkRun.name} </title>
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
    .mine2 {
        text-align: center;
        color: #FFFFFF;
        background-color: #AAAADD
    }

    .mine3 {
        padding: 0pt;
        margin: 0pt;
        font-size: 14px;
        text-align: center;
        color: #7070FF;
        border: 0pt;
    }
    .mine4 {
        padding: 0pt;
        margin: 0pt;
        font-size: 14px;
        text-align: center;
        color: #60BB60;
        border: 0pt;
    }

</style>
    <style type="text/css">
    @media all {
        .page-break	{ display: none; }
    }

    @media print {
          a[href]:after {
            content: none !important;
          }
        .page-break	{ display: block; page-break-before: always; }
    }

</style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>

    <script>
        $(document).ready(function(){
            $("button").click(function(){
                var i = this.id;        // e.g. 2-arrive
                var iv = "#" + i;
                $(iv).prop("disabled",true);

                var x = i.split("-");
                if (x[1] == "Arrive") {
                    $(iv).text("Arrived");
                    $(iv).css('color', '#505050');
                } else {
                    $(iv).text("Departed");
                    $(iv).css('color', '#505050');
                }

                var url = "/milkrun-api2/deliver/" + x[0] + "/" + x[1];
                $.get(url, function(data, status){
                    if(status == "success") {
                        // can't figure out how to remove the button now...
                    }
                    if (status == "error") {
                        var y = 0;
                    }
                });

            });
        });

function showDropChanged() {
    var y = "#dropDiv";
    var x = document.getElementById('showDropList').checked;
    if (x) {
        $(y).show();
    }
    else {
        $(y).hide();
    }
}
function showPickChanged() {
    var x = document.getElementById('showPickList').checked;
    var y = "#pickDiv";
    if (x) {
        $(y).show();
    }
    else {
        $(y).hide();
    }
}
function showRouteChanged() {
    var x = document.getElementById('showRoute').checked;
    var y = "#routeDiv";
    if (x) {
        $(y).show();
    }
    else {
        $(y).hide();
    }
}
    </script>

</head>
<body class="">
    <p></p>
    <p></p>
    <div class="container">
        <div class="row">
            <div class="col-md-3">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="/admin"><strong>Admin Home</strong></a>
                <br>
                <a href="/milkruns-history"><strong>Back to MilkRun History</strong></a>
                <br>
                <a href="/milkruns-closed"><strong>Back to Closed MilkRuns</strong></a>
            </div>
            <div class="col-md-5">
                <h3 >Delivered MilkRun
                    <br>
                    <span style="background-color:${milkRun.getColor()}">
                        &nbsp; ${milkRun.name} &nbsp; (${String.format("%8.8s...", milkRun.id)}) &nbsp;
                    </span>
                </h3>
            </div>
        </div>
    </div>
    <div class="container">
        <div class="row">
            <div class="col-sm-3 well">
                <small>Summary</small>
                <br>
                Pick Total ${UI.getSupplierGrandTotalAsString()}
                <br>
                Drop Total ${UI.getConsumerGrandTotalAsString()}
                <br>
            </div>
            <div class="col-sm-3 well">
                <small>&nbsp;</small>
                <br>
                CartOffer Count: ${UI.getCartOfferCount()}
                <br>
                Supplier Count: ${UI.getSupplierCount()}
                <br>
                Consumer Count: ${UI.getConsumerCount()}
            </div>
            <div class="col-sm-3 well">
                <small>&nbsp;</small>
                <br>
                Time ${milkRun.getRouteData().getMetrics().getCostTimeString()}
                <br>
                Length ${milkRun.getRouteData().getMetrics().getKmString()}
            </div>
        </div>

        <@showRouteErrors milkRun />

        <div class="row">
            <div class="col-sm-3">
                <h4>&nbsp;</h4>
                <input type="checkbox" id="showRoute" value="showRoute"  onchange="showRouteChanged()" checked >
                Show Route Summary
                </input>
            </div>
            <div class="col-sm-1"></div>
        </div>
        <div class="row ">
            <div class="col-sm-2">
                <p></p>
                <a href="/milkrun-map?mapLines=true"><strong>Pick/Drop Map</strong></a>
                <br>
                <#--<a href="/charge-milkrun?milkRunId=${milkRun.getId()}"><strong>Stripe Charges</strong></a>-->
            </div>
            <div class="col-sm-6">
                <@showNotes milkRun, false />
            </div>
            <div class="col-sm-4">
            </div>
        </div>
        <div class="col-sm-12" id="routeDiv">
            <@showRoute milkRun />
        </div>
        <div class="col-sm-12" id="stopDiv">
            <@showPickList UI.getStopList() />
        </div>
    </div>

    <@jsIncludes/>
    <script>
    </script>


    </body>
</html>