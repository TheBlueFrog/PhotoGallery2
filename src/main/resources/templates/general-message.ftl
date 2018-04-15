<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<#assign pageName = "password-changed" >
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Photo Gallery</title>
<@styleSheets/>

    <style>
        .cart-button {
            color: inherit;
            font-size: 11px;
            padding: 2px 12px;
            display: inline-block;
            margin 0;
            margin-top: 15px;
            border-top: 1px solid #e9e9e9;
            border-bottom: 1px solid #e9e9e9;
        }
    </style>

</head>
<body class="">
    <@pageHeader3 />

    <@messageHeader session.getAttributeS("generalMessage-message") />

    <div class="maincontainer">
        <div class="row">
            <div class="col-sm-4 col-md-offset-3">
            </div>
            <div class="col-sm-4 col-md-offset-1">
            </div>
        </div>
    </div>

    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>

</body>
</html>
