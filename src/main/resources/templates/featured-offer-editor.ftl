<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Manage Featured Offers</title>
    <@styleSheets/>

    <style>

    .cart-button {
            color: inherit;
            font-size: 11px;
            padding: 2px 12px;
            display: inline-block;
            margin 0;
            margin-top: 15px;
            border-top: 1px solid #e9e9e9;
            border-bottom: 1px solid #e9e9e9;
        }

    .mine1 {
        padding: 0;
        margin: 0;
        color: #000000;
            border-top: 1px solid #a9a9a9;
            border-bottom: 0px solid #b9b9b9;
    }
    .mine4 {
        padding: 0;
        margin: 0;
        font-size: 12px;
        text-align: left;
        color: #000000;
            border-top: 0px solid #e9e9e9;
            border-bottom: 0px solid #FF0000;
    }
    .mine5 {
        padding: 0;
        margin: 0;
        text-align: left;
    }

    </style>

</head>
<body class="">
    <@pageHeader3 />

    <p></p>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-2">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="admin"><strong>Admin Home</strong></a>
            </div>
            <div class="col-md-6">
                <h4>Manage Featured Offers</h4>
            </div>
            <div class="col-md-3">
            </div>
        </div>
    </div>

    <p></p>

    <div class="container-fluid">
        <div class="row">
            <div class="col-sm-1" ></div>
            <div class="col-sm-5" >
            </div>
            <div class="col-sm-1" ></div>
            <div class="col-sm-4" >
            </div>
        </div>
        <p></p>
        <div class="row">
            <div class="col-sm-2" ></div>
            <div  class="col-sm-1"><strong>Supplier</strong></div>
            <div  class="col-sm-2"><strong>Item</strong></div>
            <div  class="col-sm-1"><strong>Qty/Units</strong></div>
            <div  class="col-sm-1"><strong>Sell Price</strong></div>
            <div  class="col-sm-1"><strong>Start Time</strong></div>
            <div  class="col-sm-1"><strong>End Time</strong></div>
        </div>

        <#list FeaturedOffer.findAll() as featured >
            <#assign offer = Offer.findByTimestamp(featured.getOfferId()) >
            <div class="row">
                <div class="col-sm-1" ></div>

                <div  class="col-sm-1 mine1">
                        <input type="button"
                               id="${featured.getId()}"
                               value="Delete"
                                onclick="deleteFeatured(this)"/>
                </div>

                <div  class="col-sm-1 mine1">${offer.getItem().getSupplier().getCompanyName()}</div>
                <div  class="col-sm-2 mine1">${offer.getItem().getShortOne()}</div>
                <div  class="col-sm-1 mine1">
                    <div class="col-sm-3">${offer.getQuantity()}</div>
                    <div class="col-sm-9">${offer.getUnits()}</div>
                </div>
                <div  class="col-sm-1 mine1">${offer.getOurSellPriceAsString()}</div>

                <div  class="col-sm-1 mine1">
                    <div  class="col-sm-1 mine1">
                        <input class="mine5"
                               type="text"
                               maxlength="10" size="10"
                               id="startTime-${featured.getId()}"
                               value="${Util.formatTimestamp(featured.getStartTime(), "MM/dd/YY")}"
                        />
                    </div>
                </div>
                <div  class="col-sm-1 mine1">
                    <div  class="col-sm-1 mine1">
                        <input class="mine5"
                               type="text"
                               maxlength="10" size="10"
                               id="stopTime-${featured.getId()}"
                               value="${Util.formatTimestamp(featured.getStopTime(), "MM/dd/YY")}"/>
                    </div>
                </div>

                <div  class="col-sm-1 mine1">
                    <input type="button"
                           id="${featured.getId()}"
                           value="Update"
                           onclick="updateFeatured(this.id)"/>
                </div>

            </div>
        </#list>
        <p>
        </p>
        <div class="row">
            <div  class="col-sm-1"></div>
            <div  class="col-sm-1">Add new Offer</div>
            <div class="col-sm-5">
                <select id="newOffer"  onchange="newOfferChanged()">
                    <option value=""></option>
                    <#list Offer.findEnabled() as offer >

                        <#if offer.getItem().getImage("Main")??>
                            <option value="${offer.getTimeAsId()}" >
                                ${offer.getItem().getSupplier().getCompanyName()}
                                -&nbsp;
                                ${offer.getItem().getShortOne()}
                            </option>
                        <#else>
                            <option value="${offer.getTimeAsId()}" disabled>
                                ${offer.getItem().getSupplier().getCompanyName()}
                                -&nbsp;
                                ${offer.getItem().getShortOne()}
                                - No image
                            </option>
                        </#if>       

                        
                    </#list>
                </select>
            </div>
        </div>
    </div>
    <p></p>


    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
    <script>
    function newOfferChanged() {
        var x = document.getElementById('newOffer').value;
        if (x != '')
            location.assign("/featured-offer-editor/add/" + x);
    }
    function updateFeatured(id) {
        var start = document.getElementById('startTime-' + id).value;
        var stop = document.getElementById('stopTime-' + id).value;
        var startD = new Date(start);
        var stopD = new Date(stop);
        var startM = startD.getTime();
        var stopM = stopD.getTime();
        var url = "/featured-offer-editor/update/" + id + "/" + startM + "/" + stopM;
        location.assign(url);
    }
    function deleteFeatured(b) {
        location.assign("/featured-offer-editor/remove/" + b.id);
    }
    </script>
</body>
</html>