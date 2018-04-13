

<#include "macros-css.ftl">
<#include "macros-js.ftl">
<#include "macros-pageHeader.ftl">
<#include "macros-pageFooter.ftl">

    <style>
        td {
            text-align: left;
            vertical-align: text-top;
        }
        .td-total {
            text-align: right;
        }
    </style>

<#macro messageHeader message >
    <@messageHeader2 message false />
</#macro>

<#macro messageHeader2 message pink >
    <#if (message?length > 0) >
        <div class="container">
            <div class="row">
                <div class="col-sm-2"></div>
                <div class="col-sm-8" style="text-align:center">
                    <br>
                    <h3 <#if pink > style="background-color: hotpink" </#if> >
                        ${message}
                    </h3>
                    <p></p>
                </div>
                <div class="col-sm-2"></div>
            </div>
        </div>
    </#if>
</#macro>



<#macro showCopyright>
    <p>Copyright by ${system.site.Company!"Missing value: Company"}</p>
</#macro>

<#macro showLoginButton>
    <#if session.user?? >        
        <i class="fa fa-key"></i> ${session.user.name}
    <#else>
        <#-- force login over https -->
        <#if Website.getProduction() >
            <a href="https://localmilkrun.com/login"><i class="fa fa-key"></i>LOGIN</a>
        <#else>
            <a href="/login"><i class="fa fa-key"></i>LOGIN</a>
        </#if>
    </#if>
</#macro>

<#macro showRegisterButton>
    <#if session.user?? >

    <#else>
        <li><a href="/service-area"><i class="fa fa-user"></i>JOIN</a></li>
    </#if>
</#macro>

<#macro showMyStuffButton>
    <#if session.user?? >
    <#else>
    </#if>
</#macro>

<#macro maybeStartNewColumn count >
    <#assign count = count + 1 >
    <#if (count % 4) == 0 >
                </ul>
            </div>
        </div>
        <div class="col-sm-2">
            <div class="widget">
                <ul>
    </#if>
</#macro>

<#macro categoryMegaMenu>
    <a href="/shop-list-view2">Shop</a>
    <div class="sub-menu mega-menu">
        <div class="row">
            <div class="col-sm-1"></div>
            <div class="col-sm-2">
                <div class="widget">
                    <ul>
                        <#assign count = 0 >
                        <#if session.user?? >
                            <@maybeStartNewColumn count />
                            <li > <a href="/shop-list-view2/category/my-favorites">My Favorites</a></li>
                        </#if>

                        <@maybeStartNewColumn count />
                        <li > <a href="/shop-list-view2/category/favorites">Favorites</a></li>
                        <@maybeStartNewColumn count />
                        <li > <a href="/shop-list-view2/category/hot-items">Most Popular</a></li>

                        <#if session.user?? && session.getUser().doesRole("InDevelopment") >
                            <@maybeStartNewColumn count />
                            <li> <a href="/shop-list-view2/category/my-history">My History</a> </li>
                        </#if>

                        <@maybeStartNewColumn count />
                        <li><a href="/shop-list-view2/category/none">All Products </a></li>

                        <#list ItemCategory.getItemCategories() as category>
                            <@maybeStartNewColumn count />
                            <li><a href="/shop-list-view2/category/${category}">${category} </a></li>
                        </#list>
                    </ul>
                </div>
            </div>
            <div class="col-sm-2">
                
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
                    <h3 class="widgettitle">My MilkRun</h3>
                    <ul>                    
                        <li><a href="shop-list-view2">Shop list view 2</a></li>
                        <li><a href="shop-list-view2">Shop list view 3</a></li>

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
        <#-- we have a session user, what kind? -->
        <#if ! StripeCustomer.findByUserId(user.getId())?? >
            <a class="icon" href="/cart-no-cc">Cart <span class="count">${session.user.cartSize}</span></a>
        <#elseif ! StripeCustomer.isChargeable(user.getId()) >
            <a class="icon" href="/cart-cc-not-chargeable">Cart <span class="count">${session.user.cartSize}</span></a>
        <#else >
            <a class="icon" href="/cart-cc">Cart <span class="count">${session.user.cartSize}</span></a>
        </#if>
    </div>
</#macro>

<#macro showSearchPanel>
    <div class="search-panel">
        <div class="icon-search">
            <span class="icon"><i class="fa fa-search"></i></span>
        </div>
    </div>
</#macro>

<#--<#if session.user?? >-->
<#--<div class="icon-search-fav">-->
    <#--<a class="btn" href="/shop-list-view2/category/favorites">-->
        <#--<i class="fa fa-heart" style="font-size: 18pt"></i></a>-->
<#--</div>-->
<#--</#if>-->

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
    <#if (rating > 0) >
        <i class="fa fa-star"></i>
        <#else>
            <i class="fa fa-star-o"></i>
    </#if>
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

<#macro productModal>

    <div id="modalDetail" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog add-to-cart-wrapper" role="document">
            <!-- <form method="post">
                <input type="hidden" name="operation" value="AddToCart" />
                <input type="hidden" name="offerId" id="modalOfferId" />
                <input type="hidden" name="pageName" value="shop-list-view2"/> -->
                
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title" id="modalTitle">Modal title</h4>
                    </div>
                    <div class="modal-body" id="modalBody">

                        <div class="row alert-message-container">
                            <div class="alert alert-success alert-dismissible" role="alert">
                                <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                You have added <span class="alert-message"></span> to your cart.
                            </div>
                        </div>

                        <div id="modalDescription"></div>
                        
                        <br />
                        <label for="quantity">Quantity</label>
                        <input id="quantity" name="quantity" type="number" min="1" max="10" value="1"/>
                        <input type="hidden" name="frequency" value="once" />
                        <!-- <br /><br />
                        <div class="btn-group" data-toggle="buttons">
                            <label class="btn btn-default active">
                                <input type="radio" id="frequency1" name="frequency" value="once" checked="checked">Once
                            </label>
                            <label class="btn btn-default">
                                <input type="radio" id="frequency2" name="frequency" value="weekly">Weekly
                            </label>
                            <label class="btn btn-default">
                                <input type="radio" id="frequency3" name="frequency" value="bi-weekly">Bi-weekly
                            </label>
                        </div> -->
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>                
                        <#if session.user?? > 
                            <button type="button" class="btn btn-primary button-add-to-cart add-to-cart">Add To Cart</button>
                        <#else>
                            <a href="/login" class="btn btn-primary button-add-to-cart">LOGIN TO ADD</a>
                        </#if>
                        
                    </div>
                </div><!-- /.modal-content -->
            <!-- </form> -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
</#macro>

<#macro analytics>
    <!-- Global site tag (gtag.js) - Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=UA-109057402-1"></script>
    <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());

        gtag('config', 'UA-109057402-1');
    </script>
</#macro>

<#macro pastStripeCharges user >
    <table >
        <thead>
        <tr>
            <th width="10%">Status</th>
            <th width="15%">Date</th>
            <th width="50%">Description</th>
            <th width="20%" class="td-total">Amount</th>
        </tr>
        </thead>
        <tbody>
            <#assign customer = StripeCustomer.findByUserId(user.getId()) >
            <#assign total = 0 >
            <#list StripeCharge.findByUserIdOrderByTimestampDesc(user.getId()).getCharges()
                    as charge >
                <tr >
                    <td
                        <#if charge.status != "succeeded" > style="color: crimson" </#if>
                    >
                        ${charge.status}
                    </td>
                    <td>
                        <a href="/stripe-charge-details?userId=${user.getId()}&id=${charge.getId()}">
                           ${Util.formatTimestamp(charge.getCreated()*1000, "MMM d, YY HH:mm")}
                        </a>
                    </td>
                    <td >
                        ${charge.getDescription()}</a>
                    </td>
                    <td >
                        <span class="td-total">
                            ${String.format("$ %.2f", StripeCharge.toDollars(charge.getAmount()))}
                        </span>
                    </td>
                </tr>
            </#list>
            <tr>
                <td></td>
                <td></td>
                <td class="td-total">${String.format("$ %.2f", total)}</td>
            </tr>
        </tbody>
    </table>
</#macro>
