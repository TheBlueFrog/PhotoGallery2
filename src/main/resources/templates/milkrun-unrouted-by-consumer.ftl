<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<#include "macros-milkrun.ftl">

<head>
    <#assign UI = milkrunUnroutedUI >
    <#assign milkRun = UI.milkRun >

    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Closed/Unrouted MilkRun ${milkRun.getShortId()} ${milkRun.getName()} </title>
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

    <p></p>
    <p></p>
    <div class="container">
        <div class="row">
            <div class="col-md-3">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="/admin"><strong>Admin Home</strong></a>
                <br>
                <a href="/milkrun/show/unrouted-by-supplier/${milkRun.id}"><strong>Supplier View</strong></a>
            </div>
            <div class="col-md-5">
                <h3 >
                    ${milkRun.getState().toString()} MilkRun Consumer View
                    <br>
                    <span id="theUUID" style="background-color: ${milkRun.getColor()}" >
                        &nbsp; ${milkRun.name} &nbsp; (${String.format("%8.8s...", milkRun.id)})&nbsp;
                    </span>
                </h3>
            </div>
            <div class="col-md-3">
                <a href="https://github.com/TheBlueFrog/milkrunDocs/blob/master/the-closed-milkrun.md"  target="_blank">
                    <span class="docs pull-right">Closed MilkRun</span></a>
                <p>&nbsp;</p>
                Set color
                <select id="colorSelect" onchange="colorChanged()" >
                    <#list MilkRunDB.colors as color >
                        <option value="${color}" style="background-color:${color}"
                        <#if color == milkRun.getMilkRunDB().getColor() >
                            selected
                        </#if>
                        >${MilkRunDB.getColorName(color)}</option>
                    </#list>
                </select>
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
                    Split this Milkrun into two MilkRuns
                    <br>
                    <a href="/milkrun-split-manual-by-eater3/start/${milkRun.id}">
                        <p class="mine2">Manually split this MilkRun</p></a>
                    <br>
                </#if>
            </div>
            <div class="col-sm-4 well">
                <div class="col-sm-6">
                    <small>Summary</small><br>
                    Pick Total ${UI.getSupplierGrandTotalAsString()}
                    <br>
                    Drop Total ${UI.getConsumerGrandTotalAsString()}
                </div>
                <div class="col-sm-6">
                    <br>
                    Supplier Count: ${UI.getSupplierCount()}
                    <br>
                    Consumer Count: ${UI.getConsumerCount()}
                    <br>
                    CartOffer Count: ${UI.getCartOfferCount()}
                </div>
            </div>
            <div class="col-sm-3 well">
                <small>Routing</small><br>
                <a href="/milkrun-map?mapLines=false"><strong>Route Map</strong></a>
                <br>
                <a href="/extra-stops/edit?milkRunId=${milkRun.id}">
                    <strong>Extra Stops (${milkRun.getExtraStopCount()})</strong></a>
                <br>
                <#if session.user.doesRole("RoutingAdmin") >
                    <#if  ! milkRun.getRouteData().prohibitRouting() >
                        <a href="/milkrun-routing?milkRunId=${milkRun.getId()}&dumpFrozen=true" >
                            <strong>Adjust Routing</strong>
                        </a>
                    <#else >
                        <span style="background-color: #ff7777">MilkRun has errors, not routeable </span>
                    </#if>
                </#if>
            </div>
        </div>
        <p></p>

        <@showRouteErrors milkRun />

        <div class="row">
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
                    <br>
                    <input type="checkbox" id="showNotes" value="showNotes"  onchange="showNotesChanged(this.checked)" checked >
                    Show Notes
                    </input>
                    <br>
                    <input type="checkbox" id="showDropList" value="showDropList"  onchange="showDropChanged()" checked >
                    Show Drop list
                    </input>
                    <br>
                    <input type="checkbox" id="showPickList" value="showPickList" onchange="showPickChanged()" checked >
                        Show Pick list
                    </input>
                    <br>
                    <input type="checkbox" id="showPickDetails" value="showPickDetails" onchange="showPickDetailsChanged()"
                        <#if session.getAttributeB("showPickDetails") >
                            checked
                        </#if>
                    >
                    Show Pick List Details
                    </input>
                </div>
            </div>
        </div>

        <div class="row" id="noteDiv">
            <div class="col-sm-12 well">
                <@showNotes milkRun, true />
            </div>
        </div>

        <div class="col-sm-12" id="pickDiv">
            <@showPickList UI.getPickList() />
        </div>
        <div class="col-sm-12" id="dropDiv">
            <@showDropList UI.getDropList() />
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
    function showNotesChanged(check) {
        if (check) {
            $('#noteDiv').show();
        } else {
            $('#noteDiv').hide();
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