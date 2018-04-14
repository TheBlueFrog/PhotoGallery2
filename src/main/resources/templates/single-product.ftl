<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>${system.site.Company}</title>
    <@styleSheets/>

    <@ourStyles/>  <!-- pickup the rating stars css -->

</head>
<body class="">
    <@pageHeader "single-product.ftl"/>
    <section class="banner bg-parallax">
        <div class="overlay"></div>
        <div class="container">
            <div class="banner-content text-center">
                <h2 class="page-title">SHOP DETAIL</h2>
                <div class="breadcrumbs">
                    <a href="${system.site.indexPage}">Home</a>
                    <a href="#">Shop</a>
                    <a href="#">SHOP DETAIL</a>
                    <span>${offer.item.shortOne}</span>
                </div>
            </div>
        </div>
    </section>
    <div class="maincontainer">
        <div class="container">
            <div class="row">
                <div class="col-sm-6">
                    <div class="single-images">
                        <#if (offer.item.numImages > 0) >
                            <a class="popup-image" href="${offer.item.mainImage.path}">
                                <img class="main-image" src="${offer.item.mainImage.path}"  alt=""/>
                            </a>
                            <div class="single-product-thumbnails">
                                <!-- however many images there are use them, select the first one.  clicking
                                        on one of the thumbnails will make it switch the associated image
                                        into the above image, or something like that.
                                -->
                                <#assign x = "">
                                    <#list offer.item.images as image>
                                        <#if x == "">
                                            <span class="selected" data-image_full="${image.path}"><img src="${image.thumbnailPath}" /></span>
                                            <#assign x = " ">
                                                <#else>
                                                    <span data-image_full="${image.path}"><img src="${image.thumbnailPath}" /></span>
                                        </#if>
                                    </#list>
                            </div>
                        <#else>
                            <#if (offer.item.supplier.numImages > 0) >
                                <div class="product-thumb">
                                    <a href="single-product?offerId=${offer.timeAsString}"><img src="${offer.item.supplier.mainImage.path}" alt=""></a>
                                </div>
                                <#else>
                                    <div class="product-thumb">
                                        ${offer.item.supplier.username} has no images for this item.
                                    </div>
                            </#if>
                        </#if>
                    </div>
                    <div>
                        <h4>
                            <a href="${offer.item.supplier.publicHomePageURL}">${offer.item.supplier.companyName}</a>
                        </h4>
                    </div>
                </div>

                <div class="col-sm-6">
                    <div class="summary entry-summary">
                        <h1 class="product_title entry-title">${offer.item.shortOne}</h1>
                        <div class="product-star edo-star" title="Rated 1 out of 5">
                            <@showRatingStars offer.avgRating/>
                        </div>
                        <#if (offer.avgRating > 0.0) >
                            &nbsp;&nbsp; ${offer.ratingCount} reviews
                        </#if>
                        <span class="in-stock"><i class="fa fa-check-circle-o"></i> In stock</span>
                        <div class="description">
                        	<p>${offer.item.description}</p>
                        </div>
                        <p class="price">
                            <#if offer.quantity == 1 >
                                <ins><span class="product-price">${session.getQuotedPriceAsString(offer)} for ${offer.units}</span></ins>
                            <#else>
                                <ins><span class="product-price">${session.getQuotedPriceAsString(offer)} for ${offer.quantity} ${offer.units}</span></ins>
                            </#if>
                        </p>
                        <!--
                        <form class="variations_form ">
                            <table class="variations">
                    			<tbody>
    								<tr>
                						<td class="label"><label for="pa_color">Color</label></td>
                						<td class="value">
                							<select id="pa_color" class="" name="attribute_pa_color">
                                                <option value="">Choose an option</option>
                                                <option value="black" class="attached enabled">Black</option>
                                            </select>						
                                        </td>
                					</tr>
                    		        <tr>
                                        <td class="label"><label for="pa_size">Size</label></td>
                                        <td class="value">
                                            <select id="pa_size" class="" name="attribute_pa_size">
                                                <option value="">Choose an option</option>
                                                <option value="s" class="attached enabled">S</option>
                                            </select>
                                        </td>
                   					</tr>
       		        			</tbody>
                    		</table>
                            <div class="single_variation_wrap">
                                <div class="box-qty">
                                    <a href="#" class="quantity-plus"><i class="fa fa-angle-up"></i></a>
                                    <input type="text" step="1" min="1" name="quantity" value="01" title="Qty" class="input-text qty text" size="4">
                                    <a href="#" class="quantity-minus"><i class="fa fa-angle-down"></i></a>
                                </div>
                                <a href="#" class="buttom-compare"><i class="fa fa-retweet"></i></a>
                                <a href="#" class="buttom-wishlist"><i class="fa fa-heart-o"></i></a>
                            </div>
                        </form>
                        -->

                        <form method="post">

                            <input type="hidden" name="operation" value="AddToCart" />
                            <input type="hidden" name="offerId" value="${offer.timeAsString}"/>
                            <input type="hidden" name="pageName" value="single-product"/>

                            <label for="quantity">Quantity</label>
                            <input id="quantity" name="quantity" type="number" min="1" max="10" value="1"/>
                            <p></p>
                            <p></p>
                            <input type="radio" name="frequency" value="once" checked>Once
                            <input type="radio" name="frequency" value="weekly">Weekly
                            <input type="radio" name="frequency" value="bi-weekly"> Bi-weekly
                            <p></p>
                            <button class="button-add-to-cart">Add to Cart</button>
                        </form>
                        <p></p>

                        <div class="product-share">
                            <strong>Share:</strong>
                            <a href="#"><i class="fa fa-facebook"></i></a>
                            <a href="#"><i class="fa fa-twitter"></i></a>
                            <a href="#"><i class="fa fa-tencent-weibo"></i></a>
                            <a href="#"><i class="fa fa-vk"></i></a>
                        </div>

                        <#if session.user?? >
                            <!-- if not logged in can't leave rating -->

                            <!-- tried putting this form into the review page below
                                 but the stars keep dissapearing, probably related to
                                 the tabbing behavior

                                 moving on, clean this up later
                            -->

                            <p></p>
                            <form action="" method="post" class="comment-form">
                                <@enterRatingStars/>
                                <p class="comment-form-comment">
<!--                                    <label for="comment">Your Review</label> -->
                                    <textarea id="comment" name="comment" cols="45" rows="2" placeholder="Add Your Review"></textarea>
                                </p>
                                <p class="form-submit">
                                    <input type="hidden" name="operation" value="AddReview" />
                                    <input type="hidden" name="offerId" value="${offer.timeAsString}" />
                                    <input type="hidden" name="rating" value="2" />
                                    <input name="submit" type="submit" id="submit" class="submit" value="Submit">
                                </p>
                            </form>
                        </#if>
                    </div>
                </div>
            </div>
            <!-- Product tab -->
            <div class="product-tabs">
                <ul class="nav-tab">
                    <li class="active"><a data-toggle="tab" href="#tab1">DESCRIPTION</a></li>
                    <li><a  data-toggle="tab" href="#tab2">Reviews</a></li>
                    <li><a data-toggle="tab" href="#tab3">Product tags</a></li>
                </ul>
                <div class="tab-content">
                    <div id="tab1" class="active tab-pane">
                        <p>${offer.item.description}</p>
                        <p></p>
                        <p>${offer.item.note}</p>
                    </div>
                    <div id="tab2" class="tab-pane">
                        <div class="reviews">
                            <div class="comments">
                                <h2>CUSTOMER REVIEWS (${offer.ratingCount})</h2>
                                <ol class="commentlist">
                                    <#list offer.ratingsOf as rating >
                                        <li class="comment">
                                            <div class="comment_container">
                                                <img class="avatar" src="/images/avatars/1.png" alt="" />
                                                <div class="comment-text">
                                                    <div itemprop="description" class="description">
                                                        <p>${rating.body}</p>
                                                    </div>
                                                    <p class="meta">
                                                        <strong itemprop="author">${rating.ratee.username}</strong>
                                                        – ${rating.publishedDate}:
                                                    </p>
                                                    <div class="product-star" title="Rated ${rating.rating} out of 5">
                                                        <@showRatingStars rating.rating/>
                                                    </div>
                                                </div>
                                            </div>
                                        </li>
                                    </#list>
                                </ol>
                            </div>
                        </div>
                        <!-- Review form -->
                        <div class="review_form_wrapper" class="review_form_wrapper">
                            <div class="review_form">
                                <div class="comment-respond">
                                    <#if session.user?? >
                                    <h3 class="comment-reply-title">WRITE YOUR OWN REVIEW</h3>
<!-- see comment above
                                        <div class="rating">
                                            <div class="attribute">
                                                <span class="title">Quality</span>
                                                <@enterRatingStars/>
                                            </div>
                                            <div class="attribute">
                                                <span class="title">PRICE</span>
                                                <@enterRatingStars/>
                                            </div>
                                            <div class="attribute">
                                                <span class="title">VALUE</span>
                                                <@enterRatingStars/>
                                            </div>
                                        </div>
                                        <form action="" method="post" class="comment-form">
                                            <@enterRatingStars/>
                                            <p class="comment-form-comment">
                                                <label for="comment">Your Review</label>
                                                <textarea id="comment" name="comment" cols="45" rows="8" placeholder="Your Review"></textarea>
                                            </p>
                                            <p class="form-submit">
                                                <input type="hidden" name="operation" value="AddReview" />
                                                <input type="hidden" name="offerId" value="${offer.timeAsString}" />
                                                <input type="hidden" name="rating" value="2" />
                                                <input name="submit" type="submit" id="submit" class="submit" value="Submit">
                                            </p>
                                        </form>
-->
                                    </#if>
                                </div>
                            </div>
                        </div>
                        <!--./review form -->
                    </div>
                    <div id="tab3" class="tab-pane">
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
                </div>
            </div>
            <!-- ./ Product tab -->
            <!--related products-->
            <div class="related-products">
                <div class="title-section text-center">
        			<h2 class="title">RELATED PRODUCTS</h2>
        		</div>
                <div class="product-slide owl-carousel"  data-dots="false" data-nav = "true" data-margin = "30" data-responsive='{"0":{"items":1},"600":{"items":3},"1000":{"items":4}}'>
    				<div class="product">
    					<div  class="product-thumb">
    						<a href="single-product">
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
    			</div>
            </div>
            <!--./related products-->
        </div>
    </div>
    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
</body>
</html>