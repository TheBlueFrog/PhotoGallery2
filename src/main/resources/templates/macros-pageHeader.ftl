
<#macro topOfPageHeader>
    <div class="top-header">
        <div class="container">
            <div class="top-header-menu">
                <a href="#"><i class="fa fa-phone"></i>${system.site.SupportPhone}</a>
                <a href="#"><i class="fa fa-clock-o"></i> ${system.site.SupportHours}</a>
                <@requestSupport/>
            </div>
            <div class="top-header-right">
                <ul>
                    <li><@showRegisterButton/></li>
                    <li><@showLoginButton/></li>
                    <#if session.user?? >
                        <li class="dropdown">
                            <a data-toggle="dropdown" href="#"><i class="fa fa-cog"></i>Settings</a>
                            <ul class="dropdown-menu">
                                <li><a href="#">PAYMENT</a></li>
                                <li><a href="#">POLICY</a></li>
                            </ul>
                        </li>
                    </#if>
                </ul>
            </div>
        </div>
    </div>
</#macro>


<#macro pageHeader thePage>
    <header class="header">
        <@topOfPageHeader/>
        <div class="main-header">
            <div class="container main-header-inner">
                <div id="form-search" class="form-search">
                    <form method="post">
                        <input type="hidden" name="operation" value="Search" />
                        <input type="text" name="searchString" placeholder="YOU CAN SEARCH HERE..." />
                        <button class="btn-search"><i class="fa fa-search"></i></button>
                    </form>
                </div>
                <div class="row">
                    <div  class="col-sm-12">
                        <div class="logo">
                            <a href=${system.site.indexPage}><img src="/images/thelook/MilkRun_logo_Black_LG.png" alt="MilkRun Farm Delivery" /></a>
                        </div>
                    </div>
                    <div class="col-sm-10 main-menu-wapper">
                        <a href="#" class="mobile-navigation"><i class="fa fa-bars"></i></a>
                        <nav id="main-menu" class="main-menu">
                            <ul class="navigation">
                                <li><a href=${system.site.indexPage}>Home</a></li>
                                <li class="menu-item-has-children item-mega-menu">
                                    <@pagesMegaMenu/>
                                </li>
                                <li class="menu-item-has-children item-mega-menu">
                                    <@categoryMegaMenu/>
                                </li>
                                <li class="menu-item-has-children">
                                    <a href="#">Products</a>
                                    <ul class="sub-menu">
                                        <!--<li><a href="user-map" >Map of users</a></li>-->
                                    </ul>
                                </li>
                                <li><a href="producers">Producers</a></li>
                                <li><a href="#">How it works</a></li>
                                <li class="menu-item-has-children">
                                    <@blogSubMenu/>
                                </li>
                            </ul>
                        </nav>
                    </div>
                    <div class="col-sm-2">
                        <#if session.user?? >
                            <@showMiniCart session.user thePage/>
                        </#if>
                        <@showSearchPanel/>
                    </div>
                </div>
            </div>
        </div>
    </header>
</#macro>

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

</#macro>