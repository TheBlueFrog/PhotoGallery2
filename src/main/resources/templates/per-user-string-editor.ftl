<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Editor</title>
    <@styleSheets/>
    <style>
        th { text-align: left; }
        td {
            text-align: left;
            vertical-align: text-top;
        }

        .mono {
            font-family: "monospace";
        }
        .mine5 {
            width: 100%;
            height: 100%;
            padding: 0;
            margin: 0;
            text-align: left;
            vertical-align: top;
            font-size: 18px;
            rows: 4;
            cols: 200;
        }
    </style>

</head>
<body class="">
    <header class="header">
        <@pageHeader3/>
    </header>

    <div class="maincontainer">
        <div class="col-md-1"></div>
        <div class="col-md-3">
            <a href="/"><strong>Home</strong></a>
            <br>
            <a href="/admin"><strong>Admin Home</strong></a>
            <br>
        </div>
        <div class="col-md-5">
            <h4>Per-User String Data Editor</h4>
            UUID: <#if session.getAttribute("targetUserId")?? >${session.getAttribute("targetUserId")}</#if>
        </div>
    </div>

    <@messageHeader session.getAttributeS("perUserStringEditor-message") />

    <div class="maincontainer">
        <div class="row">
            <div class="col-md-1"></div>
            <div class="col-md-3">
                <select class="mono" id="userSelect" onchange="userChanged()">
                    <#list Util.sortByUserName(User.findByEnabled(true)) as user >
                        <option value="${user.getId()}"
                            <#if session.getAttribute("targetUserId")?? >
                                <#if user.getId() == session.getAttributeS("targetUserId") >
                                    selected
                                </#if>
                            </#if>
                        >${user.getIdShort()}...  ${String.format("%-40s", user.getName())}</option>
                    </#list>
                </select>
            </div>
        </div>
        <p></p>

        <div class="row">
            <div class="col-md-1"></div>
            <div class="col-sm-11">
                <table style="width:90%">
                    <tr>
                        <th width="8%"></th>
                        <th width="8%"></th>
                        <th width="14%">Key</th>
                        <th width="70%">Value</th>
                    </tr>
                    <#if session.getAttribute("targetUserId")?? >
                        <#list StringData.findByUserIdOrderByKey(session.getAttribute("targetUserId")) as item >
                            <tr>
                                <td>
                                    <form method="post">
                                        <input type="hidden" name="id" value="${item.getId()}" />
                                        <input type="hidden" name="operation" value="Delete" />
                                        <input type="submit" value="Delete">
                                    </form>
                                </td>
                                <form method="post">
                                    <input type="hidden" name="id" value="${item.getId()}" />
                                    <td>
                                        <input type="hidden" name="operation" value="Update" />
                                        <input type="submit" value="Update">
                                    </td>
                                    <td>
                                        <input name="Key" value="${item.getKey()}">
                                    </td>
                                    <td>
                                        <textarea class="mine5"
                                                  style="height: 50px"
                                                  name="Value"
                                                  onchange="bodyChanged(this.value)">${item.getValue()}</textarea>
                                    </td>
                                </form>
                            </tr>
                        </#list>
                    </#if>
                </table>
            </div>
        </div>
    </div>

    <form class="form-horizontal" id="OfferForm" method="post">
        <div class="form-group">
            <label class="col-sm-1"></label>
            <input type="hidden" name="operation" value="Create" />
            <input class="col-sm-2" type="submit" value="Create">
        </div>
    </form>

    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>

    <script>
    function userChanged() {
        var x = document.getElementById('userSelect').value;
        location.assign("/per-user-string-editor?targetUserId=" + x);
    }

    </script>


</body>
</html>