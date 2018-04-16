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
            text-align: left;
            vertical-align: text-top;
        }
        .mine {
            padding-top: 5px;
            padding-bottom: 5px;
        }

        div.items {
            height: 500px;
            overflow: scroll;
        }
    </style>

</head>
<body>
    <@pageHeader3 />

    <p></p>
    <div class="row">
        <div class="col-sm-1"></div>
        <div class="col-sm-10">
            <table width="90%">
                <tr>
                    <th width="10%">Public</th>
                    <th width="25%">Thumbnail</th>
                    <th width="50%">Caption</th>
                </tr>
            </table>
        </div>
    </div>

        <div class="items">
            <div class="col-sm-1"></div>
            <div class="col-sm-10">
                <table width="90%">
                    <#list session.getUser().getImages() as image >
                        <form class="form-horizontal" >
                            <input type="hidden" name="id" value="${image.getId()}" />
                            <tr>
                                <td width="10%">
                                    <label><input type="checkbox" name="public" value=""
                                                  onchange="updatePublic('${image.getId()}', this.checked)"
                                        <#if (image.isPublic()) >
                                            checked
                                        </#if>
                                    ></label>
                                </td>
                                <td width="25%">
                                    <img class="mine" src="${image.getPath()}" alt="" height="200px"/>
                                    <#--
                                    &nbsp;
                                    <a href="/view/${image.getPath()}">${image.getFilename()}</a>
                                    -->
                                </td>
                                <td width="50%">
                                    <input type="text"
                                           name="caption"
                                           value="${image.getCaption()}"
                                           size="50"
                                           onfocusout="updateCaption('${image.getId()}', this.value)"
                                    />
                                </td>
                            </tr>
                        </form>
                    </#list>
                </table>
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
    </script>
</body>
</html>