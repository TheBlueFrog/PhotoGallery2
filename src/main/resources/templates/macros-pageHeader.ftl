
<#macro pageHeader3 >
    <header class="header">
        <div class="top-header">
            <div class="container">
                <div class="top-header-menu">
                    <@showGalleryButton/>
                </div>
                <div class="top-header-right">
                    <ul>
                        <li><@showMyGalleryButton/></li>
                        <li><@showUploadButton/></li>
                        <li><@showRegisterButton/></li>
                        <li><@showLoginButton/></li>
                    </ul>
                </div>
            </div>
        </div>
    </header>
</#macro>

<#macro messageHeader msg >
    <div class="row">
        ${msg}
    </div>
</#macro>