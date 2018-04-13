<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<#include "macros-milkrun.ftl">

<head>
    <#assign UI = milkrunClosingUI >
    <#assign milkRun = UI.milkRun >

    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Closing MilkRun ${milkRun.getShortId()} ${milkRun.getName()} </title>
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

    <p>
    </p>
    <p></p>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-3">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="/admin"><strong>Admin Home</strong></a>
                <br>
                <a href="/charge-milkrun?milkRunId=${milkRun.id}"><strong>Charge MilkRun View</strong></a>
            </div>
            <div class="col-md-5">
                <h3 >Closing MilkRun Supplier View
                    <br>
                    <span id="theUUID" style="background-color: ${UI.milkRun.getColor()}" >
                        &nbsp; ${milkRun.name} &nbsp; (${String.format("%8.8s...", milkRun.id)})&nbsp;
                    </span>
                </h3>
            </div>
            <div class="col-md-3">
                <a href="https://github.com/TheBlueFrog/milkrunDocs/blob/master/the-closed-milkrun.md"  target="_blank">
                    <span class="docs pull-right">The Closing MilkRun</span></a>
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
        <#if session.user.doesRole("OpenPhaseAdmin") >
            <div class="row">
                <div class="col-sm-4">
                    <p></p>
                </div>
                <div class="col-sm-2"></div>
                <div class="col-sm-4">
                    <p></p>
                </div>
            </div>
        </#if>
        <div class="row">
            <div class="col-sm-4 well">
                <div class="col-sm-6">
                    <small>Summary</small><br>
                    Pick Total ${UI.getSupplierGrandTotalAsString()}
                    <br>
                    CartOffer Count: ${UI.getCartOfferCount()}
                </div>
                <div class="col-sm-6">
                    <small>&nbsp;</small><br>
                </div>
            </div>
            <div class="col-sm-1"></div>
            <div class="col-sm-3 well">
            </div>
        </div>
        <div class="row">
            <div class="col-sm-12 well">
                <@showNotes milkRun, true />
            </div>
        </div>
        <div class="col-sm-12">
            <div class="col-sm-3">
                <p></p>
                <input type="checkbox" id="showPickDetails" value="showPickDetails" onchange="showPickDetailsChanged()"
                    <#if session.getAttributeB("showPickDetails") >
                        checked
                    </#if>
                >
                Show Pick List Details
                </input>
            </div>
            <div class="col-sm-3">
                <p></p>
            </div>
            <div class="col-sm-3">
            </div>
        </div>
        <div class="col-sm-12" id="pickDiv">
            <@showPickList UI.getPickList() />
            <p>&nbsp;</p>
        </div>
    </div>

    <@jsIncludes/>
    <script>
    function showPickDetailsChanged() {
        var x = document.getElementById('showPickDetails').checked;
        location.assign("/milkrun/set/show-pick-details/" + x + "/${milkRun.id}");
    }
    </script>


</body>
</html>