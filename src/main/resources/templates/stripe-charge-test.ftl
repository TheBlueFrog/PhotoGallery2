<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Charge MilkRun</title>
    <@styleSheets/>
    <style>
        th { text-align: left; }
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
        .docs {
            color: #88DD88;
                text-align: right;
                font-weight: bold;
        }
    </style>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>

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
            </div>
            <div class="col-md-6">
                <h2>Stripe Charge Test</h2>
            </div>
            <div class="col-md-3">
            </div>
        </div>
    </div>

    <@pageFooter/>
    <@jsIncludes/>

</body>
</html>