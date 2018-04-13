<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta charset="UTF-8">
        <title>MilkRun Drivers</title>
        <@styleSheets/>

        <style>
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

    </head>
    <body class="">
    <@pageHeader3 />

    <p></p>

    <#assign user = session.user >

    <div class="container">
        <div class="row">
            <p></p>
            <h4>MilkRun Drivers Home Page</h4>
            <p></p>
            <a href="shop-list-view2"><strong>Home</strong></a>
            <p></p>
            <#if UserRole.isAnAdmin(user.getId()) >
                <a href="/admin"><strong>Admin Home</strong></a>
                <p></p>
            </#if>
        </div>
        <div class="row">
            <#if UserRole.isAnAdmin(user.getId()) || user.doesRole("Driver") >
                <div class="col-md-1"></div>
                <div class="col-md-11">
                    <h4>MilkRuns available to deliver</h4>
                    <#assign shown = false >
                    <#list MilkRunDB.findByState("Delivering") as milkRunDB >
                        <#assign shown = true >
                        <#assign milkRun = MilkRun.load(milkRunDB.getId()) >
                        <#assign metrics = milkRun.getRouteData().getMetrics() >
                        <div class="col-md-4">
                            <a href="/driver/show?id=${milkRun.getId()}&driver=${user.getId()}">
                                <span style="background-color: ${milkRun.getColor()}" >
                                    ${milkRun.name} &nbsp; (${String.format("%8.8s...", milkRun.id)})
                                </span>
                            </a>
                        </div>
                        <div class="col-md-3">
                            ${Util.formatTime(metrics.getLengthMs(), "H:mm")}
                            &nbsp;
                            ${String.format("%.1f Miles", (metrics.getLengthMeters() / 1000.0) / 1.609344 )}
                            &nbsp;
                            ${String.format("%.1f Km", metrics.getLengthMeters() / 1000.0)}
                        </div>
                        <div class="col-md-5">
                            &nbsp;
                            <br>
                            <table width="95%">
                                <#list UserNote.findAllByMilkRunId(milkRun.getId()) as note >
                                    <tr>
                                        <td width="35%">
                                            ${User.findById(note.getUserId()).getName()}
                                        </td>
                                        <td width="65%">${note.getBody()}</td>
                                    </tr>
                                </#list>
                            </table>
                        </div>
                    </#list>
                    <#if ! shown >
                        <h4>No current MilkRun</h4>
                    </#if>
                </div>
            </#if>
            <p>&nbsp;</p>
            <div class="row">
                <p>&nbsp;</p>
                <div class="col-md-1"></div>
                <div class="col-md-5">
                    <h4>Good Practices</h4>
                    <ul>
                        <li>
                        </li>
                    </ul>
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-5">
                    <h4>Not So Good Practices</h4>
                    <ul>
                        <li>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
        <p>&nbsp;</p>
        <hr>

        <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
        <@jsIncludes/>
    <script>
    </script>
    </body>
</html>
