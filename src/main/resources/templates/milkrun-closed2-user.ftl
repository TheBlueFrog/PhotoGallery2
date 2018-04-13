<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Delivered MilkRun</title>
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
    </style>
    <style type="text/css">
       <!--
           @page { size : landscape }

           h4 { page-break-before }
       -->
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
                <a href="/my-pages2">Back to My Pages</a>
                <br>
            </div>
            <div class="col-md-6">
                <h2>Closed MilkRun of ${session.user.name}</h2>
            </div>
            <div class="col-md-3">
            </div>
        </div>
    </div>
<p></p>
    <div class="container">
        <div class="row">
            <div class="col-sm-12">
                <h4>Drop List</h4>
                <p></p>
                ${milkrunClosedUI.getConsumerTable()}
                <p></p>
                <p></p>
            </div>

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
    </script>

</body>
</html>