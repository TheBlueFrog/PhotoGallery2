<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Seeder Home</title>
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

    <#assign user = session.getUser() >

    <div class="container">
        <div class="col-md-4">
            <a href="/"><strong>Home</strong></a>
            <br>
            <#if UserRole.isAnAdmin(user.getId()) >
                <a href="/admin"><strong>Admin Home</strong></a>
                <br>
            </#if>
        </div>
        <div class="col-md-8">
            <h2>Item and Offer Management</h2>
            ${user.getName()}
            <p></p>
        </div>
    </div>

    <div class="container">
        <form method="post">
            <input type="hidden" name="operation" value="showDisabledItem" />
            <div>
                <input type="checkbox" name="showDisabledItems" onChange="this.form.submit()"
                     <#if session.showDisabledItems >
                         checked
                     </#if>
                > Show disabled items
            </div>
        </form>
    </div>
    <p></p>
    <div class="container">
        <div class="row">
            <div class="col-sm-12">
                <table style="width:90%">
                    <tr>
                        <th width="5%">Edit</th>
                        <th width="7%">Enable</th>
                        <th width="3%">Id</th>
                        <th width="8%">Category</th>
                        <th width="20%">ShortOne</th>
                        <th width="20%">ShortTwo</th>
                        <th width="20%">Description</th>
                        <th width="10%">Note</th>
                    </tr>
                    <#list Util.sortItemsByShortOne(user.getItems()) as item >
                        <#if (session.showDisabledItems || item.getEnabled()) >
                            <tr>
                                <td><a href="seeder-item-editor?itemId=${item.id}"><span class="glyphicon glyphicon-pencil"></a></td>
                                <td>
                                    <form method="post">
                                        <input type="hidden" name="operation" value="changeItemEnable" />
                                        <input type="hidden" name="itemId" value="${item.getId()}" />
                                        <input type="checkbox" name="itemEnable" onchange="this.form.submit()"
                                            <#if item.getEnabled() >
                                               checked
                                            </#if>
                                        >
                                    </form>
                                </td>
                                <td>${item.identification}</td>
                                <td>${item.category}</td>
                                <td>${item.shortOne}</td>
                                <td>${item.shortTwo}</td>
                                <td>${item.description}</td>
                                <td>${item.note}</td>
                            </tr>
                        </#if>
                    </#list>
                </table>
            </div>
        </div>
        <form method="post">
            <div class="row">
                <input type="hidden" name="operation" value="createItem" />
                <input class="col-sm-2" type="submit" value="Create Item">
            </div>
        </form>
    </div>

    <p>&nbsp;</p>

    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>


</body>
</html>