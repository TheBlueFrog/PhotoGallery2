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

    <p></p>
    <div class="container">
        <div class="row">
            <div class="col-md-2">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="/admin"><strong>Back to Admin</strong></a>
            </div>
        </div>
<p></p>

        <div class="row">
            <div class="col-md-6">
                <strong>Last 200 Login Events</strong> &nbsp; Does not include Admin switches<br>
                <textarea class="mono" rows="10" cols="75" spellcheck="false">
                <#list SystemEvent.findTop200ByEventContainingOrderByTimestampDesc("Logged in") as event >
${String.format("%-15s %-8.8s %s",
                            Util.formatTimestamp(event.getTimestamp(), "MM/dd/YY HH:mm"),
                            event.getUsername(),
                            event.getEvent())}
                    </#list>
                </textarea>
            </div>
            <div class="col-md-6">
                <strong>Last 200 Incorrect Logins</strong><br>
                <textarea class="mono" rows="10" cols="75" spellcheck="false">
                    <#list SystemEvent.findTop200ByEventContainingOrderByTimestampDesc("Incorrect password") as event >
${String.format("%-15s %s", Util.formatTimestamp(event.getTimestamp(), "MM/dd/YY HH:mm"),
                    event.getEvent().replace("Incorrect password", "").replace("(", "").replace(")", "").replace("for login", ""))}
                    </#list>
                </textarea>
            </div>
        </div>
    </div>

    <p></p>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>

    <script>
        function verifyShutdown() {
            if (confirm("Are you sure?  All users will be notified.")) {
                var url = "/session-api/create/notice/shutdown";
                $.get(url, function(data, status){
                    $("#systemShutdown").text(data);
                });
            }
        }
        function verifyMilkrunClosing() {
            if (confirm("Are you sure?  All users will be notified.")) {
                var url = "/session-api/create/notice/milkrunClosing";
                $.get(url, function(data, status){
                    $("#milkrunClosing").text(data);
                });
            }
        }

        function runnerTracking() {
            var url = "/admin-api/runner-tracking?doAnalysis=true";
            $.get(url, function(data, status){
            });
        }

        function emailTest() {
            var url = "/admin-api/email?test=true";
            $.get(url, function(data, status){
            });
        }

    </script>
</body>
</html>


