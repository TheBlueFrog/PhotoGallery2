<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>MilkRun</title>
    <title>Administration</title>
    <@styleSheets/>

    <style>
        .backLinks {
            grid-column-start: 1;
            grid-column-end: 2;
            grid-row-start: 1;
            grid-row-end: 2;

            text-align: left;
        }
        .title {
            grid-column-start: 2;
            grid-column-end: 3;
            grid-row-start: 1;
            grid-row-end: 2;

            text-align: center;
        }
        .docLinks {
            grid-column-start: 3;
            grid-column-end: 4;
            grid-row-start: 1;
            grid-row-end: 2;

            text-align: right;
        }
        .row1 {
            display: grid;

            grid-template-columns: 1fr 3fr 1fr);

            margin-left: 50px;
            margin-right: 50px;
            margin-top: 20px;
        }
        * {box-sizing: border-box;}


        .row2 {
            display: grid;
//          grid-template-columns: repeat(6, 1fr);
            grid-template-columns: repeat(auto-fill, 150px);

            grid-column-gap: 10px;
            grid-row-gap: 10px;
            margin-left: 50px;
            margin-right: 50px;
        }
        .links1 {
            text-align: left;
        }

        .row3 {
            display: grid;
//            grid-template-columns: repeat(2, 1fr);
            grid-template-columns: repeat(auto-fill, 650px);
            grid-column-gap: 10px;
            grid-row-gap: 10px;
            margin-left: 50px;
            margin-right: 50px;
        }

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

    <div class="row1">
        <div class="backLinks">
            <a href="/"><strong>Home</strong></a>
        </div>
        <div class="title">
            <h2>Site Administration</h2>
        </div>
        <div class="docLinks">
            <a href="https://github.com/TheBlueFrog/milkrunDocs/blob/master/README.md"  target="_blank">
                <span class="docs pull-right">Documentation</span></a>
        </div>
    </div>
    <div class="row2">
        <div class="links1 well">
            <small>User Mgmt</small>
            <br><a href="/pending-accounts"><strong>Pending Accounts</strong></a>
            <br><a href="/users2"><strong>User Accounts</strong></a>
            <br><a href="/user-logins"><strong>Logins</strong></a>
            <br>
            <br><a href="/per-user-string-editor"><strong>User String Editor</strong></a>
            <br><a href="/user-map"><strong>User Map</strong></a>
        </div>
        <div class="links1 well">
            <small>Items, Offers etc.</small>
            <br><a href="/admin-offer-editor"><strong>Offers</strong></a>
            <br><a href="featured-offer-editor"><strong>Featured Offers</strong></a>
            <br>
            <br><a href="discounts"><strong>Discount Editor</strong></a>
        </div>
        <div class="links1 well">
            <small>MilkRuns</small>
            <br><span
            <#if MilkRunDB.findOpen().hasIssues() >
                    style="background-color:#FF8080"
            </#if>
            ><a href="/milkruns2/show-open" data-toggle="tooltip" title="View the "><strong>Open</a></strong></span>
            <br>
            <#if MilkRunDB.findCharging() ?? >
                <a href="/charge-milkrun?milkRunId=${MilkRunDB.findCharging().getId()}"><strong>Closing</a></strong>
            <#else>
                Closing
            </#if>
            <br><a href="/milkruns-closed"><strong>Closed</a></strong>
            <br><a href="/charge-milkrun"><strong>Charges</a></strong>
            <br><a href="/milkruns-history"><strong>History</a></strong>
            <br><a href="/emailing"><strong>Emailing</strong></a>
        </div>
        <div class="links1 well">
            <small>Misc.</small>
            <br><a href="/notes#by-time"><strong>Notes</strong></a>
            <br>
        <#--<br><a href="/system"><strong>Charts (old)</strong></a>-->
            <br><a href="/system-charts2"><strong>Charts 2</strong></a>
            <br><a href="/system-charts4"><strong>Charts 4</strong></a>
            <br>
            <br><a href="/nrfpty"><strong>NRFPTY</strong></a>
        </div>
        <div class="links1 well">
            <small>Documentation</small>
            <br><a href="https://github.com/TheBlueFrog/milkrunDocs/blob/master/README.md" target="_blank"><strong>Docs on GitHub</strong></a>
            <br>&nbsp;
            <br><a href="https://github.com/TheBlueFrog/milkrunDocs/blob/master/closing-a-run.md" target="_blank"><strong>Closing a Run</strong></a>
        </div>
        <div class="links1 well">
        <#if ! system.site.production >
            <small>Downloads for 0.36</small>
            <br>
            <a href="builds/static.tar.gz" download>static data tree</a>
            <br>
            <a href="builds/db-snapshot.txt" download>database</a>
            <br>
            <a href="builds/website.0.36.23.jar" download>Jar file</a>
            <br>
        </#if>
        </div>
    </div>

    <div class="row3">
        <div class="well">
            <strong>Create notices</strong> Notice content may be<a href="/system-string-editor" class="btn">edited.</a>
            Change the System String shown.
            <div>
                <button id="systemShutdown" onclick="verifyShutdown()" class="btn">
                    ${StringData.findByUserIdAndKey("", "MaintenanceShutdownBanner").getValue()}
                </button>
                <br><small>MaintenanceShutdownBanner</small>
                <p></p>
                <button id="milkRunClosing" onclick="verifyMilkrunClosing()" class="btn">
                    ${StringData.findByUserIdAndKey("", "MilkRunClosingBanner").getValue()}
                </button>
                <br><small>MilkRunClosingBanner</small>
            </div>
        </div>
        <div class="well">
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

    <div class="row3">
        <div class="well">
            <strong>Last 200 System Events</strong><br>
            <textarea class="mono" rows="10" cols="75" spellcheck="false">
                <#list system.getInstance().getEvents() as event >
${String.format("%-15s %-8.8s %s",
                    Util.formatTimestamp(event.getTimestamp(), "MM/dd/YY HH:mm"),
                    event.getUsername(),
                    event.getEvent())}
                </#list>
            </textarea>
        </div>
        <div class="well">
            <strong>CPU Load</strong><br>
            <textarea class="mono"  rows="10" cols="75" spellcheck="false">
            <#list system.getInstance().getCPULoad() as line >
${line}
                </#list>
            </textarea>
        </div>
    </div>

    <#if ! Website.isProduction() >
        <!-- allowing this on production is too uncontrolled -->
        <div class="row3">
            <div class="well">
                <strong>Do a git pull of the milkrunFiles repo</strong><br>
                <a href="/admin/git-pull-milkrun-files" class="btn"><strong>git pull</strong></a>
                <textarea class="mono" rows="10" cols="75" spellcheck="false">
                    <#list milkrunFilesRefreshOutput as line >
${line}
                    </#list>
                </textarea>
            </div>
        </div>
    </#if>


    <p></p>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>

    <script>
        $(document).ready(function(){
            $('[data-toggle="tooltip"]').tooltip();
        });

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

    </script>
</body>
</html>


