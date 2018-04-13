<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<#include "macros-js-inc-dec-qty.ftl" >


<head>
    <@analytics />

    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>${system.site.Company}</title>
    <@styleSheets/>

    <@ourStyles/>  <!-- pickup the rating stars css -->

</head>
<body class="">

    <!-- session is pre-defined -->
    <#assign offer = Offer.findByTimestamp(session.getAttributeS("offerId")) >
    <#assign openMilkRunId = MilkRunDB.findOpen().getId() >

    <@pageHeader "single-product.ftl"/>
    <section class="banner banner-short bg-parallax">
        <div class="overlay"></div>
        <div class="container">
            <div class="banner-content text-center">
                <h2 class="page-title">SHOP DETAIL</h2>
                <div class="breadcrumbs">
                    <a href="/">Home</a>
                    <a href="shop-list-view2">Shop</a>
                    <span>${offer.item.shortOne}</span>
                </div>
            </div>
        </div>
    </section>
    <div class="maincontainer">
        <div class="container">

            <div class="row alert-message-container">
                <div class="alert alert-success alert-dismissible" role="alert">
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    You have added <span class="alert-message"></span> to your cart.
                </div>
            </div>

            <div class="row">
                <div class="col-sm-6">
                    <div class="single-images">
                        <#if offer.getItem().getImage("Main")?? >
                            <a class="popup-image" href="${offer.getItem().getImage("Main").getPath()}">
                                <img class="main-image" src="${offer.getItem().getImage("Main").getPath()}"  alt=""/>
                            </a>
                            <div class="single-product-thumbnails">
                                <!-- however many images there are use them, select the first one.  clicking
                                        on one of the thumbnails will make it switch the associated image
                                        into the above image, or something like that.
                                -->
                                <#assign x = "">
                                <#list offer.getItem().getImages() as image>
                                    <#if x == "">
                                        <span class="selected" data-image_full="${image.getPath()}"><img src="${image.getThumbnailPath()}" /></span>
                                        <#assign x = " ">
                                            <#else>
                                                <span data-image_full="${image.getPath()}"><img src="${image.getThumbnailPath()}" /></span>
                                    </#if>
                                </#list>
                            </div>
                        <#else>
                            <#if offer.getItem().getSupplier().getImage("Main")?? >
                                <div class="product-thumb">
                                    <a href="single-product?offerId=${offer.timeAsString}"><img src="${offer.getItem().getSupplier().getImage("Main").getPath()}" alt=""></a>
                                </div>
                            <#else>
                                <div class="product-thumb">
                                    ${offer.getItem().getSupplier().getCompanyName()} has no images for this item.
                                </div>
                            </#if>
                        </#if>
                    </div>                    
                </div>

                <div class="col-sm-6">
                    <div class="summary entry-summary">
                        <h1 class="product_title entry-title">${offer.item.shortOne}</h1>
                        <div>
                            <h4>
                                <a href="${offer.item.supplier.publicHomePageURL}">${offer.item.supplier.companyName}</a>
                            </h4>
                        </div>

                        <#if (offer.avgRating > 0.0) >
                            <div class="product-star edo-star" title="Rated ${offer.avgRating} out of 5">
                                <@showRatingStars offer.avgRating/>
                            </div>
                        
                            &nbsp;&nbsp; ${offer.ratingCount} reviews
                        </#if>
                        <!-- <span class="in-stock"><i class="fa fa-check-circle-o"></i> In stock</span> -->
                        <div class="description">
                        	<p>${offer.item.description}</p>
                        </div>
                        <p class="price">
                            <#if offer.quantity == 1 >
                                <ins><span class="product-price">${offer.getOurSellPriceAsString()} per ${offer.units}</span></ins>
                            <#else>
                                <ins><span class="product-price">${offer.getOurSellPriceAsString()} per ${offer.quantity} ${offer.units}</span></ins>
                            </#if>
                        </p>

                        <!-- <form method="post">
                            
                            <input type="hidden" name="operation" value="AddToCart" />
                            <input type="hidden" name="offerId" value="${offer.timeAsString}"/>
                            <input type="hidden" name="pageName" value="single-product"/> -->
                        <div class="add-to-cart-wrapper">
                            <#assign available = 10000 >
                            <#if offer.getAvailability()?? >
                                <#assign available = offer.getAvailability().getAvailableQuantity() >
                            </#if>

                             <#if (available > 0) >
                                <div class="single_variation_wrap">
                                    <#if session.user?? >
                                        <@quantitySteppersNoDiv offer getCartOfferQuantity(offer.getTime(), session.user.getId(), openMilkRunId) />
                                    <#else>
                                        <@quantitySteppersNoDiv offer 0 />
                                    </#if>
                                    <br>
                                </div>
                            <#else>
                                This product is not available at this time.
                            </#if>
                        </div>
                        <!-- </form> -->

                        <div class="product-share">
                            <strong>Share:</strong>
                            <a href="#"><i class="fa fa-facebook"></i></a>
                            <a href="#"><i class="fa fa-twitter"></i></a>
                            <a href="#"><i class="fa fa-tencent-weibo"></i></a>
                            <a href="#"><i class="fa fa-vk"></i></a>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Product tab -->
            <div class="product-tabs">
                <ul class="nav-tab">
                    <li class="active"><a data-toggle="tab" href="#tab1">DESCRIPTION</a></li>
                    <li><a  data-toggle="tab" href="#tab2">Reviews</a></li>
                    <!-- <li><a data-toggle="tab" href="#tab3">Product tags</a></li> -->
                </ul>
                <div class="tab-content">
                    <div id="tab1" class="active tab-pane">
                        <p>${offer.item.getShortTwo()}</p>
                        <p></p>
                        <p>${offer.item.note}</p>
                    </div>
                    <div id="tab2" class="tab-pane">
                        <div class="reviews">
                            <#if session.getUser()?? >
                                <!-- Review form -->
                                <div class="review_form_wrapper pull-right">
                                    <div class="review_form">
                                        <div class="comment-respond">
                                            <button id="btnAddRating" class="btn btn-primary">WRITE YOUR OWN REVIEW</button>
                                        </div>
                                    </div>
                                </div>
                                <!--./review form -->
                                
                            </#if>

                            <div class="comments">
                                <h2>CUSTOMER REVIEWS (${offer.ratingCount})</h2>
                                <ol class="commentlist">
                                    <#list offer.getRatingsOf() as rating >
                                        <li class="comment">
                                            <div class="comment_container">
                                                <!-- <img class="avatar" src="/images/avatars/1.png" alt="" /> -->
                                                <div class="comment-text">
                                                    <div itemprop="description" class="description">
                                                        <p>${rating.getBody()}</p>
                                                    </div>
                                                    <p class="meta">
                                                        <strong itemprop="author">${rating.getRater().getName()}</strong>
                                                        – ${Util.formatTimestamp(rating.getTime(), "MMM dd, YYYY")}:
                                                    </p>
                                                    <div class="product-star" title="Rated ${rating.rating} out of 5">
                                                        <@showRatingStars rating.getRating()/>
                                                    </div>
                                                </div>
                                            </div>
                                        </li>
                                    </#list>
                                </ol>
                            </div>
                        </div>
                        
                    </div>
                    <!-- <div id="tab3" class="tab-pane">
                        <div class="tagcloud">
                            <a href="#">ARE THERE TAGS IN THE SYSTEM?</a>
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
                    </div>-->
                </div>
            </div>
            <!-- ./ Product tab -->

            <!--related products
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
            </div>-->
            <!--./related products-->
        </div>
    </div>

    <div id="modalReview" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">

            <form method="post" class="comment-form">
                <input type="hidden" name="operation" value="AddReview" />
                <input type="hidden" name="offerId" id="${offer.timeAsString}" />
                <input type="hidden" name="rating" value="2" />
                
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title" id="modalReviewTitle">Your Review</h4>
                    </div>
                    <div class="modal-body" id="modalReviewBody">                    
                        <@enterRatingStars/>

                        <p class="comment-form-comment">
                            <textarea id="comment" name="comment" rows="4" placeholder="Add Your Review"></textarea>
                        </p>
                        
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>                
                        <button type="submit" class="btn btn-primary button-add-to-cart">Submit Rating</button>
                    </div>
                </div><!-- /.modal-content -->
            </form>
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->


    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>

    <@incDecOfferQty 0 />

</body>
</html>