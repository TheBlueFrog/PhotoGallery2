<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Photo Gallery</title>
    <@styleSheets/>
</head>
<body class="">

    <@pageHeader3 />

    <#if session.getUser()?? >
        <p>Hello ${session.getUser().getLoginName()}</p>
    <#else>
        <p>Hello visitor</p>
    </#if>

    <@jsIncludes/>
</body>
</html>
