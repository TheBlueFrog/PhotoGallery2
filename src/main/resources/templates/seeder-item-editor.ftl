<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
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
    </style>
</head>
<body class="">
    <header class="header">
        <@topOfPageHeader/>
    </header>

    <div class="maincontainer">
        <form class="form-horizontal container" method="post" >
            <input type="hidden" name="operation" value="editItem" />
            <input type="hidden" name="itemId" value="${session.itemToEdit.id}" />
                    <a href="seeder-home">Seeder Home</a>
                    <h3 class="crimson-text font-italic">Seeder Item</h3>
                    <div class="form-group">
                        <label class="control-label col-sm-2" for="enabled" >Enabled</label>
                        <div class="col-sm-4">
                            <input type="checkbox" id="enabled" name="enabled"
                            <#if session.itemToEdit.enabled >
                                checked
                            </#if>
                            />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-2" for="identification">Identification</label>
                        <div class="col-sm-4">
                            <input class="form-control" id="identification" type="text" name="identification" value="${session.itemToEdit.identification}">
                        </div>
                        <label class="control-label col-sm-2" for="category">Category</label>
                        <div class="col-sm-4">
                            <input class="form-control" id="category" type="text" name="category" value="${session.itemToEdit.category}" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-2" for="shortOne">Short One</label>
                        <div class="col-sm-4">
                            <input class="form-control" id="shortOne" type="text" name="shortOne" value="${session.itemToEdit.shortOne}" required>
                        </div>
                        <label class="control-label col-sm-2" for="shortTwo">short Two</label>
                        <div class="col-sm-4">
                            <input class="form-control" id="shortTwo" type="text" name="shortTwo" value="${session.itemToEdit.shortTwo}">
                        </div>
                        <label class="control-label col-sm-2" for="description">Description</label>
                        <div class="col-sm-4">
                            <input class="form-control" id="description" type="text" name="description" value="${session.itemToEdit.description}" required>
                        </div>
                        <label class="control-label col-sm-2" for="note">Note</label>
                        <div class="col-sm-4">
                            <input class="form-control" id="note" type="text" name="note" value="${session.itemToEdit.note}">
                        </div>
                    </div>

                    <div class="form-group">
                        <input type="submit" value="Update">
                    </div>
        </form>
    </div>

    <div class="col-sm-12">
        <hr >
        <div class="container">
            <form method="post">
                <input type="hidden" name="operation" value="showDisabledOffer" />
                <div>
                    <input type="checkbox" name="showDisabledOffers" onChange="this.form.submit()"
                    <#if session.showDisabledOffers >
                        checked
                    </#if>
                    > Show disabled Offers
                </div>
            </form>
        </div>
        <p></p>

        <label class="col-sm-3"></label>
        <label class="col-sm-2">Enabled</label>
        <!--<label class="col-sm-1">Wholesale</label>-->
        <label class="col-sm-1">Quantity</label>
        <label class="col-sm-1">Units</label>
        <label class="col-sm-1">Price</label>
    </div>

    <#list session.itemToEdit.offers as offer>
        <#if session.showDisabledOffers || offer.enabled>
            <div class="col-sm-12">
                <form class="form-horizontal" method="post" >
                    <input type="hidden" name="operation" value="editOffer" />
                    <input type="hidden" name="offerId" value="${offer.timeAsString}" />
                    <input type="hidden" name="itemId" value="${session.itemToEdit.id}" />
                    <label class="col-sm-1"></label>
                    <div class="form-group">
                        <div class="form-group col-sm-2">
                            <input type="submit" value="Update">
                        </div>
                        <div class="col-sm-2">
                            <input type="checkbox" id="enabled2" name="enabled"
                            <#if offer.enabled >
                                checked
                            </#if>
                            />
                        </div>
<!--
                        <div class="col-sm-1">
                            ${offer.wholesale?string('wholesale', 'retail')}
                        </div>
                        -->
                        <div class="col-sm-1">
                            ${offer.quantity}
                        </div>
                        <div class="col-sm-1">
                            ${offer.units}
                        </div>
                        <div class="col-sm-1">
                            ${offer.price}
                        </div>
                    </div>
                </form>
            </div>
        </#if>
    </#list>

    <div class="col-sm-12">
        <form class="form-horizontal" id="OfferForm" method="post">
            <div class="form-group">
                <label class="col-sm-1"></label>
                <input type="hidden" name="operation" value="createOffer" />
                <input type="hidden" name="createOffer" value="true" />
                <input type="hidden" name="itemId" value="${session.itemToEdit.id}" />
                <input class="col-sm-1" type="submit" value="Create Offer">

               <label class="col-sm-1"></label>
                <div class="col-sm-2">
                    <input type="checkbox" name="enabled" checked />
                </div>
<!--
                <div class="col-sm-2">
                    <input class="form-control" id="wholesale" type="text" name="wholesale" value="wholesale" required>
                </div>
                -->
                <div class="col-sm-1">
                    <input class="form-control" id="quantity" type="text" name="quantity" value="1" required>
                </div>
                <div class="col-sm-1">
                    <input class="form-control" id="units2" type="text" name="units" value="lb" required>
                </div>
                <div class="col-sm-1">
                    <input class="form-control" id="price" type="text" name="price" value="0.00" required>
        </form>
    </div>
    <p></p>
    <a href="seeder-home">Seeder Home</a>


    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
</body>
</html>
