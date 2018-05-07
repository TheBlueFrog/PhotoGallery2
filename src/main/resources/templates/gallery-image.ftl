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

    <#if session.getAttribute("userGallery")?? >
        <#assign images = User.findById(session.getAttributeS("userGallery")).getImages("JPG") >
    <#else >
        <#assign images = session.getPublicImages("JPG") >
    </#if>

    <div class="w3-content w3-display-container">

        <#assign i = 0 >
        <#list images as image >
            <div class="w3-display-container mySlides">
                <img src="${image.getPath()}" style="height:800px; width:auto; horiz-align: center">

                <#if (image.getCaption()?length > 0) >
                    <div class="w3-display-bottomleft w3-large w3-container w3-padding-16 w3-gray">
                        ${image.getCaption()}
                    </div>
                </#if>
            </div>
            <#assign i = i + 1 >
        </#list>

        <button class="w3-button w3-display-left w3-black" onclick="plusDivs(-1)">&#10094;</button>
        <button class="w3-button w3-display-right w3-black" onclick="plusDivs(1)">&#10095;</button>

    </div>

<script>
        var slideIndex = 0;

        showDivs();

        function plusDivs(n) {
            slideIndex += n;
            showDivs();
        }

        function showDivs() {
            var i;
            var x = document.getElementsByClassName("mySlides");
            if (slideIndex >= x.length) {slideIndex = 0}
            if (slideIndex < 0) {slideIndex = x.length - 1}
            for (i = 0; i < x.length; i++) {
                x[i].style.display = "none";
            }
            // for (i = 0; i < dots.length; i++) {
            //     dots[i].className = dots[i].className.replace(" w3-opacity-off", "");
            // }
            x[slideIndex].style.display = "block";
//            dots[slideIndex].className += " w3-opacity-off";
        }
    </script>

</body>
</html>
