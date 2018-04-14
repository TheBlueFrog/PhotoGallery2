<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>${system.site.Company}</title>
    <@styleSheets3/>

    <style>

    .cart {
        margin: 40px 0;
        padding: 0;
    }
.cart .offer-row {
    padding: 0;
    margin: 0;
    overflow: hidden;
    border-bottom: 2px solid #e0e0e0;
    margin-bottom: 5px;
}
.cart .offer-row-last {
    padding: 0;
    margin: 0;
    overflow: hidden;
    margin-bottom: 5px;
}
.cart .total-row {
    padding: 0;
    margin: 0;
    overflow: hidden;
    border-top: 2px solid #808080;
    margin-bottom: 5px;
}

.cart .offer-row-last .offer-name,
.cart .offer-row .offer-name{
    padding: 3px 0;
    margin: 0;
    font-size: 17px;
    line-height: 17px;
    float: left;
}
.cart .offer-row-last .offer-company,
.cart .offer-row .offer-company{
    display: block;
    padding: 5px 0 3px;
    margin: 0;
    font-size: 15px;
    text-align: right;
    line-height: 15px;
    float: right;
}
.cart .offer-row-last .offer-description,
.cart .offer-row .offer-description{
    padding: 3px 0 3px;
    margin: 0;
    font-size: 13px;
    line-height: 13px;
}
.cart .offer-row-last .offer-frequency,
.cart .offer-row .offer-frequency{
    margin-bottom: 0;
    font-size: 14px;
}
.cart .offer-row-last .cart-quantity,
.cart .offer-row .cart-quantity{
    margin-bottom: 0;
    font-size: 14px;
}
.cart .offer-row-last .offer-quantity,
.cart .offer-row .offer-quantity{
    margin-bottom: 0;
    font-size: 14px;
}
.cart .offer-row-last .offer-price,
.cart .offer-row .offer-price{
    display: inline;
    font-size: 14px;
    text-align: right;
    margin-bottom: 5px;
}
.cart .offer-row-last .milkRunRecord-button,
.cart .offer-row .milkRunRecord-button{
            color: inherit;
            font-size: 11px;
            padding: 2px 12px;
            display: inline-block;
            margin 0;
            margin-top: 3px;
            border-top: 1px solid #e9e9e9;
            border-bottom: 1px solid #e9e9e9;
        }

.cart .total-row .total{
    text-align: right;
    font-size: 16px;
    text-align: right;
    color: #7e883a;
}

</style>

</head>
<body class="">
    <@pageHeader3 "cart3.ftl"/>

    <section class="banner banner-about bg-parallax">
        <div class="overlay">
        </div>
        <div class="container">
            <div class="banner-content text-center">
                <h2 class="page-title"><img src="/images/thelook/MilkRun_logo_white.png" alt="MilkRun Farm Delivery" /></h2>
                <div class="breadcrumbs">
                    <a href="shop-list-view3">Home</a>
                    <span>Cart</span>
                </div>
            </div>
        </div>
    </section>

    <div class="main-header">
        <div class="container main-header-inner">
            <div class="col-sm-12 cart">
                <#list session.user.cartOffers as cartOffer>
                    <#if cartOffer?has_next >
                        <div class="row offer-row">
                    <#else>
                        <div class="row offer-row-last">
                    </#if>
                        <div class="col-md-4">
                            <div>
                                <span class="offer-name">${cartOffer.item.shortOne}</span>
                                <span class="offer-company">${cartOffer.item.supplier.companyName}</span>
                                <div style="clear:both;"></div>
                            </div>
                            <div class="offer-description">${cartOffer.item.description}</div>
                        </div>
                        <div class="col-md-3 offer-quantity">
                            <#if cartOffer.offer.quantity == 1 >
                                ${cartOffer.quantity} ${cartOffer.offer.units}
                            <#else>
                                ${cartOffer.quantity} of ${cartOffer.offer.units}
                            </#if>

                            <#if (system.site.devEnv) >
                                <br> <span style="color:deeppink">
                                    (${cartOffer.offer.quantity} ${cartOffer.offer.units}) ${cartOffer.offer.priceAsString}
                                </span>
                            </#if>
                        </div>
                        <div class="col-md-2 offer-frequency">
                            <#if (cartOffer.frequency != "once") >
                                ${cartOffer.frequency}
                            </#if>
                        </div>
                        <div class="col-md-1 offer-price">
                            ${cartOffer.priceAsString}
                        </div>
                        <div class="col-md-1">
                        </div>
                        <div class="col-md-1">
                            <form method="post">
                                <input type="hidden" name="operation" value="RemoveFromCart" />
                                <input type="hidden" name="offerId" value="${cartOffer.timeAsString}"/>
                                <input type="hidden" name="frequency" value="${cartOffer.frequency}"/>
                                <input type="hidden" name="quantity" value="${cartOffer.quantity}"/>
                                <input type="hidden" name="pageName" value="cart3"/>
                                <button class="milkRunRecord-button">Remove</button>
                            </form>
                        </div>
                    </div>
                </#list>
                <div class="row total-row">
                    <div class="col-md-7"></div>
                    <div class="col-sm-1 ">
                        TOTAL
                    </div>
                    <div class="col-sm-1 total">
                        ${session.user.cartTotal}
                    </div>
                    <div class="col-md-1">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <p></p>
    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>

</body>
</html>