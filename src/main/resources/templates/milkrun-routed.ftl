<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<#include "macros-milkrun.ftl">

<head>
    <#assign UI = milkrunRoutedUI >
    <#assign milkRun = UI.milkRun >

    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Closed MilkRun ${milkRun.getShortId()} ${milkRun.getName()} </title>
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
        .tr-underline {
            border-bottom: 1pt solid gray;
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

        img {
            position: absolute;
            left: 0px;
            top: 0px;
            z-index: -5;
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
        .docs {
            color: #88DD88;
            text-align: right;
            font-weight: bold;
        }

    </style>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>

    <script>
    </script>

</head>
<body class="">

    <p>
    </p>
    <p></p>
    <div class="container">
        <div class="row">
            <div class="col-md-3">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="/admin"><strong>Admin Home</strong></a>
            </div>
            <div class="col-md-5">
                <h3 >
                    ${milkRun.getState().toString()} MilkRun
                    <br>
                    <span id="theUUID" style="background-color: ${milkRun.getColor()}" >
                        &nbsp; ${milkRun.name} &nbsp; (${String.format("%8.8s...", milkRun.id)})&nbsp;
                    </span>
                </h3>
            </div>
            <div class="col-md-3">
            </div>
            <div class="col-md-2">
            </div>
        </div>
    </div>
    <p></p>
    <div class="container">
        <div class="row">
            <div class="col-sm-4 well">
                <#if session.user.doesRole("ClosedPhaseAdmin") >
                    <br>
                    <a href="/milkrun-delivering" onclick="return verifyFunction();">
                        <p class="mine">Mark MilkRun Delivering</p></a>
                    <br>
                </#if>
            </div>
            <div class="col-sm-4 well">
                <div class="col-sm-6">
                    <small>Summary</small>
                    <br>
                    Pick Total ${UI.getSupplierGrandTotalAsString()}
                    <br>
                    Drop Total ${UI.getConsumerGrandTotalAsString()}
                    <br>
                </div>
                <div class="col-sm-6">
                    <small>&nbsp;</small>
                    <br>
                    CartOffer Count: ${UI.getCartOfferCount()}
                    <br>
                    Supplier Count: ${UI.getSupplierCount()}
                    <br>
                    Consumer Count: ${UI.getConsumerCount()}
                </div>
            </div>
            <div class="col-sm-3 well">
                <small>Routing</small><br>
                <a href="/milkrun-map?mapLines=true"><strong>Route Map</strong></a>
                <br>
                <strong>Extra Stops (${milkRun.getExtraStopCount()})</strong>
                <br>
                <br>
            </div>
        </div>

        <@showRouteErrors milkRun />

        <div class="col-sm-12">
            <div class="col-sm-3">
                <p></p>
                MilkRun start ${milkRun.getStart().getName()}
                <#--
                <select id="startSelect" onchange="startChanged()">
                    <#list system.getUsersByRoles("ClosedPhaseAdmin") as admin >
                        <option value="${admin.username}"
                        <#if admin.username == milkRun.start.username >
                            selected
                        </#if>
                        >${admin.getName()}</option>
                    </#list>
                </select>
                -->
            </div>
            <div class="col-sm-3">
                <p></p>
                MilkRun end ${milkRun.getEnd().getName()}
                <!--
                <select id="endSelect" onchange="endChanged()">
                    <#list system.getUsersByRoles("ClosedPhaseAdmin") as admin >
                        <option value="${admin.username}"
                        <#if admin.username == milkRun.end.username >
                            selected
                        </#if>
                        >${admin.getName()}</option>
                    </#list>
                </select>
                -->
            </div>
            <div class="col-sm-3">
                <input type="checkbox" id="showPickDetails" value="showPickDetails" onchange="showPickDetailsChanged()"
                    <#if session.getAttributeB("showPickDetails") >
                        checked
                    </#if>
                >
                    Show Pick List Details
                </input>
                <br>
                <input type="checkbox" id="showRoute" value="showRoute"  onchange="showRouteChanged()" checked >
                   Show Route Summary
                </input>
                <br>
                <input type="checkbox" id="showStopList" value="showStopList" onchange="showStopChanged()" checked >
                    Show Stop list
                </input>
            </div>
        </div>

        <div class="row">
            <div class="col-sm-12 well">
                <@showNotes milkRun, true />
            </div>
        </div>

        <div class="col-sm-12" id="routeDiv">
            <p></p>
            <@showRoute milkRun />
        </div>

        <div class="col-sm-12" id="stopDiv">
            <@showPickList UI.getStopList() />
        </div>
    </div>

    <@jsIncludes/>
    <script>
    function verifyFunction() {
        if (confirm("Are you sure?  Changing the state of the MilkRun is not undo-able.") == true) {
            return true;
        } else {
            return false;
        }
    }
    function startChanged() {
        var x = document.getElementById('startSelect').value;

        location.assign("/milkrun/set/start/" + x);
    }
    function endChanged() {
        var x = document.getElementById('endSelect').value;

        location.assign("/milkrun/set/end/" + x);
    }
    function showStopChanged() {
        var x = document.getElementById('showStopList').checked;
        var y = "#stopDiv";
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
    function showPickDetailsChanged() {
        var x = document.getElementById('showPickDetails').checked;
        location.assign("/milkrun/set/show-pick-details/" + x + "/${milkRun.id}");
    }
    function colorChanged() {
        var color = document.getElementById('colorSelect').value;

        var x = document.getElementById('theUUID');
        $(x).css('background-color', color);

        var y = document.getElementById('colorSelect');
        $(y).css('background-color', color);

        var index = color.indexOf('#');
        if (index > -1) {
            color = color.substring(index+1, color.length);
        }
        var url = "/session-api/milkrun/set?color=" + color + "&milkRunId=${milkRun.id}";
        $.get(url, function(data, status) {
        });
    }

    </script>


</body>
</html>