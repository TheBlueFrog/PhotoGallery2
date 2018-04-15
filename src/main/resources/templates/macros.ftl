

<#include "macros-css.ftl">
<#include "macros-js.ftl">
<#include "macros-pageHeader.ftl">
<#include "macros-pageFooter.ftl">


<#macro showLoginButton>
    <#if session.getUser()?? >
        <a href="/logout"><i class="fa fa-key"></i>LOGOUT ${session.getUser().getLoginName()}</a>
    <#else>
        <a href="/login"><i class="fa fa-key"></i>LOGIN</a>
    </#if>
</#macro>

<#macro showUploadButton>
    <#if session.getUser()?? >
        <a href="/upload"><i class="fa fa-key"></i>Upload</a>
    </#if>
</#macro>

<#macro showGalleryButton>
    <a href="/gallery"><i class="fa fa-key"></i>Public Gallery</a>
</#macro>

<#macro showMyGalleryButton>
    <#if session.getUser()?? >
        <a href="/gallery/${session.getUser().getLoginName()}"><i class="fa fa-key"></i>My Gallery</a>
    </#if>
</#macro>

<#macro showRegisterButton>
    <#if session.getUser()?? >

    <#else>
        <li><a href="register-account"><i class="fa fa-user"></i>JOIN</a></li>
    </#if>
</#macro>

