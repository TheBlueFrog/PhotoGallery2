<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Leka - Shop List View</title>
    <@styleSheets/>

</head>
<body class="">
    <@pageHeader "shop-list-view2.ftl"/>
    <section class="banner bg-parallax">
        <div class="overlay"></div>
        <div class="container">
            <div class="banner-content text-center">
                <h2 class="page-title">SHOP LIST VIEW</h2>
                <div class="breadcrumbs">
                    <a href="${system.site.indexPage}">Home</a>
                    <a href="#">Shop</a>
                    <span>SHOP LIST VIEW 2</span>
                </div>
            </div>
        </div>
    </section>
    <div class="maincontainer left-sidebar">
        <div class="container">
            <div class="row">
                <div class="col-sm-8 col-md-10 main-content">
                    <!-- Shop slider
                    <div class="shop-slider owl-carousel" data-dots="false" data-autoplay="true" data-nav = "false" data-margin = "0" data-items="1">
                        <a href="#"><img src="/images/shop-slider.jpg" alt="" /></a>
                        <a href="#"><img src="/images/shop-slider.jpg" alt="" /></a>
                    </div>
                    -->
                    <!-- ./Shop slider -->
                    <!-- Sortbar
                    <div class="sortBar">
                        <div class="sortBar-left">
                            <form class="ordering">
                                <select>
                                    <option value="">SORT BY</option>
                                    <option value="">Sort by popularity</option>
                                    <option value="">Sort by average rating</option>
                                    <option value="">Sort by price: low to high</option>
                                </select>
                                <select>
                                    <option value="">Postion</option>
                                    <option value="">Sort by popularity</option>
                                    <option value="">Sort by average rating</option>
                                    <option value="">Sort by price: low to high</option>
                                </select>
                            </form>
                            <div class="display-product-option">
                                <a href="#" class="view-as-grid"><i class="fa fa-th-large"></i></a>
                                <a href="#" class="view-as-list selected"><i class="fa fa-th-list"></i></a>
                            </div>
                        </div>
                        <div class="sortBar-right">
                            <div class="result-count">
                                SHOW ITEMS 1 to 12 of 36 total
                            </div>
                        </div>
                    </div>
                    -->
                    <!-- ./ SortBar -->
                    <!-- List products -->
                    <ul class="products products-list-view">
                        <#list session.searchManager.results as offerRanking>
                            <#assign offer = offerRanking.offer >
                            <li class="product">
                                <div class="row">
                                    <div class="col-sm-4">
                                        <#if (offer.item.numImages > 0) >
                                            <div class="product-thumb">
                                                <a href="single-product?offerId=${offer.timeAsString}"><img src="${offer.item.mainImage.path}" alt=""></a>
                                                <a href="${offer.item.supplier.publicHomePageURL}">
                                                    <h3>${offer.item.supplier.companyName}</h3>
                                                </a>
                                            </div>
                                        <#else>
                                            <#if (offer.item.supplier.numImages > 0) >
                                                <div class="product-thumb">
                                                    <a href="single-product?offerId=${offer.timeAsString}"><img src="${offer.item.supplier.mainImage.path}" alt=""></a>
                                                    <a href="${offer.item.supplier.publicHomePageURL}">
                                                        <h3>${offer.item.supplier.companyName}</h3>
                                                    </a>
                                                </div>
                                            <#else>
                                                <div class="product-thumb">
                                                    <a href="${offer.item.supplier.publicHomePageURL}">
                                                        <h3>${offer.item.supplier.companyName}</h3>
                                                    </a>
                                                </div>
                                            </#if>
                                        </#if>
                                    </div>
                                    <div class="col-sm-8">
                                        <div class="product-info">
                                            <h3><a href="#">${offer.item.shortOne}</a></h3>
                                            <div class="product-star edo-star" title="Rated 1 out of 5">
                                                <@showRatingStars offer.avgRating/>
                                            </div>
                                            <p></p>
                                            <span class="product-price">${session.getQuotedPriceAsString(offer)} for #{offer.quantity} ${offer.units}</span>
                                            <div class="product-desc">
                                                ${offer.item.description}
                                            </div>
                                            <div class="product-button">
                                                <form method="post">

                                                    <input type="hidden" name="operation" value="AddToCart" />
                                                    <input type="hidden" name="offerId" value="${offer.timeAsString}"/>
                                                    <input type="hidden" name="pageName" value="shop-list-view2"/>

                                                    <label for="quantity">Quantity</label>
                                                    <input id="quantity" name="quantity" type="number" min="1" max="10" value="1"/>
                                                    <p></p>
                                                    <input type="radio" name="frequency" value="once" checked/> Once&nbsp;&nbsp;
                                                    <input type="radio" name="frequency" value="weekly"/> Weekly&nbsp;&nbsp;
                                                    <input type="radio" name="frequency" value="bi-weekly"/> Bi-weekly&nbsp;&nbsp;
                                                    <br>
                                                    <button class="button-add-to-cart">Add to Cart</button>
                                                    <br>
                                                </form>
                                                <#-- this doesn't work any more
                                                <@AddToCartButton offer.id "shop-list-view"/>
                                                -->
                                                <!--
                                                    <a href="#" class="button-compare">Compare</a>
                                                    <a href="#" class="button-wishlist">Wishlist</a>
                                                -->
                                            </div>
                                            <!--
                                            <#if (offer.avgRating > 0.0) >
                                                Rating ----  ${offer.avgRating}  -------
                                            <#else>
                                                Rating ----  Not yet rated  -------
                                            </#if>
                                            -->
                                    </div>
                                    </div>
                                </div>
                            </li>
                        </#list>
                    </ul>
                    <nav class="pagination">
                        <ul>
                            <li class="active"><a href="#">1</a></li>
                            <li><a href="#">2</a></li>
                            <li><a href="#">3</a></li>
                            <li><a href="#">4</a></li>
                            <li><a href="#">5</a></li>
                            <li><a href="#">Next</a></li>
                        </ul>
                    </nav>
                    <!-- ./ List Products -->
                </div>
                <!-- Sidebar -->
                <div class="col-sm-4 col-md-2 sidebar">
                    <!-- Product category -->
                    <div class="widget widget_product_categories">
                        <h2 class="widget-title">By Categories</h2>
                        <ul class="product-categories">
                            <li class="cat-parent current-cat-parent">
                                <a href="#">Accessories</a>
                                <ul class="children">
                                    <li class="current-cat"><a href="#">Men</a></li>
                                    <li><a href="#">Women</a></li>
                                    <li><a href="#">Kids</a></li>
                                </ul>
                            </li>
                            <li class="cat-parent">
                                <a href="#">Handbags</a>
                                <ul class="children">
                                    <li><a href="#">Men bags</a></li>
                                    <li><a href="#">Women bags</a></li>
                                </ul>
                            </li>
                            <li><a href="#">Mencare</a></li>
                            <li><a href="#">Watches</a></li>
                            <li><a href="#">Clothings</a></li>
                            <li><a href="#">Jackets</a></li>
                            <li><a href="#">Jeans</a></li>
                            <li><a href="#">T-Shirts</a></li>
                            <li><a href="#">Shoes</a></li>
                        </ul>
                    </div>
                    <!-- ./Product category -->
                    <!-- Filter color
                    <div class="widget widget_layered_nav">
                        <h2 class="widget-title">BY COLORS</h2>
                        <ul>
                            <li><a href="#">RED</a></li>
                            <li><a href="#">BLUE</a></li>
                            <li><a href="#">CYAN</a></li>
                            <li><a href="#">ORANGER</a></li>
                            <li><a href="#">BLACK & WHITE</a></li>
                            <li><a href="#">PURPULE</a></li>
                        </ul>
                    </div>
                    -->
                    <!-- ./Filter color -->

                    <!-- Filter price
                    <div class="widget widget_price_filter">
                        <h2 class="widget-title">BY PRICES</h2>
                        <div class="price_slider_wrapper">
                            <div class="amount-range-price">$50 - $350</div>
                            <div data-label-reasult="" data-min="0" data-max="500" data-unit="$" class="slider-range-price" data-value-min="50" data-value-max="350"></div>
                            <button class="button">Filter</button>
                        </div>
                    </div>
                    -->
                    <!-- ./Filter price -->
                    
                    <!-- Compare products
                    <div class="widget yith-woocompare-widget">
                        <h2 class="widget-title">COMPARE PRODUCTS</h2>
                        <div class="no-product">
                            NO PRODUCTS HAVE COMPARE
                        </div>
                    </div>
                    -->
                    <!-- ./Compare products -->
                    
                    <!-- Product tags
                    <div class="widget widget_product_tag_cloud">
                        <h2 class="widget-title">POPULAR TAGS</h2>
                        <div class="tagcloud">
                            <a href="#">Cotton</a>
                            <a href="#">Leggings</a>
                            <a href="#">Men</a>
                            <a href="#">Shirt</a>
                            <a href="#">T-shirt</a>
                            <a href="#">COSMETIC</a>
                            <a href="#">SOFT WEAR</a>
                            <a href="#">ACCESSORIES</a>
                            <a href="#">LIFE STYLE</a>
                        </div>
                    </div>
                    -->
                    <!-- ./Product tags -->
                    <!-- Product tags
                    <div class="widget widget_custom_image">
                        <a href="#"><img src="/images/b/b9.jpg" alt="" /></a>
                    </div>
                    -->
                    <!-- ./Product tags -->
                </div>
                <!-- ./Sidebar -->
            </div>
            
            
        </div>
    </div>
    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>

</body>
</html>