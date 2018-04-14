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

    <div class="container">
        <p><a href="/${system.site.HomePage}">Home</a>
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
            <div class="col-sm-1"></div>
            <div class="col-sm-11">

                <table style="width:80%">
                    <tr>
                        <th >Change</th>
                        <th >Enabled</th>
                        <th >Identifier</th>
                        <th >Category</th>
                        <th >ShortOne</th>
                        <th >ShortTwo</th>
                        <th >Description</th>
                        <th >Note</th>
                    </tr>
                    <#list session.user.items as item>
                        <#if (session.showDisabledItems || item.enabled) >
                            <tr>
                                <td><a href="seeder-item-editor?itemId=${item.id}"><span class="glyphicon glyphicon-pencil"></a></td>
                                <td>${item.enabled?string('Yes', 'No')}</td>
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
    </div>

    <form class="form-horizontal" id="OfferForm" method="post">
        <div class="form-group">
            <label class="col-sm-1"></label>
            <input type="hidden" name="operation" value="CreateNewItem" />
            <input class="col-sm-1" type="submit" value="Create New Item">
        </div>
    </form>

    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>


</body>
</html>