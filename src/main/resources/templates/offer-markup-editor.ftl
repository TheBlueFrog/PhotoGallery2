<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Offer Markup Editor</title>
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
        <row class="col-sm-12">
            <div class="col-sm-1"></div>
            <div class="col-sm-6">
                <p></p>
                <a href="/system"><h4>Back to System Management</h4></a>
                <p></p>
                <h3>Offer Markup Editor</h3>
                <p>
                    Seeder's set their price for items in the item's offers.  This is
                    effectively the wholesale price.  MilkRun marks these prices up
                    before displaying them to customers.
                <p>
                <p>
                    Currently, items are tagged with a category, this category determines
                    the markup applied to the offer when it is displayed to customers.
                    A markup value is a multiplier, a value of 1.0 will not change the
                    offer price.  A value of 0.0 will make the offer price $0.00.  Hence values
                    less than 1.0 are essentially discounts, values greater than 1.0
                    increase the displayed price.
                </p>
                <p>
                    Each category has multiple markup values, different ones are used
                    depending on the role of the user seeing the price.  Currently there
                    are three different markup values available, one to show to Eaters,
                    one for Feeders and one for all other users.
                </p>
                <p>
                    There can only be one row for a given category.
                </p>
            </div>
        </row>
        <row>
            <div class="col-sm-1"></div>
            <div class="col-sm-2"></div>
            <div class="col-sm-2">Category</div>
            <div class="col-sm-2">Eater Markup</div>
            <div class="col-sm-2">Feeder Markup</div>
            <div class="col-sm-2">Other Markup</div>
            <div class="col-sm-1"></div>
        </row>
    </div>
    <div class="maincontainer">
        <#list session.offerMarkups as markup>
            <row class="col-sm-12">
                <form class="form-horizontal" method="post" >
                    <input type="hidden" name="operation" value="updateMarkup" />
                    <label class="col-sm-1"></label>
                    <div class="form-group">
                        <div class="form-group col-sm-2">
                            <input type="submit" value="Update">
                        </div>
                        <div class="col-sm-2">
                            ${markup.category}
                        </div>
                        <div class="col-sm-2">
                            <input type="text" name="eaterMarkup" placeholder="" value="${markup.eaterMarkup}"/>
                        </div>
                        <div class="col-sm-2">
                            <input type="text" name="feederMarkup" placeholder="" value="${markup.feederMarkup}"/>
                        </div>
                        <div class="col-sm-2">
                            <input type="text" name="otherMarkup" placeholder="" value="${markup.otherMarkup}"/>
                        </div>
                    </div>
                </form>
            </row>
        </#list>
    </div>
    <hr>
    <div class="col-sm-12">
        <form class="form-horizontal" id="OfferForm" method="post">
            <div class="form-group">
                <label class="col-sm-1"></label>
                <input type="hidden" name="operation" value="createMarkup" />
                <input class="col-sm-2" type="submit" value="Create Markup">

                <div class="col-sm-2">
                    <input class="form-control" type="text" name="category" value="" required>
                </div>
                <div class="col-sm-2">
                    <input class="form-control" type="text" name="eaterMarkup" value="1.0" required>
                </div>
                <div class="col-sm-2">
                    <input class="form-control" type="text" name="feederMarkup" value="1.0" required>
                </div>
                <div class="col-sm-2">
                    <input class="form-control" type="text" name="otherMarkup" value="1.0" required>
        </form>
    </div>
    <p></p>
    <p></p>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
</body>
</html>
