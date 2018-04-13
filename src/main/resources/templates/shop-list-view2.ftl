<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<#include "macros-js-inc-dec-qty.ftl" >

<head>
    <@analytics />

    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Shop</title>
    <@styleSheets/>
    <style>
        .mine4 {
            padding: 0pt;
            margin: 0pt;font-size: 20px;
            text-align: center;
            color: #000000;
            border: 0pt;
        }
    </style>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script>
        var maxProd = ${session.searchManager.getNumResults()};
        var curProd = 0;
        $(function() {

            var x = "#product-" + curProd;
            $(x).show();

            $("#prev-button").click(function(){
                var x = "#product-" + curProd;
                $(x).hide();
                curProd--;
                if (curProd < 0) { curProd = 0; }
                x = "#product-" + curProd;
                $(x).show();
            });
            $("#next-button").click(function(){
                var x = "#product-" + curProd;
                $(x).hide();
                curProd++;
                if (curProd >= maxProd) { curProd = maxProd - 1; }
                x = "#product-" + curProd;
                $(x).show();
            });

            // even out the columns
            var pHeight = 0;
            $(".product").each(function(idx) {
                if($(this).height() > pHeight)
                    pHeight = $(this).height();                    
            });
            $(".product").height(pHeight);
        });
    </script>
</head>
<body class="">

    <#assign openMilkRunId = MilkRunDB.findOpen().getId() >

    <@pageHeader "shop-list-view2.ftl"/>

    <section class="banner banner-short bg-parallax">
        <div class="overlay"></div>
        <div class="container">
            <div class="banner-content text-center">
                <h2 class="page-title">SHOP</h2>
                <div class="breadcrumbs">
                    <a href="#">Home</a>
                    <span>Shop</span>
                </div>
            </div>
        </div>
    </section>

    <#--<@messageHeader />-->

    <div class="maincontainer left-sidebar">
        <div class="container">
            <div class="row">

                <div class="col-sm-9 col-md-10 main-content">

                    <!-- List products -->
                    <ul class="products row">

                        <#assign index = 0>

                        <#list session.searchManager.getResults() as offerRanking>
                            <#assign offer = offerRanking.getOffer() >
                            <#assign item = offer.getItem() >
                            <#assign supplier = item.getSupplier() >
                            <#assign index = index + 1>                            
                            <#assign available = 1000 >
                            <#if offer.getAvailability()?? >
                                <#assign available = offer.getAvailability().getAvailableQuantity() >                                        
                            </#if>

                            <li id="product-${index}" class="product col-sm-6 col-md-4"
                                data-toggle="tooltip"
                                title="${item.getDescription()}">

                                <#if item.getImage("Main")?? >
                                    <#assign theImage = item.getImage("Main") >

                                    <div class="product-thumb">
                                        <a href="single-product?offerId=${offer.getTimeAsString()}">
                                            <img src="${theImage.getPath()}" alt="">
                                        </a>                                        
                                    </div>
                                <#else>
                                    <#if supplier.getImage("Main")??>
                                        <#assign theImage = supplier.getImage("Main") >
                                        <div class="product-thumb">
                                            <a href="single-product?offerId=${offer.getTimeAsString()}">
                                                <img src="${theImage.getPath()}" alt="">
                                            </a>                                        
                                        </div>
                                    <#else>
                                        <div class="product-thumb product-thumb-nopic text-center">
                                            <p><a href="single-product?offerId=${offer.getTimeAsString()}">
                                                <span class="mine4">${supplier.getCompanyName()}</span>
                                            </a></p>
                                        </div>
                                    </#if>
                                </#if>
                                
                                <div class="product-info">
                                    <h3><a href="single-product?offerId=${offer.getTimeAsString()}">${item.getShortOne()}</a></h3>

                                    <#if (available > 0) >
                                        <span class="product-price">${offer.getOurSellPriceAsString()} per ${offer.units}</span>

                                        <#if session.user?? >
                                            <@quantitySteppersNoDiv offer getCartOfferQuantity(offer.getTime(), session.user.getId(), openMilkRunId) />
                                        <#else>
                                            <@quantitySteppersNoDiv offer 0 />
                                        </#if>
                                    <#else>
                                        Not Available
                                    </#if>
                                </div>

                                <div id="desc_${offer.timeAsId}" style="display:none;">${item.getDescription()}</div>
                                <div class="text-center">
                                    <a href="${supplier.getPublicHomePageURL()}">${supplier.getCompanyName()}</a>
                                </div>

                            </li>
                        </#list>
                    </ul>
                    <!-- <nav class="pagination">
                        <ul>
                            <li><button id="prev-button">Prev</button></li>
                            <li class="active"><a href="#">1</a></li>
                            <li><a href="#">2</a></li>
                            <li><a href="#">3</a></li>
                            <li><a href="#">4</a></li>
                            <li><a href="#">5</a></li>
                            <li><button id="next-button">Next</button></li>
                        </ul>
                    </nav> -->
                    <!-- ./ List Products -->
                </div>


                <!-- Sliderbar -->
                <div class="col-sm-3 col-md-2 sidebar">
                    <!-- Product category -->
                    <div class="widget widget_product_categories">
                        <h2 class="widget-title">By Categories</h2>
                        <ul class="product-categories">

                            <#if session.user?? >
                                <li
                                <#if session.getSearchManager().isCurrentCategory("my-favorites")>
                                    class="current-cat"
                                </#if>
                                >
                                <a href="/shop-list-view2/category/my-favorites">My Favorites</a></li>
                            </#if>
                            <li
                                <#if session.getSearchManager().isCurrentCategory("favorites")>
                                        class="current-cat"
                                </#if>
                            >
                                <a href="/shop-list-view2/category/favorites">Favorites</a>
                            </li>
                            <li
                                <#if session.getSearchManager().isCurrentCategory("hot-items")>
                                        class="current-cat"
                                </#if>
                            >
                                <a href="/shop-list-view2/category/hot-items">Most Popular</a>
                            </li>
                            <#if session.user?? && session.getUser().doesRole("InDevelopment") >
                                <li
                                    <#if session.getSearchManager().isCurrentCategory("my-history")>
                                            class="current-cat"
                                    </#if>
                                >
                                    <a href="/shop-list-view2/category/my-history">My History</a>
                                </li>
                            </#if>

                            <li><a href="/shop-list-view2/category/none">Clear Filters</a></li>

                            <#list ItemCategory.getItemCategories() as category>

                                <!-- the original html code used class current-cat to distinquish
                                    the currently selected category, doesn't seem to do anything
                                -->
                                <#assign itemClass = "">
                                <#if session.getSearchManager().isCurrentCategory(category)>
                                    <#assign itemClass = " class=\"current-cat\"" >
                                </#if>

                                <li ${itemClass}><a href="/shop-list-view2/category/${category}">${category}</a></li>
                            </#list>                

                        </ul>
                    </div>                   
                </div>
                <!-- ./Sidebar -->
            </div>
        </div>
    </div>

    <@productModal/>
    
    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>

    <@incDecOfferQty 0 />

</body>
</html>