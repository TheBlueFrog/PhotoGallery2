<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Old Split MilkRun</title>
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

    </style>
    <style type="text/css">
        @media all {
            .page-break	{ display: none; }
        }

        @media print {
            .page-break	{ display: block; page-break-before: always; }
        }

    </style>
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
                <a href="/milkruns-history"><strong>Back to MilkRuns</strong></a>
            </div>
            <div class="col-md-9">
                <h3 >Old Split MilkRun, this captures the state of the Run when it was split
                    <br>
                    <small>${milkrunSplitUI.milkRun.id}</small>
                    <br>
                    ${milkrunSplitUI.milkRun.name}
                </h3>
            </div>
        </div>
    </div>
<p></p>
    <div class="container">
        <div class="row">
            <div class="col-sm-3">
                <h4>Summary</h4>
                Pick Total ${milkrunSplitUI.getSupplierGrandTotalAsString()}
                <br>
                Drop Total ${milkrunSplitUI.getConsumerGrandTotalAsString()}
            </div>
            <div class="col-sm-3">
                <h4>&nbsp;</h4>
                CartOffer Count: ${milkrunSplitUI.getCartOfferCount()}
            </div>
            <div class="col-sm-1"></div>
        </div>
        <p></p>
        <div class="row">
            <div class="col-sm-6">
                <strong>Notes</strong>
                <table style="width:90%">
                    <#list UserNote.findAllByMilkRunId(milkrunSplitUI.milkRun.id, "NotClosed") as note>
                        <tr>
                            <td>
                                <#if note.getUser()?? >
                                    ${note.getUser().name}
                                </#if>
                            </td>
                            <td>
                                <#if note.getBody()?? >
                                    <a href="/note/edit?id=${note.id}">
                                        ${note.getBody()}
                                    </a>
                                </#if>
                            </td>
                        </tr>
                    </#list>
                </table>
            </div>
        </div>
        <p></p>
        <div class="col-sm-12">
            <h4>Pick List</h4>
            <p></p>
            ${milkrunSplitUI.getPickList()}
            <p></p>
            <p></p>
        </div>
        <div class="col-sm-12">
            <h4>Drop List</h4>
            <p></p>
            ${milkrunSplitUI.getDropList()}
            <p></p>
            <p></p>
        </div>
    </div>

    <@jsIncludes/>
    <script>
    function verifyFunction() {
        if (confirm("Are you sure?  Closing the MilkRun is not undo-able.") == true) {
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
    </script>


</body>
</html>