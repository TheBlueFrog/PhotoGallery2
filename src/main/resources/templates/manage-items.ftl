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
        <div class="items">
            <div class="col-sm-1"></div>
            <div class="col-sm-10">
                <table width="90%">
                    <#list session.getUser().getImages("JPG") as image >
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
                                    <img class="mine" src="${image.getPath()}" alt="" height="150px"/>
                                    <#--
                                    &nbsp;
                                    <a href="/view/${image.getPath()}">${image.getFilename()}</a>
                                    -->
                                </td>
                                <td width="50%">
                                    <i>${image.getFilename()}</i>
                                    <br>
                                    <input type="text"
                                           name="caption"
                                           value="${image.getCaption()}"
                                           size="50"
                                           onfocusout="updateCaption('${image.getId()}', this.value)"
                                    />
                                </td>
                            </tr>
                    </#list>
                </table>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="items">
            <div class="col-sm-1"></div>
            <div class="col-sm-10">
                <table width="90%">
                    <#list session.getUser().getImages("MP4") as image >
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
                                <video width="320" height="240" controls>
                                    <source src="${image.getPath()}" type="video/mp4">
                                    <source src="movie.ogg" type="video/ogg">
                                    Your browser does not support the video tag.
                                </video>
                            </td>
                            <td width="50%">
                                <i>${image.getFilename()}</i>
                                <br>
                                <input type="text"
                                       name="caption"
                                       value="${image.getCaption()}"
                                       size="50"
                                       onfocusout="updateCaption('${image.getId()}', this.value)"
                                />
                            </td>
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
    </script>
</body>
</html>