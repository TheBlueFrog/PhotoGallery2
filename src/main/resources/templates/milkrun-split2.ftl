<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<#include "macros-milkrun.ftl">

    <#assign UI = milkrunSplitUI >

    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Split MilkRun ${milkRun.getShortId()} ${milkRun.getName()} </title>
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
    </script>

</head>
<body class="">
    <p></p>
    <p></p>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-3">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="/admin"><strong>Admin Home</strong></a>
                <br>
                <a href="/milkruns-closed"><strong>Back to Closed MilkRuns</strong></a>
            </div>
            <div class="col-md-5">
                <h3 >Roll-up of the children of this split MilkRun
                    <br>
                    <small style="background-color:${milkRun.getColor()}"
                           id="theUUID">
                        ${milkRun.id}</small>
                    <br>
                    ${milkRun.name}
                </h3>
            </div>
            <div class="col-md-4">
                <select id="colorSelect" onchange="colorChanged()">
                    <#list MilkRunDB.colors as color >
                        <option value="${color}" style="background-color:${color}"
                        <#if color == milkRun.getMilkRunDB().getColor() >
                            selected
                        </#if>
                        >testing</option>
                    </#list>
                </select>
            </div>
        </div>
    </div>
    <p></p>
    <div class="container">
        <div class="row">
            <div class="col-sm-4 well">
                <div class="col-sm-6">
                    <small>Summary</small>
                    <br>
                    Pick Total ${UI.getSupplierGrandTotalAsString()}
                    <br>
                    Drop Total ${UI.getConsumerGrandTotalAsString()}
                </div>
                <div class="col-sm-6">
                    <small>&nbsp;</small>
                    <br>
                    CartOffer Count: ${UI.getCartOfferCount()}
                    <br>
                    Supplier Count: ${UI.getSupplierCount()}
                    <br>
                    Eater Count: ${UI.getConsumerCount()}
                </div>
            </div>
            <div class="col-sm-3 well">
                <small>Controls</small>
                <br>
                <input type="checkbox" id="showPickDetails" value="showPickDetails" onchange="showPickDetailsChanged()"
                    <#if session.getAttributeB("showPickDetails") >
                        checked
                    </#if>
                    >
                    Show Pick List Details
                </input>
                <br>
                <input type="checkbox" id="showPickList" value="showPickList" onchange="showPickChanged()" checked >
                    Show Pick list
                </input>
                <br>
                <input type="checkbox" id="showDropList" value="showDropList"  onchange="showDropChanged()" checked >
                    Show Drop list
                </input>
            </div>
            <div class="col-sm-4 well">
                <small>Misc</small><br>
                <br>
                Extra Stops (${milkRun.getExtraStopCount()})
                <br>
                <#if milkRun.canBeUnsplit() >
                    <small>Unsplit - all child MilkRun CartOffers will be moved back to this MilkRun, the parent</small>
                    <br>
                    <a href="/milkrun-unsplit/${milkRun.getId()}"><strong>Unsplit this MilkRun</strong></a>
                    <br>
                <#else>
                    Cannot be unsplit
                </#if>
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
    function showPickDetailsChanged() {
        var x = document.getElementById('showPickDetails').checked;
        location.assign("/milkrun/set/show-pick-details/" + x + "/${milkRun.id}");
    }
    function colorChanged() {
        var x = document.getElementById('theUUID');
        var color = document.getElementById('colorSelect').value;
        $(x).css('background-color', color);

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