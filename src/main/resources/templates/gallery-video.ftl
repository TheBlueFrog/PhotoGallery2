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
        <#assign images = User.findById(session.getAttributeS("userGallery")).getImages("MP4") >
    <#else >
        <#assign images = session.getPublicImages("MP4") >
    </#if>

    <div class="col-md-12">

        <#list images as image >
            <video width="320" height="240" controls>
                <source src="${image.getPath()}" type="video/mp4">
                <source src="movie.ogg" type="video/ogg">
                Your browser does not support the video tag.
            </video>

            <#--<source src="" type="video/mv4">-->

            ${image.getCaption()}
            <i>${image.getFilename()}</i>
            <br>
        </#list>

    </div>

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
//            var dots = document.getElementsByClassName("demo");
            if (n >= x.length) {slideIndex = 0}
            if (n < 0) {slideIndex = x.length}
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
