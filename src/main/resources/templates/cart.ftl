<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Leka - Cart</title>
    <@styleSheets/>
</head>
<body class="">
    <@pageHeader "cart.html"/>
    <section class="banner banner-cart bg-parallax">
        <div class="overlay"></div>
        <div class="container">
            <div class="banner-content text-center">
                <h2 class="page-title">SHOPPING CART</h2>
                <div class="breadcrumbs">
                    <a href="${system.site.indexPage}">Home</a>
                    <span>SHOPPING CART</span>
                </div>
            </div>
        </div>
    </section>
    <div class="maincontainer">
        <div class="container">
            <!-- Step Checkout
            <div class="step-checkout">
                <div class="row">
                    <div class="col-sm-2"></div>
                    <div class="col-sm-2">
                        <div class="step cart active">
                            <div class="icon"></div>
                            <span class="step-count">01</span>
                            <h3 class="step-name">Shopping Cart</h3>
                        </div>
                    </div>
                    <div class="col-sm-1"></div>
                    <div class="col-sm-2">
                        <div class="step checkout">
                            <div class="icon"></div>
                            <span class="step-count">02</span>
                            <h3 class="step-name">Check out</h3>
                        </div>
                    </div>
                    <div class="col-sm-1"></div>
                    <div class="col-sm-2">
                        <div class="step complete">
                            <div class="icon"></div>
                            <span class="step-count">03</span>
                            <h3 class="step-name">Order Complete</h3>
                        </div>
                    </div>
                </div>
            </div>
            -->
            <!-- Table cart -->
            <table class="shop_table cart">
                <thead>
            		<tr>
            			<th class="product-thumbnail">Product</th>
            			<th class="product-name">name</th>
                        <th class="product-quantity">Quantity</th>
            			<th class="product-price">Price</th>
            			<th class="product-subtotal">Total price</th>
                        <th class="product-remove">&nbsp;</th>
            		</tr>
            	</thead>
                <tbody>
                    <#list session.user.cartOffers as cartOffer>
                        <tr class="cart_item">
                            <td class="product-thumbnail">
                                <img src="${cartOffer.offer.item.mainImage.path}">
                            </td>
                            <td class="product-name">
                                <a href="#">${cartOffer.item.shortOne}</a>
                                <p>${cartOffer.item.description}</p>
                            </td>
                            <td class="product-quantity">
                                ${cartOffer.quantity}
                                <!--<input id="quantity" name="quantity" type="number" min="1" max="10" value="${cartOffer.quantity}"/>-->
                            </td>
                            <td class="product-price">
                                <span class="amount">${cartOffer.priceAsString}</span>
                            </td>

                            <td class="product-subtotal">
                                <span class="amount">${cartOffer.priceAsString}</span>
                            </td>
                            <td class="product-remove">
                                <form id="selectItemForm" method="post">
                                    <input type="hidden" name="operation" value="RemoveFromCart" />
                                    <input type="hidden" name="quantity" value="${cartOffer.quantity}" />
                                    <input type="hidden" name="frequency" value="${cartOffer.frequency}" />
                                    <input type="hidden" name="offerId" value="${cartOffer.timeAsString}" />
                                    <input type="submit" class="fa fa-times" value="Remove">
                                </form>
                                <#--
                                    <a class="remove" href="#"><i class="fa fa-times"></i></a>
                                -->
                            </td>
                        </tr>
                    </#list>
                    <tr>
            			<td colspan="6" class="actions">
                            <button class="button pull-left">CONTINUE SHOPPING</button>
                            <input type="submit" class="button" name="update_cart" value="UPDATE SHOPPING CART">
                            <button class="button">CLEAR SHOPPING CART</button>
                        </td>
            		</tr>
                </tbody>
            </table>
            <div class="cart-collaterals">
                <div class="row">
                    <!--
                    <div class="col-sm-12 col-md-4">
                        <div class="discount-codes">
                            <h2>Discount codes</h2>
                            <p class="notice">Enter your coupon code if you have one.</p>
                            <form class="form">
                                <p><input type="text" placeholder="COUPON CODE.." /></p>
                                <button class="button">APPLY COUPON</button>
                            </form>
                        </div>
                    </div>
                    <div class="col-sm-12 col-md-4">
                        <div class="shipping-form">
                            <h2>ESTIMATE SHIPPING AND TAX</h2>
                            <p class="notice">Enter your coupon code if you have one.</p>
                            <form class="form">
                                <p>
                                    <label>Country</label>
                                    <select>
                                        <option value="">United states</option>
                                        <option value="">Hanoi</option>
                                        <option value="">HoChiMinh City</option>
                                        <option value="">USA</option>
                                    </select>
                                </p>
                                <p>
                                    <label class="">STATE/PROVICE</label>
                                    <select>
                                        <option value="">Please select region, state or province</option>
                                    </select>
                                </p>
                                <p>
                                    <label>zip / postal code</label>
                                    <input type="text" />
                                </p>
                                <button class="button">ESTIMATE</button>
                            </form>
                        </div>
                    </div>
                    -->
                    <div class="col-sm-12 col-md-4">
                        <div class="cart_totals ">
                        	<table>
                        		<tbody>
                                    <!--<tr class="cart-subtotal">-->
                            			<!--<th>Subtotal</th>-->
                            			<!--<td><span class="amount">${session.user.cartTotal}</span></td>-->
                            		<!--</tr>-->
                                    <tr class="order-total">
                            			<th>Total</th>
                            			<td>
                                            <strong><span class="amount">${session.user.cartTotal}</span></strong>
                                        </td>
                            		</tr>
                        	   </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <!--Sell products
            <div class="related-products">
                <div class="title-section text-center">
        			<h2 class="title">SELL PRODUCTS</h2>
        		</div>
                <div class="product-slide owl-carousel"  data-dots="false" data-nav = "true" data-margin = "30" data-responsive='{"0":{"items":1},"600":{"items":3},"1000":{"items":4}}'>
    				<div class="product">
    					<div  class="product-thumb">
    						<a href="single-product.html">
    							<img src="/images/products/product8.png" alt="">
    						</a>
    						<div class="product-button">
    							<a href="#" class="button-compare">Compare</a>
    							<a href="#" class="button-wishlist">Wishlist</a>
    							<a href="#" class="button-quickview">Quick view</a>
    						</div>
    					</div>
    					<div class="product-info">
    						<h3><a href="#">Ledtead Predae</a></h3>
    						<span class="product-price">$89.00</span>
    						<a href="#" class="button-add-to-cart">ADD TO CART</a>
    						</div>
    				</div>
    				<div class="product">
    					<div  class="product-thumb">
    						<a href="single-product.html">
    							<img src="/images/products/product7.png" alt="">
    						</a>
    						<div class="product-button">
    							<a href="#" class="button-compare">Compare</a>
    							<a href="#" class="button-wishlist">Wishlist</a>
    							<a href="#" class="button-quickview">Quick view</a>
    						</div>
    					</div>
    					<div class="product-info">
    						<h3><a href="#">Ledtead Predae</a></h3>
    						<span class="product-price">$89.00</span>
    						<a href="#" class="button-add-to-cart">ADD TO CART</a>
    					</div>
    				</div>
    			</div>
            </div>
            -->
        </div>
    </div>
    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
</body>
</html>