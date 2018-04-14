

<#include "macros-css.ftl">
<#include "macros-js.ftl">
<#include "macros-pageHeader.ftl">
<#include "macros-pageFooter.ftl">


<#macro showCopyright>
    <p>Copyright by ${system.site.Company!"Missing value: Company"}</p>
</#macro>

<#macro showLoginButton>
    <#if session.user?? >
        <a href="/logout"><i class="fa fa-key"></i>LOGOUT ${session.user.username}</a>
    <#else>
        <a href="/login"><i class="fa fa-key"></i>LOGIN</a>
    </#if>
</#macro>

<#macro showUploadButton>
    <#if session.user?? >
        <a href="/upload"><i class="fa fa-key"></i>Upload</a>
    </#if>
</#macro>

<#macro showGalleryButton>
    <a href="/gallery"><i class="fa fa-key"></i>Public Gallery</a>
</#macro>

<#macro showMyGalleryButton>
    <#if session.user?? >
        <a href="/gallery/${session.user.username}"><i class="fa fa-key"></i>My Gallery</a>
    </#if>
</#macro>

<#macro showRegisterButton>
    <#if session.user?? >

    <#else>
        <li><a href="register-account"><i class="fa fa-user"></i>JOIN</a></li>
    </#if>
</#macro>

<#macro categoryMegaMenu>
    <a href="#">Category</a>
    <div class="sub-menu mega-menu style2">
        <div class="row">
            <div class="col-sm-1"></div>
            <div class="col-sm-2">
                <div class="widget">
                    <h3 class="widgettitle">FASHION</h3>
                    <ul>
                        <li><a href="#">MEN'S</a></li>
                        <li><a href="#">WOMAN</a></li>
                        <li><a href="#">KID'S</a></li>
                        <li><a href="#">BAG & SHOES</a></li>
                        <li><a href="#">LOOKBOOK</a></li>
                        <li><a href="#">ACCESORIES</a></li>
                    </ul>
                </div>
            </div>
            <div class="col-sm-2">
                <div class="widget">
                    <h3 class="widgettitle">FURNITURE</h3>
                    <ul>
                        <li><a href="#">COLLECTIONS</a></li>
                        <li><a href="#">ACCESSOREIS</a></li>
                        <li><a href="#">LAMBS</a></li>
                        <li><a href="#">PICTURES</a></li>
                        <li><a href="#">HANDI CRAFT</a></li>
                        <li><a href="#">PRESS ROOM</a></li>
                    </ul>
                </div>
            </div>
            <div class="col-sm-2">
                <div class="widget">
                    <h3 class="widgettitle">ELECTRONIC</h3>
                    <ul>
                        <li><a href="#">TV</a></li>
                        <li><a href="#">PHONE</a></li>
                        <li><a href="#">TABLET</a></li>
                        <li><a href="#">SMART WATCH</a></li>
                        <li><a href="#">WASH MACHINE</a></li>
                        <li><a href="#">AUDIO</a></li>
                    </ul>
                </div>
            </div>
            <div class="col-sm-4">
                <div class="widget">
                    <a href="#"><img src="/images/megamenus/banner5.jpg" alt="" /></a>
                </div>
                <div class="widget">
                    <a href="#"><img src="/images/megamenus/banner6.jpg" alt="" /></a>
                </div>
            </div>
        </div>
    </div>
</#macro>

<#macro pagesMegaMenu>
<a href="#">Pages</a>
<div class="sub-menu mega-menu">
    <div class="row">
        <div class="col-sm-1"></div>
        <div class="col-sm-2">
            <div class="widget">
                <h3 class="widgettitle">Shop pages</h3>
                <ul>
                    <!--
                    <li><a href="shop-fullwidth.html">Shop fullwidth</a></li>
                    <li><a href="shop-with-colection.html">Shop with Collection</a></li>
                    <li><a href="shop-left-sidebar.html">Shop left sidebar</a></li>
                    <li><a href="shop-list-view.html">Shop list view</a></li>
                    -->
                    <li><a href="shop-list-view2">Shop list view 2</a></li>
                    <li><a href="shop-list-view3">Shop list view 3</a></li>

                    <#if session.user?? >
                        <li><a href="cart">Cart page</a></li>
                        <li><a href="checkout">Checkout page</a></li>
                    <#else>
                        <li style opacity="0.6">Cart page</li>
                        <li style opacity="0.6">Checkout page</li>
                    </#if>
                </ul>
            </div>
        </div>
        <div class="col-sm-2">
            <div class="widget">
                <h3 class="widgettitle">Inner page</h3>
                <ul><li><a href="about">About Us</a></li>
                    <li><a href="contact">Contact Us</a></li>
                    <li><a href="faq">Faq</a></li>

                    <li><a href="user-map" >Map of Users</a></li>

                    <#if session.user?? >
                        <li>
                            <a href="user-address-editor" >Edit My Addresses</a>
                        </li>
                        <li>
                            <a href="${session.user.publicHomePageURL}">Visit My Home Page</a>
                        </li>
                        <li>
                            <a href="eater-calendar">My Calendar</a>
                        </li>
                        <#if (session.user.doesRole("Seeder"))>
                            <li>
                                <a href="seeder-home">Edit My Items and Offers</a>
                            </li>
                        </#if>
                        <#if (session.user.doesRole("Admin"))>
                            <li>
                                <a href="milkrun">Next Milk Run</a>
                                <br>
                                <a href="milkruns">Milk Run History</a>

                                <br>
                                <a href="system">System Management</a>
                                <!--
                                    the admin-home page has some remnants of file
                                    upload code that did work.  we're not using it
                                    but let's keep it around for a while
                                -->
                                <!--<br>-->
                                <!--<a href="admin-home">Admin Home</a>-->
                            </li>
                        </#if>
                    </#if>
                </ul>
            </div>
        </div>
        <div class="col-sm-3">
            <div class="widget">
                <a href="#"><img src="/images/megamenus/banner1.jpg" alt="" /></a>
            </div>
            <div class="widget">
                <a href="#"><img src="/images/megamenus/banner2.jpg" alt="" /></a>
            </div>
        </div>
        <div class="col-sm-3">
            <div class="widget">
                <a href="#"><img src="/images/megamenus/banner3.jpg" alt="" /></a>
            </div>
            <div class="widget">
                <a href="#"><img src="/images/megamenus/banner4.jpg" alt="" /></a>
            </div>
        </div>
    </div>
</div>
</#macro>

<#macro blogSubMenu>
<a href="blog-list.html">Blog</a>
<ul class="sub-menu">
    <li><a href="blog-list.html">Blog list</a></li>
    <li><a href="blog-grid-2columns.html">Blog Grid 2 columns</a></li>
    <li><a href="blog-grid-3columns.html">Blog Grid 3 columns</a></li>
    <li><a href="blog-masonry.html">Blog masonry</a></li>
    <li><a href="blog-detail.html">Blog Single post</a></li>
</ul>
</#macro>


<#--
        this adds a button to add an item to the cart
        and reloads the given page
-->
<#macro AddToCartButton offerId pageName>
    <form method="post">
        <input type="hidden" name="operation" value="AddToCart" />
        <input type="hidden" name="offerId" value="${offerId}"/>
        <input type="hidden" name="pageName" value="${pageName}"/>

        <button class="btn-search">Add to Cart</button>

        <div class="btn-group" data-toggle="buttons">
            <label class="btn btn-default" active>
                <input type="radio" name="frequency" value="once" checked="">Once
            </label>
            <label class="btn btn-default">
                <input type="radio" name="frequency" value="weekly">Weekly
            </label>
            <label class="btn btn-default">
                <input type="radio" name="frequency" value="bi-weekly">Bi-weekly
            </label>
        </div>
    </form>
</#macro>

<#macro requestSupport>
    <a href="support"><i class="fa fa-envelope-o"></i> ${system.site.SupportEmail}</a>
</#macro>

<#macro showMiniCart user thePage>
    <div class="mini-cart">
        <a class="icon" href="#">Cart <span class="count">${session.user.cartSize}</span></a>
        <div class="mini-cart-content">
            <ul class="list-cart-product">
                <#list session.user.cartOffers as cartOffer>
                    <li>
                        <div class="product-info">
                            <h5 ><a href="#">${cartOffer.item.shortOne}</a></h5>

                            ${cartOffer.offer.quantity * cartOffer.quantity} ${cartOffer.offer.units} for ${cartOffer.priceAsString}

                            <a href="/removeItemFromCart?offerId=${cartOffer.offer.timeAsString}&thePage=${thePage}" class="remove">remove</a>
                        </div>
                    </li>
                </#list>
            </ul>
            <p class="sub-toal-wapper">
                <span>TOTAL</span>
                <span class="sub-toal">${session.user.cartTotal}</span>
            </p>
            <!--<a href="cart.html" class="btn-view-cart">VIEW SHOPPING CART</a>-->
            <!--<a href="#" class="btn-check-out">PROCEED TO CHECK OUT</a>-->
        </div>
    </div>
</#macro>

<#macro showSearchPanel>
    <div class="search-panel">
        <a class="icon" href="#">Cart</a>
        <div class="mini-cart-content">
            <h4>Search Filters</h4>
            <form class="login"  method="post">
                <p>
                    <label>Enter keywords, empty matches everything</label>
                    <#if session.searchManager?? >
                        <input type="text" name="searchString" placeholder="" value="${session.searchManager.searchParams.keyWords}"/>
                    </#if>
                </p>
                <p>
                    <input type="hidden" name="operation" value="Search" />
                    <input type="submit" class="button" value="Search" />
                </p>
            </form>
        </div>
    </div>
</#macro>

<#macro enterRatingStars>
    <span class="rating">
        <input type="radio" class="rating-input"
               id="rating-input-1-5" name="num-stars" value="5"/>
        <label for="rating-input-1-5" class="rating-star"></label>
        <input type="radio" class="rating-input"
               id="rating-input-1-4" name="num-stars" value="4"/>
        <label for="rating-input-1-4" class="rating-star"></label>
        <input type="radio" class="rating-input"
               id="rating-input-1-3" name="num-stars" value="3"/>
        <label for="rating-input-1-3" class="rating-star"></label>
        <input type="radio" class="rating-input"
               id="rating-input-1-2" name="num-stars" value="2"/>
        <label for="rating-input-1-2" class="rating-star"></label>
        <input type="radio" class="rating-input"
               id="rating-input-1-1" name="num-stars" value="1"/>
        <label for="rating-input-1-1" class="rating-star"></label>
    </span>
</#macro>

<#macro showRatingStars rating>
    <i class="fa fa-star"></i>
    <#if (rating > 1) >
        <i class="fa fa-star"></i>
        <#else>
            <i class="fa fa-star-o"></i>
    </#if>
    <#if (rating > 2) >
        <i class="fa fa-star"></i>
        <#else>
            <i class="fa fa-star-o"></i>
    </#if>
    <#if (rating > 3) >
        <i class="fa fa-star"></i>
        <#else>
            <i class="fa fa-star-o"></i>
    </#if>
    <#if (rating > 4) >
        <i class="fa fa-star"></i>
        <#else>
            <i class="fa fa-star-o"></i>
    </#if>
</#macro>
