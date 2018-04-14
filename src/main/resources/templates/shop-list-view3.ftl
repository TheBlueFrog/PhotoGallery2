<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>${system.site.Company}</title>
    <@styleSheets3/>

    <style>

.offer-row-first{
    padding: 5px 0 0 0;
    margin: 15px 0 5px 0;
    overflow: hidden;
    border-top: 2px solid #e0e0e0;
    border-bottom: 2px solid #e0e0e0;
    }
.offer-row {
    padding: 0;
    margin: 0;
    overflow: hidden;
    border-bottom: 2px solid #e0e0e0;
    margin-bottom: 5px;
}
.offer-row-last{
    padding: 0;
    margin: 0;
    overflow: hidden;
    margin-bottom: 5px;
    }
.offer-row-first .offer-name,
.offer-row-last .offer-name,
.offer-row .offer-name{
    padding: 3px 0;
    margin: 0;
    font-size: 17px;
    line-height: 17px;
    float: left;
}
.offer-row-first .offer-company,
.offer-row-last .offer-company,
.offer-row .offer-company{
    display: block;
    padding: 5px 0 3px;
    margin: 0;
    font-size: 15px;
    text-align: right;
    line-height: 15px;
    float: right;
}
.offer-row-first .offer-description,
.offer-row-last .offer-description,
.offer-row .offer-description{
    padding: 3px 0 3px;
    margin: 0;
    font-size: 13px;
    line-height: 13px;
}
.offer-row-first .offer-frequency,
.offer-row-last .offer-frequency,
.offer-row .offer-frequency{
    margin-bottom: 0;
    font-size: 14px;
}
.offer-row-first .cart-quantity,
.offer-row-last .cart-quantity,
.offer-row .cart-quantity{
    margin-bottom: 0;
    font-size: 14px;
}
.offer-row-first .offer-quantity,
.offer-row-last .offer-quantity,
.offer-row .offer-quantity{
    margin-bottom: 0;
    font-size: 14px;
}
.offer-row-first .offer-price,
.offer-row-last .offer-price,
.offer-row .offer-price{
    display: inline;
    font-size: 14px;
    text-align: right;
    margin-bottom: 5px;
}


        form.milkRunRecord-search-form .milkRunRecord-top-controls {
            margin 13px 2px 2px;
            padding: 2px;
        }
        .milkRunRecord-search-left{
            margin: 20px 10px 2px 0;
            padding: 0 0 10px 0;
            width: 50%;
            float: left;
        }
        .milkRunRecord-search-right{
            margin: 30px 0 20px 0;
            padding: 0;
            width: 40%;
            float: right;
        }
        .milkRunRecord-search-left h5 {
            margin: 0;
            padding: 0;
        }
        form.milkRunRecord-search-form label{
            font-size: 11px;
            margin: 0px 15px 0px 0px;
            padding: 0 10px 0 10;
            color: #303030;
        }
        form.milkRunRecord-search-form input[type="text"] {
            border: 1px solid #e0e0e0;
            margin: 0 0px;
            padding: 0px 0px 0px 10px;
            font-size: 15px;
            color: #303030;
            width: 80%;
        }
        form.milkRunRecord-search-form .milkRunRecord-search-checkbox {
            margin: 5px 10px 0 60px;
            padding: -5px 0 0 0px;
            float: left;
        }
        form.milkRunRecord-search-form input[type="checkbox"] {
            margin: 5px 5px 5px 5px;
            padding: 0;
            float: left;
        }
        .offer-row-first .milkRunRecord-button,
        .offer-row-last .milkRunRecord-button,
        .offer-row .milkRunRecord-button {
            float: right;
            color: inherit;
            font-size: 11px;
            padding: 2px 12px;
            display: inline-block;
            margin 0;
            margin-top: 3px;
            border-top: 1px solid #e9e9e9;
            border-bottom: 1px solid #e9e9e9;
            }
        form.milkRunRecord-search-form .milkRunRecord-button{
            float: right;
            color: inherit;
            font-size: 11px;
            padding: 2px 12px;
            display: inline-block;
            margin 0;
            margin-top: 15px;
            border-top: 1px solid #e9e9e9;
            border-bottom: 1px solid #e9e9e9;
        }

        .mini-cart .mini-cart-content,
        .search-panel .mini-cart-content {
            background-color: #f0f0f0
        }

        .cart-button {
            color: inherit;
            border-top: 1px solid #e9e9e9;
            border-bottom: 1px solid #e9e9e9;
            padding: 2px 12px;

            position: absolute;
            top: 30px;
            right: 35px;
            width: 80px;
            height: 50px;
            text-align: center;
            display: block;
        }
}

</style>

</head>
<body class="">
    <@pageHeader3 "shop-list-view3.ftl"/>

    <section class="banner banner-about bg-parallax">
        <div class="overlay">
        </div>
        <div class="container">
            <div class="banner-content text-center">
                <h2 class="page-title"><img src="/images/thelook/MilkRun_logo_white.png" alt="MilkRun Farm Delivery" /></h2>
            </div>
        </div>
    </section>

    <div class="container">
        <div class="row">
            <div class="col-sm-4 col-md-10 main-content">
                <form class="milkRunRecord-search-form" method="post">
                    <div class="milkRunRecord-top-controls">
                        <div class="milkRunRecord-search-left">
                            <h5>Keyword Search</h5>
                            <label>Offer keywords, empty string matches everything</label>
                            <br>
                            <input type="text" name="searchString" placeholder="" value="${session.searchManager.searchParams.keyWords}"/>
                        </div>
                        <div class="milkRunRecord-search-right">
                            <div class="milkRunRecord-search-checkbox">
                                <#if session.searchManager.caseSensitive >
                                    <input type="checkbox" name="caseSensitive" value="caseSensitive" checked/>Case sensitive
                                    <#else>
                                        <input type="checkbox" name="caseSensitive" value="caseSensitive"/>Case Sensitive
                                </#if>
                                <br>
                                <#if session.user?? >
                                    <!-- if no logged in user, no past orders -->
                                    <#if session.searchManager.pastOrders >
                                        <input type="checkbox" name="pastOrders" value="pastOrders" checked/>Past Orders
                                        <#else>
                                            <input type="checkbox" name="pastOrders" value="pastOrders"/>Past Orders
                                    </#if>
                                </#if>
                            </div>
                            <input type="hidden" name="operation" value="Search" />
                            <input type="submit" class="milkRunRecord-button" value="Search" />
                        </div>
                    </div>
                </form>
            </div>
            <div class="col-sm-1 col-md-2">
                <#if session.user?? >
                    <!--<a class="icon" href="cart3.html"><img src="images/icon-cart.png"><span class="count">${session.user.cartSize}</span></a>-->
                    <a href="cart3">
                        <button class="cart-button">
                            <img src="images/thelook/Header_logo.png"/>
                            ${session.user.cartSize}
                        </button>
                    </a>
                </#if>
            </div>
        </div>
        <div class="container">
            <div class="col-sm-12 col-md-12 main-content">
                <#list session.searchManager.results as offerRanking>
                    <#assign offer = offerRanking.offer >

                    <#if offerRanking?is_first >
                        <div class="row offer-row-first">
                    <#else>
                        <#if offerRanking?is_last >
                            <div class="row offer-row-last">
                        <#else>
                            <div class="row offer-row">
                        </#if>
                    </#if>

                        <#assign offer = offerRanking.offer >

                        <div class="col-sm-1 offer-rating">
                            <#if offerRanking.haveMatches() >
                                <#list offerRanking.matches as score >  <!-- in range 0..1 -->
                                    <#assign v = (40-((score * 40) + 1)) >
                                    <svg height="40" width="5">
                                        <line x1="0" y1="${v}" x2="0" y2="40" style="stroke:rgb(255,0,0);stroke-width:5" />
                                    </svg>
                                </#list>
                            </#if>
                        </div>
                        <div class="col-sm-4">
                            <div>
                                <span class="offer-name">${offer.item.shortOne}</span>
                                <span class="offer-company">${offer.item.supplier.companyName}</span>
                                <div style="clear:both;"></div>
                            </div>
                            <div class="offer-description">${offer.item.description}</div>
                        </div>

                        <div class="col-sm-2 offer-price">
                            <#if offer.quantity == 1 >
                                ${session.getQuotedPriceAsString(offer)} per ${offer.units}
                            <#else>
                                ${session.getQuotedPriceAsString(offer)} per ${offer.quantity} ${offer.units}
                            </#if>
                            <#if (system.site.devEnv) >
                                <br> <span style="color:deeppink">${offer.priceAsString}</span>
                            </#if>
                        </div>
                        <form method="post">
                            <div class="col-sm-2 cart-quantity">
                                Quantity
                                <input id="quantity" name="quantity" type="number" min="1" max="10" value="1"/>
                            </div>
                            <div class="col-sm-2 cart-frequency">
                                <input type="radio" name="frequency" value="once" checked/> Once <br>
                                <input type="radio" name="frequency" value="weekly"/> Weekly
                                <input type="radio" name="frequency" value="bi-weekly"/> Bi-weekly
                            </div>
                            <#if session.user?? >
                                <div class="col-sm-1">
                                    <input type="hidden" name="operation" value="AddToCart" />
                                    <input type="hidden" name="offerId" value="${offer.timeAsString}"/>
                                    <input type="hidden" name="pageName" value="shop-list-view3"/>
                                    <button class="milkRunRecord-button">Add</button>
                                </div>
                            </#if>
                        </form>
                    </div>
                </#list>
            </div>
        </div>
    </div>
    <p></p>
    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>

</body>
</html>