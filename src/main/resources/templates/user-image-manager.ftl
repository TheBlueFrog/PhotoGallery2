<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>User Image Editor</title>
    <@styleSheets/>

    <style>
        hr {
            display: block;
            margin-top: 0.5em;
            margin-bottom: 0.5em;
            margin-left: auto;
            margin-right: auto;
            border-style: inset;
            border-width: 1px;
        }
    </style>
</head>
<body class="">
    <header class="header">
        <@topOfPageHeader/>
    </header>

    <div class="maincontainer">
        <row class="col-sm-12">
            <div class="col-sm-1"></div>
            <div class="col-sm-8">
                <p></p>
                <h4>User Image Manager</h4>
                <p></p>
                <p>
                    User's may have zero, one or more images.
                </p>
            </div>
        </row>
        <row>
            <div class="col-sm-3"></div>
            <div class="col-sm-2">Image</div>
            <div class="col-sm-2">Usage</div>
            <div class="col-sm-2">File name</div>
            <div class="col-sm-2">Caption</div>
        </row>
    </div>
    <p></p>
    <div class="maincontainer">

        <#list session.user.images as image>
            <row class="col-sm-12">
                <div class="col-sm-1"></div>
                <form class="form-horizontal" method="post" >
                    <input type="hidden" name="operation" value="Delete" />
                    <input type="hidden" name="imageId" value="${image.id}" />
                    <div class="form-group col-sm-1">
                        <input type="submit" value="Delete">
                    </div>
                </form>
                <form class="form-horizontal" method="post" >
                    <input type="hidden" name="operation" value="Update" />
                    <input type="hidden" name="imageId" value="${image.id}" />
                    <div class="form-group col-sm-1">
                        <input type="submit" value="Update">
                    </div>
                    <div class="col-sm-1"></div>
                    <div class="col-sm-2">
                        <img src="${image.path}" width="100" />
                    </div>
                    <div class="col-sm-2">
                        <input type="text" name="usage" placeholder="" value="${image.usage}"/>
                    </div>
                    <div class="col-sm-2">
                        <select name="filename">
                            <#list filesystemUserImages as diskImage>
                                <option value="${diskImage}"
                                <#if diskImage == image.filename >
                                    selected
                                </#if>
                                >${diskImage}</option>
                            </#list>
                        </select>
                    </div>
                    <div class="col-sm-2">
                        <input type="text" name="caption" placeholder="" value="${image.caption}"/>
                    </div>
                </form>
            </row>
        </#list>
    </div>
    <p></p>
    <p></p>
    <div class="col-sm-12">
        <form class="form-horizontal" method="post">
            <div class="col-sm-1"></div>
            <div class="form-group">
                <input type="hidden" name="operation" value="Create" />
                <input class="col-sm-1" type="submit" value="Create">

                <div class="col-sm-1"></div>
                <div class="col-sm-2">
                    <input type="text" name="usage" placeholder="Usage, e.g. Main" value=""/>
                </div>
                <div class="col-sm-2">
                    <select name="filename">
                        <#list filesystemUserImages as diskImage>
                            <option value="${diskImage}">
                                ${diskImage}
                            </option>
                        </#list>
                    </select>
                </div>
                <div class="col-sm-2">
                    <input type="text" name="caption" placeholder="Caption" value=""/>
                </div>
            </div>
        </form>
    </div>
    <p></p>
    <p></p>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
</body>
</html>
