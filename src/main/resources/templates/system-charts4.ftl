<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <title>Users</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <@styleSheets/>
</head>
<body>

<div class="container">
    <@pageHeader3 />
    <p></p>
    <h4>System Charts 5</h4>
    <p></p>
    <a href="/admin"><strong>Back to Admin</strong></a>
    <p></p>
        <div class="row">
            <div class="col-sm-6" >
                These charts are heatmaps of each item's sales over the year to-date.
                <br>
                The horizontal axis is week-of-the-year.  The vertical axis is the different
                items sold on the site.  Items are sorted by Category, ShortOne and the Item UUID
                is appended to avoid identical names.
                <br>
                Brighter colors indicate higher volume of sales.
                <br>
                This is a WIP, I know it's pretty hard to read.  And I can't figure out the
                mono-spaced font setting.
            </div>
            <div class="col-sm-6" >
                <button onclick="recompute()">Recompute</button>
            </div>
        </div>

        No idea why, you have to click a tab to get it to appear

    <ul class="nav nav-tabs">
        <li class="active"><a href="#category-time">Category-Time</a></li>
        <li><a href="#item-time">Item-Time</a></li>
    </ul>

    <div class="tab-content">
        <div id="category-time" class="tab-pane fade active">
        <#list Website.listFiles("static/generated-data/charts/output", ".*category-time.*[.]png")?chunk(2) as pngs >
            <div class="row">
                <#list pngs as png >
                    <div class="col-sm-6" >
                    ${png}
                        <br>
                        <img width="600px" src="/generated-data/charts/output/${png}">
                    </div>
                </#list>
            </div>
        </#list>
        </div>
        <div id="item-time" class="tab-pane fade">
            <#list Website.listFiles("static/generated-data/charts/output", ".*item-time.*[.]png")?chunk(2) as pngs2 >
                <div class="row">
                    <#list pngs2 as png2 >
                        <div class="col-sm-6" >
                        ${png2}
                            <br>
                            <img width="600px" src="/generated-data/charts/output/${png2}">
                        </div>
                    </#list>
                </div>
            </#list>
        </div>
    </div>
</div>

<script>
$(document).ready(function(){
    $(".nav-tabs a").click(function(){
        $(this).tab('show');
    });
});

function recompute(s) {
    var url = "/system-charts4/recompute";
    $.get(url, function(data, status){

    });
}

</script>

</body>
</html>
