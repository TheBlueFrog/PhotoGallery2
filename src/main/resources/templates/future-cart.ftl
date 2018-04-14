<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>${system.site.Company} - Future Orders</title>
    <@styleSheets/>
</head>
<body class="">
    <@pageHeader "future-cart.ftl"/>
    <section class="banner banner-cart bg-parallax">
        <div class="overlay"></div>
        <div class="container">
            <div class="banner-content text-center">
                <h2 class="page-title">Future Orders</h2>
                <div class="breadcrumbs">
                    <a href="${system.site.indexPage}">Home</a>
                    <span>Future Orders</span>
                </div>
            </div>
        </div>
    </section>
    <div class="maincontainer">
        <div class="container">
            <!-- Table cart -->
            <table class="shop_table cart">
                <thead>
            		<tr>
            			<th class="product-thumbnail">Product</th>
            			<th class="product-name">Name</th>
                        <th class="product-name">Order Date</th>
                        <th class="product-quantity">Frequency</th>
                        <th class="product-quantity">Quantity</th>
            			<th class="product-price">Price</th>
            			<th class="product-subtotal">Total price</th>
                        <th class="product-remove">&nbsp;</th>
            		</tr>
            	</thead>
                <tbody>
                    <#list futureCartOffers as cartOffer>
                        <tr class="cart_item">
                            <td class="product-thumbnail">
                                <#if (cartOffer.offer.item.numImages > 0) >
                                    <img src="${cartOffer.offer.item.mainImage.thumbnailPath}">
                                </#if>
                            </td>
                            <td class="product-name">
                                <a href="#">${cartOffer.item.shortOne}</a>
<!--                                <p>${cartOffer.item.description}</p> -->
                            </td>
                            <td class="product-name">
                                <p>${cartOffer.expectedDeliveryTimeAsDateString}</p>
                            </td>
                            <td class="product-name">
                                <p>${cartOffer.frequency}</p>
                            </td>
                            <td class="product-name">
                                <p>${cartOffer.quantity}</p>
                            </td>
                            <td class="product-price">
                                <span class="amount">${cartOffer.priceAsString}</span>
                            </td>
                            <td class="product-subtotal">
                                <span class="amount">${cartOffer.priceAsString}</span>
                            </td>
                            <td class="product-remove">
                                <form id="selectItemForm" method="post">
                                    <input type="hidden" name="operation" value="RemoveFromFutureCart" />
                                    <input type="hidden" name="offerId" value="${cartOffer.offer.timeAsString}" />
                                    <input type="submit" class="fa fa-times" value="Remove">
                                </form>
                            </td>
                        </tr>
                    </#list>
                </tbody>
            </table>
            <div class="cart-collaterals">
                <div class="row">
                    <div class="col-sm-12 col-md-4">
                        <div class="cart_totals ">
                        	<h2>Cart Total</h2>
                        	<table>
                        		<tbody>
                                    <!--<tr class="cart-subtotal">-->
                            			<!--<th>Subtotal</th>-->
                            			<!--<td><span class="amount">£15.00</span></td>-->
                            		<!--</tr>-->
                                    <tr class="order-total">
                            			<th>Total</th>
                            			<td>
                                            <strong><span class="amount">${futureCartTotal}</span></strong>
                                        </td>
                            		</tr>
                        	   </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
</body>
</html>