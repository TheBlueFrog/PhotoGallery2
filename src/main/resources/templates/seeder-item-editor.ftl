<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/html">
<#include "macros.ftl">



<#-- these must always cope with any Item configuration -->
<#--
<#macro pricingModelPackaged item>
    <div id="packagedControls">
        Price
        <input class="form-control"
               id="itemPrice"
               type="number" min="0"
               name="itemPrice"
               style="width: 150px;"
               data-toggle="tooltip"
               title="Total cost to MilkRun for the item
For a $36.00 case of 24 jars of peanut butter this would be $36.00"
               value="${String.format("%.2f", itemPrice.getPrice())}"
               required>
        <br>
        Units
        <input class="form-control"
               id="itemUnits" type="text" name="itemUnits"
               style="width: 150px;"
               data-toggle="tooltip"
               title="Units of the sub-item
For a case of 24 jars of peanut butter this would be jar"
               value="${itemPrice.getUnits()}"
               required>
        <br>
        Quantity
        <input class="form-control"
               type="number" min="1"
               id="itemQuantity"
               name="itemQuantity"
               style="width: 150px;"
               data-toggle="tooltip"
               title="How many sub-items
For a case of 24 jars of peanut butter this would be 24"
               value="${itemPrice.getQuantity()}"
               required>
    </div>
</#macro>

<#macro pricingModelBulk item>
    <div id="bulkControls">
    </div>
</#macro>

-->

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Seeder Item Editor</title>
    <@styleSheets/>

    <style>
        hr {
            display: block;
            margin-top: 0.5em;
            margin-bottom: 0.5em;
            margin-left: auto;
            margin-right: auto;
            border-style: inset;
            border-width: 1px;
        }
        img {
              display: block;
              max-width:200px;
              max-height:200px;
              width: auto;
              height: auto;
            }

        .quantity {
            text-align: center;
        }
        .money {
            margin: 0px;
            padding: 0px;
            text-align: right;
        }
        .money-input {
            width:90px;
            margin: 0px;
            padding: 0px;
            text-align: right;
        }

    </style>
</head>
<body class="">
    <@newTopOfPageHeader "<a href=\"/seeder-update-prices\" class=\"btn btn-link\"><b>MANAGE ITEMS</b></a>" />

    <#assign user = session.getUser() >
    <#assign item = session.getAttribute("seederItem-item") >
    <#--<#assign showDisabledOffers = session.getAttributeB("seederItem-showDisabledOffers") >-->

    <div class="container">
        <div class="row col-md-12">
            <div class="col-md-3">
                <h3>${user.getName()}</h3>
            </div>
            <div class="col-md-2">
                <h3>Item Editor</h3>
            </div>
            <div class="col-md-7">
                <h3>    Item ID ${item.getId()} </h3>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="row" >
            <p></p>
            <ul class="nav nav-tabs">
                <li class="active"><a data-toggle="tab" href="#general">General</a></li>
                <li><a data-toggle="tab" href="#pricing">Pricing</a></li>
                <li><a data-toggle="tab" href="#availability">Availability</a></li>
                <li><a data-toggle="tab" href="#images">Images</a></li>
                <li><a data-toggle="tab" href="#reviews">Reviews</a></li>
            </ul>
            <div class="tab-content">
                <p></p>

                <!-- item general info tab -->
                <div id="general" class="tab-pane fade in active">
                    <div class="row">
                        <div class="col-sm-4">
                            <p>These are the general properties of this particular item.
                        </div>
                        <div class="col-sm-1"></div>
                        <div class="col-sm-4">
                        </div>
                    </div>
                    <form class="form-horizontal container" method="post" action="seeder-item-editor">
                        <input type="hidden" name="operation" value="editGeneral" />
                        <div class="col-sm-2">
                            <#if ! item.isSaved() >
                                <button class="btn" onclick="generalUpdateButton(this.form)" >Save Item</button>
                            <#else >
                                <button class="btn"
                                    data-toggle="tooltip"
title="Updating an item may immediately cause consumer visible price changes.
If the cost of this item changes and there are existing offers with
relative pricing methods (e.g. Percentage) a new Offer will be automatically
constructed with the updated price.
Some pricing methods may not be effected."
                                    onclick="generalUpdateButton(this.form)" >Update Item</button>
                            </#if>
                        </div>
                        <div class="col-sm-10">
                            <div class="row">
                                <div class="col-sm-5">
                                    <input type="checkbox" id="enabled" name="enabled"
                                           data-toggle="tooltip"
                                           title="Is item active or inactive.
Setting an item inactive will also deactive all it's offers.
Setting an item active does not reactive all it's offers."
                                    <#if item.getEnabled() >
                                           checked
                                    </#if>
                                    />Active
                                </div>
                                <div class="col-sm-7">
                                    Active text
                                </div>
                            </div>
                            <p></p>
                            <div class="row">
                                <div class="col-sm-5">
                                    Primary Category<br>
                                    <select class="form-control" id="category1" name="category1"
                                            style="width: 200px"
                                            data-toggle="tooltip" title="Primary MilkRun category of the item" >
                                        <option value="None" selected >None</option>
                                        <#list ItemCategory.getItemCategories() as category>
                                            <option value="${category}"
                                                <#if category == item.getCategory("Primary") > selected </#if>
                                            >
                                                ${category}
                                            </option>
                                        </#list>
                                    </select>
                                </div>
                                <div class="col-sm-7">
                                    Select the primary MilkRun category for this item.
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-5">
                                    Secondary Category<br>
                                    <select class="form-control" id="category2" name="category2"
                                            style="width: 200px"
                                            data-toggle="tooltip" title="Secondary MilkRun category of the item" >
                                        <option value="None" selected >None</option>
                                        <#list ItemCategory.getItemCategories() as category>
                                            <option value="${category}"
                                                <#if category == item.getCategory("Secondary") > selected </#if>
                                            >
                                                ${category}
                                            </option>
                                        </#list>
                                    </select>
                                </div>
                                <div class="col-sm-7">
                                    Select the secondary MilkRun category for this item or None.  <b>None</b> is the same as
                                    selecting the same category as the Primary Category.
                                </div>
                            </div>
                            <p></p>
                            <div class="row">
                                <div class="col-sm-5">
                                    Identification <br>
                                    <input id="identification" type="text" name="identification" value="${item.getIdentification()}">
                                </div>
                                <div class="col-sm-7">
                                    This field is for the supplier use and is ignored by MilkRun.
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-5">
                                    ShortOne<br>
                                    <input id="shortOne" type="text" name="shortOne" placeholder="Required" value="${item.shortOne}" required>
                                </div>
                                <div class="col-sm-7">
                                    text
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-5">
                                    ShortTwo<br>
                                    <textarea id="shortTwo"
                                            name="shortTwo"
                                            rows="2" cols="40" spellcheck="true">
                                        ${item.shortTwo}
                                    </textarea>
                                </div>
                                <div class="col-sm-7">
                                    text
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-5">
                                    Description<br>
                                    <textarea
                                            id="description"
                                            name="description"
                                            placeholder="Required"
                                            rows="4" cols="40" spellcheck="true">
${item.description}
                                    </textarea>
                                </div>
                                <div class="col-sm-7">
                                    text
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-5">
                                    Note<br>
                                    <textarea
                                            id="note"
                                            name="note"
                                            rows="2" cols="40" spellcheck="true">
${item.note}
                                    </textarea>
                                </div>
                                <div class="col-sm-7">
                                    text
                                </div>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- item pricing tab -->
                <div id="pricing" class="tab-pane fade ">
                    <div class="row">
                        <div class="col-sm-4">
                            <p>This tab specifies how the item is supplied to MilkRun.
                        </div>
                        <div class="col-sm-1"></div>
                        <div class="col-sm-4">
                            <p>
                        </div>
                    </div>
                    <form class="form-horizontal container" method="post" action="seeder-item-editor">
                        <input type="hidden" name="operation" value="editPricing" />
                        <div class="col-sm-2">
                            <#if item.getId() == "" >
                                (Item must be saved)
                            <#else >
                                <#if ! item.isSaved() >
                                    <button class="btn" onclick="availabilityUpdateButton(this.form)" >Save Item</button>
                                <#else >
                                    <button class="btn"
                                            data-toggle="tooltip"
                                            title="Updating an item may immediately cause consumer visible price changes.
If the cost of this item changes and there are existing offers with
relative pricing methods (e.g. Percentage) a new Offer will be automatically
constructed with the updated price.
Some pricing methods may not be effected."
                                            onclick="availabilityUpdateButton(this.form)" >Update Item</button>
                                </#if>
                            </#if>
                        </div>
                        <#assign itemPrices = ItemPrice.findByItemIdOrderByTimestampDesc(item.getId()) >
                        <#assign itemPrice = itemPrices?first >
                        <div class="col-sm-10">
                            <div class="row">
                                <div class="col-sm-3">
                                    Price<br>
                                    <input class="form-control"
                                           id="itemPrice"
                                           type="number" min="0"  step="0.01"
                                           name="itemPrice"
                                           style="width: 150px;"
                                           data-toggle="tooltip"
                                           title="Total cost to MilkRun for the item
For a $36.00 case of 24 jars of peanut butter this would be $36.00"
                                           value="${String.format("%.2f", itemPrice.getPrice())}"
                                           required>
                                </div>
                                <div class="col-sm-4">
                                    Set the cost to MilkRun of each of these items.
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-3">
                                    Units<br>
                                    <input class="form-control"
                                           id="itemUnits" type="text" name="itemUnits"
                                           style="width: 150px;"
                                           data-toggle="tooltip"
                                           title="Units of the sub-item
For a case of 24 jars of peanut butter this would be jar"
                                           value="${itemPrice.getUnits()}"
                                           required>
                                </div>
                                <div class="col-sm-4">
                                    Set the units of the item supplied to MilkRun.
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-3">
                                    Quantity<br>
                                    <input class="form-control"
                                           type="number" min="1"
                                           id="itemQuantity"
                                           name="itemQuantity"
                                           style="width: 150px;"
                                           data-toggle="tooltip"
                                           title="How many sub-items
For a case of 24 jars of peanut butter this would be 24"
                                           value="${itemPrice.getQuantity()}"
                                           required>
                                </div>
                                <div class="col-sm-4">
                                    Set the quantity of the above units which is supplied to MilkRun.
                                </div>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- item availability tab -->
                <div id="availability" class="tab-pane fade ">
                    <div class="row">
                        <div class="col-sm-4">
                            <p>This tab specifies the availability of the item.
                                <br>
                                Some items have essentially unlimited availability.  Other items
                                may have very limited quantities available.
                        </div>
                        <div class="col-sm-1"></div>
                        <div class="col-sm-4">
                            <p> Setting the available quantity establishes a limit to how many
                                units
                                of this item are available to be put in to customer carts in the
                                current MilkRun.  As items are consumed
                            this value will be decresed.  At zero the item is no longer available.
                            <br> Items with zero availability are visible to customers but cannot
                            be added to carts.
                        </div>
                    </div>
                    <form class="form-horizontal container" method="post" action="seeder-item-editor">
                        <input type="hidden" name="operation" value="editAvailability" />
                        <div class="col-sm-2">
                            <#if item.getId() == "" >
                                (Item must be saved)
                            <#else >
                                <#if ! item.isSaved() >
                                    <button class="btn" onclick="pricingUpdateButton(this.form)" >Save Item</button>
                                <#else >
                                    <button class="btn"
                                            data-toggle="tooltip"
                                            title="Updating an item may immediately cause consumer visible price changes.
If the cost of this item changes and there are existing offers with
relative pricing methods (e.g. Percentage) a new Offer will be automatically
constructed with the updated price.
Some pricing methods may not be effected."
                                            onclick="pricingUpdateButton(this.form)" >Update Item</button>
                                </#if>
                            </#if>
                        </div>
                        <div class="col-sm-10">
                            Available Quantity &nbsp;&nbsp;&nbsp;How many item units are available.
                            <#if (item.getId() != "" ) && ItemAvailability.findByItemId(item.getId())?? >
                                <#assign available = ItemAvailability.findByItemId(item.getId()).getAvailableQuantity() >
                            <#else >
                                <#assign available = "Unlimited" >
                            </#if>
                            <input class="form-control"
                                   id="quantity"
                                   name="quantity"
                                   type="number" min="0"
                                   style="width: 150px;"
                                   data-toggle="tooltip"
title="How many of the item units are avaliable for purchase.
Enter Unlimited or blank for an unlimited supply."
                                   value="${available}">
                            <br>
                        </div>
                    </form>
                </div>

                <!-- item image links tab -->
                <div id="images" class="tab-pane fade ">
                    <div class="row">
                        <div class="col-sm-4">
<p>Manage the linkage between this item and its images.  Items have
a single Main image which is used by default.  Other images are
displayed as a set of thumbnails on the single-item page.
                        </div>
                        <div class="col-sm-1"></div>
                        <div class="col-sm-4">
<p>Items with more than one image should have thumbnails for each image.
Thumbnails are files with the same name (inluding extension) in the <i>images/thumbnails</i> directory.
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-2"></div>
                        <div class="col-sm-3">Image</div>
                        <div class="col-sm-2">Usage</div>
                        <div class="col-sm-3">File name</div>
                        <div class="col-sm-2">Caption</div>
                    </div>

                    <#list item.images as image>
                        <div class="row">
                            <form method="post" >
                                <input type="hidden" name="operation" value="deleteImageLink" />
                                <input type="hidden" name="imageId" value="${image.getId()}" />
                                <div class="form-group col-sm-1">
                                    <input type="submit" value="Delete">
                                </div>
                            </form>
                            <form method="post" >
                                <input type="hidden" name="operation" value="updateImageLink" />
                                <input type="hidden" name="imageId" value="${image.id}" />
                                <div class="col-sm-1">
                                    <input type="submit" value="Update">
                                </div>
                                <div class="col-sm-3">
                                    <img src="${image.path}" width="100%" height="100%" />
                                </div>
                                <div class="col-sm-2">
                                    <input type="text"
                                           style="width: 80%" name="usage"
                                            data-toggle="tooltip"
title="The image with usage of Main will be used
as the starting image.  Anything else indicates a secondary image"
                                            placeholder="" value="${image.usage}"/>
                                </div>
                                <div class="col-sm-3">
                                    <select name="filename">
                                        <#list session.getAttribute("seederItem-imageFiles") as diskImage>
                                            <option value="${diskImage}"
                                                <#if diskImage == image.filename >
                                                    selected
                                                </#if>
                                            >${diskImage}</option>
                                        </#list>
                                    </select>
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" name="caption" placeholder="" value="${image.caption}"/>
                                </div>
                            </form>
                        </div>
                    </#list>
                    <p></p>
                        <div class="row" >
                            <form method="post" >
                                <input type="hidden" name="operation" value="createImageLink" />
                                <div class="col-sm-1">
                                    <input type="submit" value="Create">
                                </div>
                                <div class="col-sm-1"></div>
                                <div class="col-sm-3" >
                                    &nbsp;
                                </div>
                                <div class="col-sm-2">
                                    <input type="text"
                                            data-toggle="tooltip"
title="The image with usage of Main will be used
as the starting image.  Anything else indicates a secondary image"
                                            style="width: 80%" name="usage" placeholder="Usage" value=""/>
                                </div>
                                <div class="col-sm-3">
                                    <select name="filename">
                                        <#list session.getAttribute("seederItem-imageFiles") as diskImage>
                                            <option value="${diskImage}">${diskImage}</option>
                                        </#list>
                                    </select>
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" name="caption" placeholder="Caption" value=""/>
                                </div>
                            </form>
                        </div>
                    </form>
                </div>
                <div id="reviews" class="tab-pane fade ">
                    <div class="row">
                        <div class="col-sm-4">
                            <p>This tab displays the existing customer reviews of this item.
                        </div>
                        <div class="col-sm-1"></div>
                        <div class="col-sm-4">
                            <p>
                        </div>
                    </div>
                    <input type="hidden" name="tab" value="reviews" />
                    <div class="container">
                        <div class="col-sm-1"></div>
                        <div class="col-sm-1"></div>
                        <div class="col-sm-1"><b>Date</b></div>
                        <div class="col-sm-2"><b>By</b></div>
                        <div class="col-sm-1"><b>Stars</b></div>
                        <div class="col-sm-5"><b>Body</b></div>
                        <br>
                    <#list item.offers as offer>
                        <#if offer.enabled>
                            <#list Rating.findByItemIdOrderByTimestampDesc(offer.getItemId()) as rating >
                                <row>
                                    <div class="col-sm-1"></div>
                                    <div class="col-sm-1">
                                    ${Util.formatTimestamp(rating.getTime(), "MMM dd YYYY")}
                                    </div>
                                    <div class="col-sm-2">
                                    ${rating.getRater().getName()}
                                    </div>
                                    <div class="col-sm-1">
                                    ${rating.getRating()}
                                    </div>
                                    <div class="col-sm-5">
                                    ${rating.getBody()}
                                    </div>
                                </row>
                            </#list>
                        </#if>
                    </#list>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <p>&nbsp;</p>
    <p>&nbsp;</p>

    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>

    <script>
        $(document).ready(function(){
            // not good, this just happens to match default for a new
            // item...
            $('#bulkControls').hide();
            $('#packagedControls').show();
        });

        function priceModelChanged(model) {
            if (model == 'Packaged') {
                $('#bulkControls').hide();
                $('#packagedControls').show();
            }
            if (model == 'Bulk') {
                $('#packagedControls').hide();
                $('#bulkControls').show();
            }
        }

        function generalUpdateButton(theForm) {
            if ($('#shortOne')[0].value === '') {
                alert("Item must have the field ShortOne defined.")
                return;
            }
            if ($('#category1')[0].value === 'None') {
                alert("Item must have a Primary Category defined.")
                return;
            }

            theForm.submit();
        }

        function pricingUpdateButton(theForm) {
            theForm.submit();
        }

        function availabilityUpdateButton(theForm) {
            theForm.submit();
        }
    </script>
</body>
</html>
