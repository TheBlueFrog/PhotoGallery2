<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Manage User ${User.findById(session.getAttribute("targetUserId")).getName()}</title>
    <@styleSheets/>
    <style>
        th { text-align: left; }
        td {
            text-align: left;
            vertical-align: text-top;
        }
    </style>

</head>
    <body class="">
    <header class="header">
        <@topOfPageHeader/>
    </header>

    <#assign user = User.findById(session.getAttribute("targetUserId")) >

    <a href="/"><h4>Home</h4></a>
    <p></p>
    <h3>Manage User ${user.getName()}</h3>
    <p></p>
    <div class="maincontainer">
        <div class="row">
            <div class="col-md-1"></div>

            <form class="form-horizontal container" id="${user.getId()}" method="post" action="/accounts/${user.getId()}">
                <input type="hidden" name="operation" value="update" />

                <div class="col-md-2">
                    ${user.getName()}
                </div>
                <div class="col-md-2">
                    ${user.getId()}
                </div>
                <div class="col-md-1">
                    <a href="/notes?${user.getId()}">Notes</a>
                </div>
                <div class="col-md-1">
                    <a href="/user-details/${user.getId()}">Roles</a>
                </div>
            <form>
        </div>
    </div>

    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
    </body>

</html>