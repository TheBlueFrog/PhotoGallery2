

<#macro mainDropDownMenu>
    <ul class="dropdown-menu">
        <#if session.getUser().doesRole("InDevelopment") >
            <li><a href="/my-orders-grid">Order History Grid</a></li>
        </#if>
        <li><a href="/eater-address-editor" ><strong>Profile</strong></a></li>
        <li><a href="/order-history" ><strong>Orders</strong></a></li>
        <li><a href="/user-payment" ><strong>Payments</strong></a></li>

        <#if false >
            <!-- these are not yet supported -->
            <li><a href="/user-image-manager" ><strong>Manage Images</strong></a></li>
            <li><a href="${session.user.publicHomePageURL}"><strong>Visit My Home Page</strong></a></li>
            <li><a href="/eater-calendar"><strong>My Calendar</strong></a></li>
        </#if>

        <#if (session.user.doesRole("Seeder"))>
            <li><a href="/seeder-milkrun?milkRunId=${MilkRunDB.findOpen().getId()}" ><strong>My MilkRuns</strong></a></li>
            <li><a href="/seeder-update-prices" ><strong>Manage Items</strong></a></li>
            <li><a href="/user-image-manager" ><strong>Manage Images</strong></a></li>
        </#if>

        <li><a href="/logout"><strong>LOGOUT</strong></a></li>

        <#if (UserRole.isAnAdmin(session.user.getId()))>
            <li><a href="/admin"><strong>Admin Panel</strong></a></li>
        </#if>
    </ul>
</#macro>


<#macro topOfPageHeader>

    <div class="top-header"
        <#if ! system.site.production >
             style="background-color:#FF9999"
        </#if>
    >
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
                            <a data-toggle="dropdown" href="#"><i class="fa fa-cog"></i>My Account</a>
                            <@mainDropDownMenu />
                        </li>
                    </#if>
                </ul>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2"></div>
            <div class="col-sm-8">
                <#if (system.getNotices(session)?size > 0) >
                    <div class="well" style="background-color: lightpink; text-align:center">
                        <h5>
                            <#list system.getNotices(session) as notice >
                                ${notice.getBody()}
                                <#if notice?has_next> <p>&nbsp;</p> </#if>
                            </#list>
                        </h5>
                    </div>
                </#if>

                <#if session.getUser()?? >
                    <#assign messageCount = UserNote.findByUserIdAndColorAndStatusOrderByTimestampDesc(
                                session.getUser().getId(),
                                    "Private",
                                    "Open")?size >
                    <#if (messageCount > 0) >
                        <div class="well" style="background-color: lightpink; text-align:center">
                            <h5>
                                <#if (messageCount > 1) >
                                    <a href="/eater-address-editor?profileCurTab=messageTab">You have ${messageCount} messages</a>
                                <#else>
                                    <a href="/eater-address-editor?profileCurTab=messageTab">You have a message</a>
                                </#if>
                            </h5>
                        </div>
                    </#if>
                </#if>
            </div>
            <div class="col-sm-2"></div>
        </div>
    </div>
</#macro>

<#macro newTopOfPageHeader backURL >
    <header class="header header-style2">
        <@topOfPageHeader/>
        <div class="main-header">
            <div class="container main-header-inner">
                <div id="form-search" class="form-search">
                    <form method="post" action="/shop-list-view2">
                        <#if session.searchManager?? >
                            <input type="text" name="searchString" placeholder="YOU CAN SEARCH HERE..." value="${session.searchManager.searchParams.keyWords}"/>
                        <#else>
                            <input type="text" name="searchString" placeholder="YOU CAN SEARCH HERE..." />
                        </#if>

                        <input type="hidden" name="operation" value="Search" />
                        <button type="submit" class="btn-search"><i class="fa fa-search"></i></button>
                    </form>
                </div>
                <div class="row">
                    <div class="col-sm-12 col-md-12 col-lg-3">
                        <div class="logo" >
                            <a href="/"><img src="/images/thelook/MilkRun_logo_Black_LG.png" alt="MilkRun Farm Delivery" /></a>
                        </div>
                    </div>
                    <div class="col-sm-10 col-md-10 col-lg-7 ">
                        <div class="col-sm-2"></div>
                        <div class="col-sm-3" >
                            <br>
                            <#if (session.user.doesRole("Seeder"))>
                                <a href="/seeder-milkrun?milkRunId=${MilkRunDB.findOpen().getId()}" ><strong>HOME</strong></a>
                            <#else >
                                <a href="/index3" class="btn btn-link"><strong>HOME</strong></a>
                            </#if>
                        </div>
                        <div class="col-sm-3">
                            <br>
                            ${backURL}
                        </div>
                        <div class="col-sm-3"></div>
                    </div>
                    <div class="col-sm-2 col-md-2">
                        <#if session.user?? >
                            <@showMiniCart session.user ""/>
                        </#if>
                        <@showSearchPanel/>
                    </div>
                </div>
            </div>
        </div>
    </header>
</#macro>

<#macro pageHeader thePage>
    <header class="header header-style2">
        <@topOfPageHeader/>
        <div class="main-header">
            <div class="container main-header-inner">
                <div id="form-search" class="form-search">
                    <form method="post" action="/shop-list-view2">
                        <#if session.searchManager?? >
                            <input type="text" name="searchString" placeholder="YOU CAN SEARCH HERE..." value="${session.searchManager.searchParams.keyWords}"/>
                        <#else>
                            <input type="text" name="searchString" placeholder="YOU CAN SEARCH HERE..." />
                        </#if>

                        <input type="hidden" name="operation" value="Search" />
                        <button type="submit" class="btn-search"><i class="fa fa-search"></i></button>                        
                    </form>
                </div>
                <div class="row">
                    <div class="col-sm-12 col-md-12 col-lg-3">
                        <div class="logo">
                            <a href="/"><img src="/images/thelook/MilkRun_logo_Black_LG.png" alt="MilkRun Farm Delivery" /></a>
                        </div>
                    </div>
                    <div class="col-sm-10 col-md-10 col-lg-7 main-menu-wapper">
                        <a href="#" class="mobile-navigation"><i class="fa fa-bars"></i></a>
                        <nav id="main-menu" class="main-menu">
                            <ul class="navigation">
                                <li><a href="/">Home</a></li>
                                <li class="menu-item-has-children item-mega-menu">
                                    <@categoryMegaMenu/>
                                </li>
                                <li class="menu-item-has-children item-mega-menu">
                                    <a href="how-it-works">How it works</a>

                                    <div class="sub-menu mega-menu">
                                        <div class="row">
                                            <div class="col-sm-1"></div>
                                            <div class="col-sm-2">
                                                <div class="widget">
                                                    <h3 class="widgettitle">How it works</h3>
                                                    <ul>
                                                        <li><a href="/how-it-works">How It Works</a></li>
                                                        <li><a href="/first-login">Getting Started</a></li>                                                         
                                                    </ul>
                                                </div>
                                            </div>
                                            <div class="col-sm-1"></div>
                                            <div class="col-sm-4"></div>
                                        </div>
                                    </div>
                                </li>
                                <li><a href="producers">Our Producers</a></li>
                                <li class="menu-item-has-children item-mega-menu">
                                    <a href="/about">About Us</a>
                                    <div class="sub-menu mega-menu">
                                        <div class="row">
                                            <div class="col-sm-1"></div>
                                            <div class="col-sm-2">
                                                <div class="widget">
                                                    <h3 class="widgettitle">About Us</h3>
                                                    <ul>
                                                        <li><a href="/about">About</a></li>
                                                        <li><a href="/contact">Contact</a></li>
                                                        <li><a href="/faq">FAQ</a></li>                                                        
                                                    </ul>
                                                </div>
                                            </div>
                                            <div class="col-sm-1"></div>
                                            <div class="col-sm-4"></div>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </nav>
                    </div>
                    <div class="col-sm-2 col-md-2">
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

<#macro pageHeader3>
<header class="header header-style2"
        <#if system.site.production >
        >
        <#else>
            style="background-color:#FF9999">
        </#if>

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
                        <a data-toggle="dropdown" href="#"><i class="fa fa-cog"></i>My Account</a>
                        <@mainDropDownMenu />
                    </li>
                </#if>
            </ul>
        </div>
    </div>
</header>
</#macro>
