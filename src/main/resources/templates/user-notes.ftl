<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Notes for ${User.findById(session.getAttribute("targetUserId")).getName()}</title>
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
        <@pageHeader3/>
    </header>
    <div class="maincontainer">
        <div class="col-md-1"></div>
        <div class="col-md-2">
            <a href="/"><h4>Home</h4></a>
            <a href="/users2"><h4>Back to Users</h4></a>
        </div>
    </div>
    <p></p>
    <div class="maincontainer">
        <div class="col-md-1"></div>
        <div class="col-md-5">
            <h4>Manage notes of ${User.findById(session.getAttribute("targetUserId")).getName()}</h4>
        </div>
    </div>
    <p></p>
    <div class="container">
        <form method="post" action="showClosed">
            <input type="hidden" name="operation" value="showClosedUserNotes" />
            <input type="hidden" name="userNotesUser" value="${session.getAttribute("targetUserId")}" />
            <div>
                <input type="checkbox" name="showClosedUserNotes" onChange="this.form.submit()"
                <#if session.showClosedUserNotes >
                    checked
                </#if>
                > Show user notes with Closed status
            </div>
        </form>
    </div>
    <div class="maincontainer">
        <#list User.findById(session.getAttribute("targetUserId")).getNotes("NotClosed") as note >
            <div class="row">
                <form class="form-horizontal" method="post" >
                    <input type="hidden" name="operation" value="Update" />
                    <input type="hidden" name="noteId" value="${note.id}" />
                    <div class="col-md-1"></div>
                    <div class="col-md-1">
                        <input type="submit" value="Update">
                    </div>
                    <div class="col-md-2">
                        ${note.timestampAsString}
                    </div>
                    <div class="col-md-1">
                        <input type="text" name="status" placeholder="Status" value="${note.status}"/>
                    </div>
                    <div class="col-md-6">
                        <input type="text" style="width: 100%" name="body" placeholder="Body" value="${note.body}"/>
                    </div>
                </form>
            </div>
        </#list>
    </div>
    <p></p>
    <div class="col-sm-12">
        <form class="form-horizontal" method="post">
            <div class="form-group">
                <input type="hidden" name="operation" value="Create" />
                <div class="col-sm-1"></div>
                <input class="col-sm-1" type="submit" value="Create">

                <div class="col-sm-1">
                    <input type="text" name="status" placeholder="Status" value=""/>
                </div>
                <div class="col-sm-6">
                    <input type="text" style="width: 100%" name="body" placeholder="Body" value=""/>
                </div>
            </div>
        </form>
    </div>
    <p></p>
    <p></p>
    &nbsp;<br>
    &nbsp;<br>
    &nbsp;<br>

    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
    </body>
</html>