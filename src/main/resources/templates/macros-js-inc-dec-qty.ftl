
<#function getCartOfferQuantity offerId userId milkRunId >
    <#if (CartOffer.findByOfferIdAndUserIdAndMilkRunId(
    offerId,
    userId,
    openMilkRunId)?size > 0) >
        <#return CartOffer.findByOfferIdAndUserIdAndMilkRunId(
        offerId,
        userId,
        openMilkRunId)?first.getQuantity() >
    <#else >
        <#return 0 >
    </#if>
</#function>


<#macro quantitySteppersDD offer >
<div class="col-sm-12">
    <div class="col-sm-2">
        <a href="javascript:void(0)" onclick="decreaseBtn(this, '${offer.getTimeAsId()}')">
            <i class="fa fa-minus-square-o" style="font-size:20px"></i></a>
    </div>
    <div class="col-sm-4">
        <span class="item-quantity" id="qty-${offer.getTimeAsId()}" style="font-size: 12pt">
            ? in cart
        </span>
    </div>
    <div class="col-sm-2">
        <#if offer.getEnabled() >
            <a href="javascript:void(0)" onclick="increaseBtn(this, '${offer.getTimeAsId()}')">
                <i class="fa fa-plus-square-o" style="font-size:20px; vertical-align: -3px"></i></a>
        <#else >
            n/a
        </#if>
    </div>
    <div class="col-sm-1"></div>
    <div class="col-sm-2">
        <#if session.user?? >
            <a href="javascript:void(0)" onclick="favoriteBtn(this, '${offer.getTimeAsId()}')">
                <#if (Favorite.findByItemId(offer.getItemId())?size > 0 ) >
                    <#local fav = "fa-heart" >
                <#else>
                    <#local fav = "fa-heart-o" >
                </#if>
                <i class="fa ${fav}" id="favorite-${offer.getTimeAsId()}" style="font-size:20px; vertical-align: -3px"></i></a>
        </#if>
    </div>
</div>
</#macro>

<#macro quantitySteppers offer qty >
    <#local offerId = offer.getTimeAsId() >

    <div class="col-xs-2">
        <a href="javascript:void(0)"
           data-toggle="tooltip" title="Decrease Quantity"
           onclick="decreaseBtn(this, '${offerId}')">
            <i class="fa fa-minus-square-o" style="font-size:20px; vertical-align: -4px"></i></a>
    </div>
    <div class="col-xs-4">
            <span class="item-quantity" id="qty-${offerId}" style="font-size: 12pt">
                ${qty} in cart
            </span>
    </div>
    <div class="col-xs-2">
        <#if offer.getEnabled() >
            <a href="javascript:void(0)"
               data-toggle="tooltip" title="Increase Quantity"
               onclick="increaseBtn(this, '${offerId}')">
                <i class="fa fa-plus-square-o" style="font-size:20px; vertical-align: -3px"></i></a>
        <#else >
            n/a
        </#if>
    </div>
    <div class="col-xs-2">
        <#if session.user?? >
            <#local userId = session.getUser().getId() >
            <#if Favorite.isFavorite(userId, offerId) >
                <#local fav = "fa-heart" >
                <#local tt = "Remove as Favorite">
            <#else>
                <#local fav = "fa-heart-o" >
                <#local tt = "Add as Favorite">
            </#if>
            <a href="javascript:void(0)"
               onclick="favoriteBtn(this, '${offerId}')"
               data-toggle="tooltip" title="${tt}"
            >
                <i class="fa ${fav}" id="favorite-${offerId}" style="font-size:20px; vertical-align: -3px"></i></a>
        </#if>
    </div>
    <div class="col-xs-2">
        <#local userId = session.getUser().getId() >
        <#if StandingOrder.existsStandingOrder(userId, offer.getTimestamp()) >
            <#local fav = "fa-calendar" >
            <#local header = "Remove MilkRun Standing Order">
            <#local body = "Item: ${offer.getItem().getShortOne()} " >
            <#local body = body + "<br>Quantity: ${StandingOrder.findByUserIdAndOfferTimestamp(userId, offer.getTimestamp()).getQuantity()}" >
            <#local button = "Remove" >
        <#else>
            <#local fav = "fa-calendar-o" >
            <#local header = "Add MilkRun Standing Order">
            <#local body = "Item: ${offer.getItem().getShortOne()} " >
            <#local body = body + "<br>Quantity: ${qty}" >
            <#local button = "Add" >
        </#if>

        <a data-toggle="modal" data-target="#myModal-${offerId}"
        >
            <i class="fa ${fav}"
               data-toggle="tooltip" title="${header}"
               style="font-size:20px; vertical-align: 5px"></i>
        </a>

        <div class="modal fade" id="myModal-${offerId}" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">${header}</h4>
                    </div>
                    <div class="modal-body">
                        ${body}
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal"
                                onclick="standingOrderBtn('${offerId}')">
                            ${button}
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</#macro>

<#macro quantitySteppersNoDiv offer qty >
        <a href="javascript:void(0)"
           data-toggle="tooltip" title="Decrease Quantity"
           onclick="decreaseBtn(this, '${offer.getTimeAsId()}')">
            <i class="fa fa-minus-square-o" style="font-size:20px; vertical-align: -2px"></i></a>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <span class="item-quantity" id="qty-${offer.getTimeAsId()}" style="font-size: 13pt">
            ${qty} in cart
        </span>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <#if offer.getEnabled() >
            <a href="javascript:void(0)"
               data-toggle="tooltip" title="Increase Quantity"
               onclick="increaseBtn(this, '${offer.getTimeAsId()}')">
                <i class="fa fa-plus-square-o" style="font-size:20px; vertical-align: -2px"></i></a>
        <#else >
            n/a
        </#if>
        <#if session.user?? >
            &nbsp;&nbsp;&nbsp;&nbsp;
            <a href="javascript:void(0)"
               data-toggle="tooltip" title="Make Favorite"
               onclick="favoriteBtn(this, '${offer.getTimeAsId()}')">
                <#if Favorite.isFavorite(session.user.getId(), offer.getItemId()) >
                    <#local fav = "fa-heart" >
                <#else>
                    <#local fav = "fa-heart-o" >
                </#if>
                <i class="fa ${fav}" id="favorite-${offer.getTimeAsId()}" style="font-size:20px; vertical-align: -2px""></i></a>
        </#if>
</#macro>


<#macro theCartTable user milkRun >
    <#--
    <div class="row">
        <div class="col-sm-12">
            <div class="col-sm-4" style="text-align: center"><strong>Product</strong></div>
            <div class="col-sm-4" style="text-align: center">
                <div class="col-sm-9" style="text-align: center"><strong>Quantity</strong></div>
                <div class="col-sm-3" style="text-align: center"><strong>Favorite</strong></div>
            </div>
            <div class="col-sm-3" style="text-align: center"><strong>Unit & Total Price</strong></div>
        </div>
    </div>
    -->
    <br>
        <#list user.getCartOffers(milkRun.getId()) as cartOffer>
            <#local offer = cartOffer.getOffer() >
        <div class="row">
            <div class="col-sm-4">
                <a class="btn btn-link" href="single-product?offerId=${offer.getTimeAsString()}">${cartOffer.item.shortOne}</a>
                <#if session.getPushedUser()?? >
                    <!-- we're an Admin that switched to this user -->
                    <br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <small>Added ${Util.formatTimestamp(cartOffer.getTime(), "MMM d HH:mm")}</small>
                </#if>
            </div>
            <div class="col-sm-4">
                <@quantitySteppers offer getCartOfferQuantity(offer.getTime(), user.getId(), openMilkRunId) />
            </div>
            <div class="col-xs-4">
                <div class="col-xs-4 amount " >
                    ${offer.getOurSellPriceAsString()}
                </div>
                <div class="col-xs-4 amount" >
                    <span id="subtotal-${offer.getTimeAsId()}">${cartOffer.getOurSellPriceAsString()}</span>
                </div>
                <div class="col-xs-3" >
                    <a href="javascript:void(0)"
                       data-toggle="tooltip" title="Remove item from cart"
                       onclick="removeFromCart('${cartOffer.timeAsId}')">
                        <i class="fa fa-trash" style="font-size:22px; vertical-align: -1px"></i>
                    </a>
                </div>
            </div>
        </div>
        </#list>

    <div class="row">
        <div class="col-xs-4"></div>
        <div class="col-xs-4"></div>
        <div class="col-xs-4">
            <#assign discountI = 0 >
            <#assign netAmount = session.user.getCartTotal(milkRun.getId()) >
            <#list CartDiscount.findByDiscountUserIdAndMilkRunNameOrderByTimestampAsc(user.getId(), milkRun.getName())
            as cartDiscount >
                <div class="col-xs-4 amount" >
                    <i>
                    ${cartDiscount.getName()}
                    </i>
                </div>
                <div class="col-xs-4 amount " id="discount-${discountI}">
                    - ${String.format("$ %.2f", cartDiscount.getAmount(netAmount))}
                </div>
                <div class="col-xs-3" >
                </div>
                <br>
                <#assign netAmount -= cartDiscount.getAmount(netAmount) >
                <#assign discountI += 1 >
            </#list>
        </div>
    </div>

    <div class="row">
        <div class="col-xs-4"></div>
        <div class="col-xs-4"></div>
        <div class="col-xs-4">
            <div class="col-xs-4 amount"  style="border-top: 1pt solid gray">
                <strong>Total</strong>
            </div>
            <div class="col-xs-4 amount"  style="border-top: 1pt solid gray">
                <strong><span class="my-cart-total">${String.format("$ %.2f", netAmount)}</span></strong>
            </div>
        </div>
    </div>

</#macro>


<!-- JS to support steppers -->

<#macro incDecOfferQty minQty >

<script>
    // $(document).ready(function() {
    //     var x = $('.item-quantity');        // set the UI qty to match the user's cart
    //     for(j = 0; j < x.length; j++) {
    //         var id = x[j].id.substring(4);
    //         var k = userCartOffers[id];
    //         if (k === undefined)
    //             k = 0;
    //         x[j].innerText = k + ' in cart ';
    //     }
    //     var y = x;
    // })

    function favoriteBtn(e, offerId) {
        var url = "/shop-api/toggle-favorite?offerId=" + offerId;
        $.get(url, function(data, status){
            var x = '#favorite-' + offerId;
            if (data == "true") {
                $(x).fadeOut();
                $(x).removeClass("fa-heart-o");
                $(x).addClass("fa-heart");
                $(x).fadeIn();
            }
            else {
                $(x).fadeOut();
                $(x).removeClass("fa-heart");
                $(x).addClass("fa-heart-o");
                $(x).fadeIn();
            }
        });
    }

    function decreaseBtn(e, offerId) {
        var x = '#qty-' + offerId;
        $(x).animate({opacity:0}, 300, function() {
            var url = "/shop-api/removeOfferFromCart2?qty=1&offerId=" + offerId + "&minQty=" + ${minQty};
            $.get(url, function(data, status){
                updateUI(data, offerId);
                $(x).animate({opacity: 1});
            });
        });
    }
    function increaseBtn(e, offerId) {
        // if not logged in redirect to login
        <#if ! session.user?? >
            location.assign("/login?offerId=" + offerId);
            return;
        </#if>

        var x = '#qty-' + offerId;
        $(x).animate({opacity:0}, 300, function() {
            var url = "/shop-api/addToCart2?qty=1&offerId=" + offerId;
            $.get(url, function(data, status){
                updateUI(data, offerId);
                $(x).animate({opacity: 1});
            });
        });
    }

    function standingOrderBtn(offerId) {
        var url = "/shop-api/standingOffer?offerId=" + offerId;
        $.get(url, function(data, status){
            location.reload();
        });
    }

    function updateUI(data, offerId) {
        var partsOfStr = data.split('/');   // returns cartCount/offerCount/offerTotal/discount...
        if (partsOfStr.length < 4)
            return;

        var x = '#qty-' + offerId;
        $(x).text(partsOfStr[1] + ' in cart');

        x = '#subtotal-' + offerId;
        $(x).text('$ ' + partsOfStr[2]);

        $(".mini-cart .count").text(partsOfStr[0]);

        for(j = 3; j < partsOfStr.length -1; j++) {
            $('#discount-' + (j - 3)).text('- $ ' + partsOfStr[j]);
        }

        $(".my-cart-total").text('$ ' + partsOfStr[partsOfStr.length - 1]);
    }

    var userCartOffers = {
        <#if session.user?? >
            <#list CartOffer.findByUserIdAndMilkRunIdOrderByTimeDesc(session.user.getId(), openMilkRunId) as co >
                   '${co.getOfferTimestampAsId()}' :
                   '${session.user.getQuantity(openMilkRunId, co.getOfferTimestampAsId())}'
                <#if co?has_next >,</#if>
            </#list>
        </#if>
    };

</script>
</#macro>

