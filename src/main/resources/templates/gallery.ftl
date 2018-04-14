<!DOCTYPE html>
<html>
<#include "macros.ftl">
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta charset="UTF-8">
        <title>${system.site.Company}</title>
        <@styleSheets/>

    <style>
div.img {
    border: 1px solid #ccc;
}

div.img:hover {
    border: 1px solid #777;
}

div.img img {
    width: 100%;
    height: auto;
}

div.desc {
    padding: 5px;
    text-align: center;
}

* {
    box-sizing: border-box;
}

.responsive {
    padding: 0px;
    float: left;
    width: 24.99999%;
}

@media only screen and (max-width: 700px){
    .responsive {
        width: 49.99999%;
        margin: 0px 0;
    }
}

@media only screen and (max-width: 500px){
    .responsive {
        width: 100%;
    }
}

img {
  display: block;
  max-width:300px;
  max-height:300px;
  width: auto;
  height: auto;
  border: 0;
  padding: 0;
  margin: 0;
}

.clearfix:after {
    content: "";
    display: table;
    clear: both;
}
</style>
</head>
<body>
<@pageHeader3 "gallery.ftl"/>

<h4>Image Gallery</h4>

<#list session.images as image >
    <div class="responsive">
        <div class="img">
            <a target="_blank" href="${image.path}">
                <img src="${image.path}" alt="" width="300" height="300">
            </a>
            <div class="desc">
                ${image.caption}
            </div>
        </div>
    </div>
</#list>

<div class="clearfix"></div>

<div style="padding:6px;">
</div>

</body>
</html>
