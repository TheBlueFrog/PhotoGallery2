<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <@styleSheets/>
    <title>Upload Images</title>
    <style>
        th { text-align: left; }
        td {
            text-align: left;
            vertical-align: text-top;
        }
        tr {
            padding-top: 5px;
            padding-bottom: 5px;
        }
    </style>

</head>
<body>
    <@pageHeader3 />

    <p></p>
    <div>
        <div class="row">
            <div class="col-sm-1"></div>
            <div class="col-sm-11">

                <form class="form-horizontal" method="POST" enctype="multipart/form-data" action="/upload-image">
                    Files to upload &nbsp;
                    <input type="file" name="files" multiple/> &nbsp;
                    <input type="submit" value="Upload" />
                </form>

            </div>
        </div>
    </div>
    <p></p>
    <p></p>
    <div>
        <div class="col-sm-1"></div>
        <div class="col-sm-10">
            <table width="100%">
                <#list session.getUser().getImages() as image >
                    <tr>
                        <form class="form-horizontal" method="POST" action="/update">
                            <input type="hidden" name="id" value="${image.getId()}" />
                            <td width="20%">
                                <img src="${image.getPath()}" alt="" width="100" height="100"/>
                                &nbsp;
                                <a href="/view/${image.getPath()}">${image.getFilename()}</a>
                            </td>
                            <td width="50%">
                                <input type="text" name="caption" value="${image.getCaption()}" size="50"/>
                            </td>
                            <td width="20%">
                                <#if (image.isPublic()) >
                                    <label><input type="checkbox" name="public"  value="" checked>Public</label>
                                <#else>
                                    <label><input type="checkbox" name="public"  value="" unchecked>Public</label>
                                </#if>
                                <input type="submit" value="Update" />
                            </td>
                        </form>
                    </tr>
                </#list>
            </table>
        </div>
    </div>


    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>

</body>
</html>