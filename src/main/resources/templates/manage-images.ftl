<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <@styleSheets/>
    <title>Manage Items</title>
    <style>
        th { text-align: left; }
        td {
            padding-top: 0;
            text-align: left;
            vertical-align: top;
            padding-left:20px;
        }
        .mine {
            padding-top: 5px;
            padding-bottom: 5px;
        }

    </style>

</head>
<body>
    <@pageHeader3 />

    <p></p>
    <div class="row">
        <div class="items">
            <div class="col-sm-1"></div>
            <div class="col-sm-11">
                <table width="95%">
                    <#list session.getUser().getImages("JPG")?chunk(2) as row >
                        <tr>
                            <#list row as image >
                                <td width="20%">
                                    <img class="mine" src="${image.getPath()}" alt="" height="auto" width="200px"/>
                                <#--
                                &nbsp;
                                <a href="/view/${image.getPath()}">${image.getFilename()}</a>
                                -->
                                </td>
                                <td width="25%">
                                    <i>${image.getFilename()}</i>
                                    <br>
                                    <input type="checkbox" name="public" value=""
                                                  onchange="updatePublic('${image.getId()}', this.checked)"
                                        <#if (image.isPublic()) >
                                            checked
                                        </#if>
                                    />Public
                                    &nbsp;&nbsp;
                                    <input type="text"
                                           name="caption"
                                           value="${image.getCaption()}"
                                           placeholder="Caption"
                                           onfocusout="updateCaption('${image.getId()}', this.value)"
                                    />
                                    <br>
                                    <button class="btn btn-sm" onclick="deleteItem('${image.getId()}')">Delete</button>
                                </td>
                                <td width="5%">
                                </td>
                            </#list>
                        </tr>
                    </#list>
                </table>
            </div>
        </div>
    </div>

    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>

    <script>
        function updateCaption(imageId, value) {
            var url = "manage-api/update?imageId=" + imageId + "&caption=" + value;
            $.get(url, function (data, status) {
                if (status == "success") {
//                    location.reload();
                }
                else {
                }
            });
        }
        function updatePublic(imageId, value) {
            var url = "manage-api/update?imageId=" + imageId + "&public=" + value;
            $.get(url, function (data, status) {
                if (status == "success") {
//                    location.reload();
                }
                else {
                }
            });
        }

        function deleteItem(imageId) {
            var url = "manage-api/delete?imageId=" + imageId;
            $.get(url, function (data, status) {
                if (status == "success") {
                    location.reload();
                }
                else {
                }
            });
        }

    </script>
</body>
</html>