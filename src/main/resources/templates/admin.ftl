<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Administration</title>
    <@styleSheets/>
    
    <style>


    .textarea
    {
        font-family:"monospace";
        font-size: 8px;
        text-align: left;
        margin-left:0px;
        padding: 0px;

        position: absolute;
        left: 3px;
        right: 3px;
        top: 3px;
        bottom: 3px;

        box-sizing: border-box;
    }

    th { text-align: left; }
    td {
        text-align: left;
        vertical-align: text-top;
    }

    .mono {
        font-size: 12px;
        font-family:Consolas,Monaco,Lucida Console,Liberation Mono,DejaVu Sans Mono,Bitstream Vera Sans Mono,Courier New, monospace;
    }

    .cart-button {
            color: inherit;
            font-size: 11px;
            padding: 2px 12px;
            display: inline-block;
            margin 0;
            margin-top: 15px;
            border-top: 1px solid #e9e9e9;
            border-bottom: 1px solid #e9e9e9;
        }

    </style>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script>
        $(document).ready(function(){
            $("#systemShutdown").click(function(){
            });
        });
    </script>

</head>
<body class="">
    <@pageHeader3 />

    <#assign user = session.getUser() >

    <p></p>
    <div class="container">
        <div class="row">
            <div class="col-md-2">
                <a href="/"><strong>Home</strong></a>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <ul class="nav nav-pills nav-stacked">
                    <div class="well">
                        <small>User Management</small>
                        <#if UserRole.does(user.getId(), "Admin") >
                            <li><a href="/pending-accounts"><strong>Pending Accounts</strong></a></li>
                        <#else >
                            <li>&nbsp;</li>
                        </#if>
                        <li><a href="/users2"><strong>User Accounts</strong></a></li>
                        <li><a href="/per-user-string-editor"><strong>User String Editor</strong></a></li>
                        <li><a href="/user-map"><strong>User Map</strong></a></li>
                    </div>
                </ul>
            </div>
            <div class="col-md-2">
                <ul class="nav nav-pills nav-stacked">
                    <div class="well">
                        <small></small>
                        <li>&nbsp;</li>
                        <li>&nbsp;</li>
                        <li>&nbsp;</li>
                        <li>&nbsp;</li>
                    </div>
                </ul>
            </div>
            <div class="col-md-2">
                <ul class="nav nav-pills nav-stacked">
                    <div class="well">
                        <small></small>
                        <li>&nbsp;</li>
                        <li>&nbsp;</li>
                        <li>&nbsp;</li>
                        <li>&nbsp;</li>
                    </div>
                </ul>
            </div>
            <div class="col-md-2">
                <ul class="nav nav-pills nav-stacked">
                    <div class="well">
                        <small></small>
                        <li>&nbsp;</li>
                        <li>&nbsp;</li>
                        <li>&nbsp;</li>
                        <li>&nbsp;</li>
                    </div>
                </ul>
            </div>
            <div class="col-md-2">
                <ul class="nav nav-pills nav-stacked">                        
                    <div class="well">
                        <small>Charts</small>
                        <li><a href="/system-charts2"><strong>Charts 2</strong></a></li>
                        <li><a href="/system-charts4"><strong>Charts 4</strong></a></li>
                        <li><a href="/system-charts6"><strong>Charts 6</strong></a></li>
                        <li><a href="/system-charts-pitch-deck"><strong>Charts Pitch Deck</strong></a></li>
                    </div>
                </ul>
            </div>
            <div class="col-md-2">
                <div class="well">
                    <small></small>
                    <li>&nbsp;</li>
                    <li>&nbsp;</li>
                    <li>&nbsp;</li>
                    <li>&nbsp;</li>
                </div>
    	    </div>
        </div>
        <div class="row">
            <div class="col-md-5 well">
                Create notices  <a href="/system-string-editor" class="btn">Edit</a>
                <div>
                    <button id="systemShutdown" onclick="verifyShutdown()" class="btn">
                        Maintenance Shutdown
                    </button> in
                    <input type="number" id="shutdownDelay" value="10" style="width: 50px"> minutes.
                    <p></p>
                </div>
            </div>
            <div class="col-md-1"></div>
            <div class="col-md-6 well">
                Misc.
                <div>
                    <a href="/admin/db-snapshot" class="btn btn-default"><strong>Snapshot the database and users tree</strong></a>
                    <textarea rows="4" cols="70" spellcheck="false">
                        <#if dbSnapshot?? >
                            <#list dbSnapshot as line >
${line}
                            </#list>
                        </#if>
                    </textarea>
                </div>
            </div>
        </div>
        <div class="row">
            <#if UserRole.does(user.getId(), "Admin") >
                <a href="/user-logins"><strong>Login Details</strong></a>
                <br>
            </#if>
            <div class="col-md-6" >
                <div id="chart_Logins"></div>
            </div>
            <div class="col-md-6" >
                <div id="chart_FailsFirsts"></div>
            </div>
            </div>
        <div class="row">
            <div class="col-md-6">
                <strong>Last 200 System Events</strong><br>
                <textarea class="mono" rows="10" cols="75" spellcheck="false">
                    <#list MySystemState.getInstance().getEvents() as event >
${String.format("%-15s %-8.8s %s",
                        Util.formatTimestamp(event.getTimestamp(), "MM/dd/YY HH:mm"),
                        event.getUsername(),
                        event.getEvent())}
                    </#list>
                </textarea>
            </div>
            <div class="col-md-6">
                <strong>Disk Utilization</strong><br>
                <a href="/admin/take_df" class="btn btn-default"><strong>Get Disk Utilization</strong></a>
                <textarea rows="4" cols="70" spellcheck="false">
                    <#if dbSnapshot?? >
                        <#list dbSnapshot as line >
                            ${line}
                        </#list>
                    </#if>
                </textarea>
            </div>
        </div>
        <p></p>
    </div>


    <p></p>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>

    <script>
        $(document).ready(function(){
            $('[data-toggle="tooltip"]').tooltip();
        });

        function verifyShutdown() {
            if (${UserRole.is(session.getUser().getId(), "Admin")?c}) {
                if (confirm("Are you sure?  A banner visible to all users will be displayed.")) {
                    var delay = $('#shutdownDelay')[0].value;
                    var url = "/session-api/create/notice/shutdown?delay=" + delay;
                    $.get(url, function (data, status) {
                        $("#systemShutdown").text(data);
                    });
                }
            } else {
                alert("Unauthorized Access, requires Admin privileges, ");
            }
        }

    </script>

    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

    <script type="text/javascript">
        google.charts.load('current', {'packages':['corechart', 'bar', 'line' ]});
        google.charts.setOnLoadCallback(drawChartLogins);
        google.charts.setOnLoadCallback(drawChartFailsFirsts);

        function drawChartLogins() {
            var data = new google.visualization.DataTable();
            data.addColumn('date', 'Date');
            data.addColumn('number', 'Logins');

            data.addRows([
            <#list charts.LoginRows as row>
                [ new Date(${row.year},${row.month},${row.day}), ${row.logins} ] <#if row?has_next >, </#if>
            </#list>
            ]);

            var options = {
                title: 'Logins Per Day (last 90 days)',
                'height':250,
                lineWidth: 0,
                pointSize: 3,
                hAxis: {
                    title: 'Date'
                },
                vAxis: {
                    title: 'Logins'
                }
            };

            var chart = new google.visualization.LineChart(document.getElementById('chart_Logins'));
            chart.draw(data, options);
        }
        function drawChartFailsFirsts() {
            var data = new google.visualization.DataTable();
            data.addColumn('date', 'Date');
            data.addColumn('number', 'Failed Login');
            data.addColumn('number', 'First Login');

            data.addRows([
            <#list charts.FailFirstRows as row>
                [ new Date(${row.year},${row.month},${row.day}), ${row.fails}, ${row.firsts} ] <#if row?has_next >, </#if>
            </#list>
            ]);

            var options = {
                title: 'Failed Logins and First Logins Per Day (last 90 days)',
                'height':250,
                lineWidth: 0,
                pointSize: 3,
                hAxis: {
                    title: 'Date'
                },
                vAxis: {
                    title: 'Logins'
                }
            };

            var chart = new google.visualization.LineChart(document.getElementById('chart_FailsFirsts'));
            chart.draw(data, options);
        }

    </script>

    </body>
</html>


