<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta charset="UTF-8">
        <title>Support</title>
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

    .mine4 {
        padding: 0;
        margin: 0;
        font-size: 14px;
        text-align: center;
        color: #000000;
            border-top: 0px solid #e9e9e9;
            border-bottom: 0px solid #e9e9e9;
    }

    </style>

    </head>
    <body class="">
    <@pageHeader3 />

    <p></p>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-3">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="admin"><strong>Admin Home</strong></a>
            </div>
            <div class="col-md-3">
                <h2>MilkRuns</h2>
            </div>
            <div class="col-md-3">
            </div>
        </div>
    </div>

    <p></p>

    <div class="container-fluid">
        <div class="row">
            <div class="col-sm-1" ></div>
            <div class="col-sm-1" > ${currentMilkRun.getTimeAsHumanReadableString("MM/dd/YYYY")}</div>
            <div class="col-sm-1" >
                ${currentMilkRun.getStateAsString(session)}
            </div>
            <div class="col-sm-1" > ${currentMilkRun.closer.username}</div>
            <div class="col-sm-3" >
                <a href="/next-milkrun/supplier"><strong>Supplier View</strong></a>
                <br>
                <a href="/next-milkrun/consumer"><strong>Consumer View</strong></a>
                <p></p>
            </div>
            <div class="col-sm-3" >
                <form class="form-horizontal" method="post">
                    <input type="hidden" name="operation" value="SetName" />
                    <input type="hidden" name="id" value="${currentMilkRun.id}" />
                    <input type="submit" value="Update">
                    <input type="text" name="name" placeholder="" value="${currentMilkRun.name}"/>
                </form>
            </div>
        </div>
        <p></p>
        <div class="row">
            <div class="col-sm-1" ></div>
            <div class="col-sm-1" ><strong>Date</strong></div>
            <div class="col-sm-1" ><strong>Status</strong></div>
            <div class="col-sm-1" ><strong>By Whom</strong></div>
            <div class="col-sm-1" ><strong>ID</strong></div>
            <div class="col-sm-2" ><strong>Stats</strong></div>
            <div class="col-sm-3" ><strong>Name</strong></div>
            <hr>
        </div>
        <#list session.getMilkRunTree() as milkrun>
            <div class="row">
                <#if milkrun.getParent()?? >
                <#else>
                    <p></p>
                </#if>
                <div class="col-sm-1"></div>
                <a href="/milkrun/show2/${milkrun.id}" >
                    <div class="col-sm-1" >
                        ${milkrun.getTimeAsHumanReadableString("MM/dd/YYYY")}</div>
                    <div class="col-sm-1"  style="background-color:${milkrun.getColor()}">
                        ${milkrun.getStateAsString(session)}
                    </div>
                    <div class="col-sm-1" >
                        ${milkrun.closer.username}</div>
                    <div class="col-sm-1" >
                        ${milkrun.getShortId()}...
                    </div>
                    <div class="col-sm-2" >
                        ${milkrun.getStats()}
                    </div>
                </a>
                <div class="col-sm-3" >
                    <form class="form-horizontal" method="post">
                        <input type="hidden" name="operation" value="SetName" />
                        <input type="hidden" name="id" value="${milkrun.id}" />
                        <input type="submit" class="mine4" value="Update">
                        <input type="text" class="mine4" name="name" placeholder="" value="${milkrun.name}"/>
                    </form>
                </div>
            </div>
        </#list>
    </div>

    <p></p>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
    </body>
</html>
