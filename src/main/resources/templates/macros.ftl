

<#include "macros-css.ftl">
<#include "macros-js.ftl">
<#include "macros-pageHeader.ftl">
<#include "macros-pageFooter.ftl">


<#macro showLoginButton>
    <#if session.getUser()?? >
        <a href="/logout">LOGOUT ${session.getUser().getLoginName()}</a>
    <#else>
        <a href="/login">LOGIN</a>
    </#if>
</#macro>

<#macro showUploadButton>
    <#if session.getUser()?? >
        <a href="/upload">Upload</a>
    </#if>
</#macro>

<#macro showGalleryButton>
    <a href="/gallery">Public Gallery</a>
</#macro>

<#macro showMyGalleryButton>
    <#if session.getUser()?? >
        <a href="/gallery/${session.getUser().getLoginName()}">My Gallery</a>
    </#if>
</#macro>

<#macro showRegisterButton>
    <#if session.getUser()?? >

    <#else>
        <li><a href="register-account"><i class="fa fa-user"></i>JOIN</a></li>
    </#if>
</#macro>

