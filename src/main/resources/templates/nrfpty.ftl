<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Administration</title>
    <@styleSheets/>
    
    <style>

    textarea
    {
        font-family:"Times New Roman", Times, serif;
        font-size: 12px;
        text-align: left;
        margin-left:0px;
    }

    </style>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>

</head>
<body class="">
    <@pageHeader3 />

    <p></p>
    <div class="container">
        <div class="row">
            <div class="col-md-2">
                <a href="/"><h4>Home</h4></a>
                <a href="admin"><h4>Admin Home</h4></a>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6">
                <ul>
                    <li><a href="/my-orders">My Past Orders</a></li>
                    <li><a href="/my-pages2">My Pages2</a></li>
                    <li><a href="/stripe">Old Stripe</a></li>
                    <br>
                    <li><a href="/system-charts3"><strong>Charts 3</strong></a></li>
                    <br>
                    <li><a href="/runner-tracking"><strong>Runner Tracking</strong></a></li>
                    </li>
                    <#if session.user.getId() == "mike" >
                        <li><a href="/stripe-charge-test"><strong>Stripe Testing</strong></a></li>
                    </#if>
                </ul>
            </div>
        </div>
        <p></p>
        <div class="row">
            <div class="col-md-6 well" id="emailResults">
            </div>
        </div>
    </div>

    <button id="runnerTracking" onclick="runnerTracking()" class="btn btn-default">
        Runner tracking analysis (takes 10-15 seconds)
    </button>
    <script>
        function runnerTracking() {
            var url = "/admin-api/runner-tracking?doAnalysis=true";
            $.get(url, function(data, status){
                document.getElementById('emailResults').innerHTML = data;
            });
        }

    </script>
</body>
</html>


