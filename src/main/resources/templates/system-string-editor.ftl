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
    </style>

</head>
<body class="">
    <header class="header">
        <@topOfPageHeader/>
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
            <h4>System String Data Editor</h4>
        </div>
    </div>

    <#if pageState.getMessage()?? >
        <div class="row">
            <div class="col-sm-3"></div>
            <div class="col-sm-6">
                <h3>
                    ${pageState.getMessage()}
                </h3>
                <p></p>
            </div>
            <div class="col-sm-3"></div>
        </div>
    </#if>

    <div class="maincontainer">
        <div class="row">
            <div class="col-md-1"></div>
            <div class="col-sm-11">
                <table style="width:80%">
                    <tr>
                        <th width="10%"></th>
                        <th width="10%"></th>
                        <th width="20%">Key</th>
                        <th width="60%">Value</th>
                    </tr>
                    <#list StringData.findByUserIdOrderByKey("") as item >
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
                                    <input name="Key" type="text" size="25" value="${item.getKey()}">
                                </td>
                                <td>
                                    <input name="Value" type="text" size="70"  value="${item.getValue()}">
                                </td>
                            </form>
                        </tr>
                    </#list>
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
    </script>


</body>
</html>