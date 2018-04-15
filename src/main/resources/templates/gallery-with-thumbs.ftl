<!DOCTYPE html>
<html>
<#include "macros.ftl">
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta charset="UTF-8">
        <title>Photo Gallery</title>

        <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">

        <@styleSheets />
    <style>

        .mySlides {display:none}
        .demo {cursor:pointer}

    </style>
</head>
<body>

    <@pageHeader3 />

    <#if session.getUser()?? >
        <#assign images = session.getUser().getImages() >
    <#else >
        <#assign images = session.getPublicImages() >
    </#if>

    <div class="w3-content" style="max-width:1200px">

        <#list images as image >
                <div class="w3-display-container mySlides">
                    <img src="${image.getPath()}" style="width:100%">

                    <#if (image.getCaption()?length > 0) >
                        <div class="w3-display-bottomright w3-container w3-padding-16 w3-black">
                            ${image.getCaption()}
                        </div>
                    </#if>
                </div>
        </#list>

        <div class="w3-row-padding w3-section">
            <#assign i = 0 >
            <#list images as image >
                    <img class="demo w3-opacity w3-hover-opacity-off"
                         src="${image.getPath()}"
                         style="width:10%" onclick="currentDiv(${i})">
                <#assign i = i + 1 >
            </#list>
        </div>
    </div>


<#--

        <#list images as image >
            <div class="responsive">
                <div class="img">
                    <a target="_blank" href="${image.getPath()}">
                        <img src="${image.getPath()}" alt="" width="300" height="300">
                    </a>
                    <div class="desc">
                        ${image.getCaption()}
                    </div>
                </div>
            </div>
        </#list>

    <div class="clearfix"></div>

    <div style="padding:6px;">
    </div>
-->
    <script>
        var slideIndex = 0;
        showDivs(slideIndex);

        function plusDivs(n) {
            showDivs(slideIndex += n);
        }

        function currentDiv(n) {
            showDivs(slideIndex = n);
        }

        function showDivs(n) {
            var i;
            var x = document.getElementsByClassName("mySlides");
            var dots = document.getElementsByClassName("demo");
            if (n >= x.length) {slideIndex = 0}
            if (n < 0) {slideIndex = x.length}
            for (i = 0; i < x.length; i++) {
                x[i].style.display = "none";
            }
            for (i = 0; i < dots.length; i++) {
                dots[i].className = dots[i].className.replace(" w3-opacity-off", "");
            }
            x[slideIndex].style.display = "block";
            dots[slideIndex].className += " w3-opacity-off";
        }
    </script>

</body>
</html>
