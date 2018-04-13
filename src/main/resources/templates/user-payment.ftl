<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">

<#assign user = session.getUser() >

<#if StripeCustomer.findByUserId(user.getId())?? >
    <#assign isStripeCustomer = true >
<#else >
    <#assign isStripeCustomer = false >
</#if>

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Payments</title>
    <@styleSheets/>
    <link rel="stylesheet" href="/css/payment.css">
    <script src="https://js.stripe.com/v3/"></script>

    <style>
        td {
            text-align: left;
            vertical-align: text-top;
        }
        .td-total {
            text-align: right;
        }

    </style>
</head>
<body class="">
    <@newTopOfPageHeader "" />

    <section class="banner banner-short banner-cart bg-parallax">
        <div class="overlay"></div>
        <div class="container">
            <div class="banner-content text-center">
                <h2 class="page-title">Payments</h2>
                <div class="breadcrumbs">
                    <a href="/">Home</a>
                    <span>PAYMENTS</span>
                </div>
            </div>
        </div>
    </section>

    <@messageHeader session.getAttributeS("userPaymentController-message") />

    <div class="container">
        <p></p>
        <div class="row">
            <div class="col-sm-1"></div>
            <div class="col-sm-2">
                <input type="checkbox" name="autopay" onChange="changeAutopay(this.checked)"
                <#if user.getAutoAddMeToRun() >
                       checked
                </#if>
                ><strong>Auto-Checkout</strong>
            </div>
            <div class="col-sm-5">

            <#if isStripeCustomer >
                <#if user.getAutoAddMeToRun() >
                    I agree to have MilkRun automatically charge my credit card
                    for the items in my cart when each MilkRun is closed.
                <#else >
                    Auto-Checkout will automatically place my order each week.
<p>
If not checked I will have to CHECKOUT each week or my order will
                    not be placed and my order will not be delivered.
                    <p></p>
                    <b>Note</b> Adding or removing items to my cart does change the amount
                    my credit card will be charged but does not cancel my order.
                    The cart always shows the current total.
                </#if>
            <#else >
                <#if user.getAutoAddMeToRun() >
                    I agree to pay MilkRun for the items I order each week.
                <#else >
                    I agree that unless I CHECKOUT each week my order will
                    not be placed or delivered.
                    <p></p>
                </#if>
            </#if>
            </div>
        </div>

        <p></p>
    <#if session.user?? >
            <div class="row">
                <!-- if Stripe customer display their cards -->
                <div class="col-sm-1"></div>
                <div class="col-sm-8">
                    <p></p>
                    <#if isStripeCustomer >
                        <h4>Current Credit Cards</h4>
                        <#assign customer = StripeCustomer.findByUserId(user.getId()) >
                        <p></p>
                        <form method="post">
                            <table>
                                <thead>
                                <tr>
                                    <th class="product-name" width="10%">Active</th>
                                    <th class="product-name" width="15%">Issuer</th>
                                    <th class="product-name" width="10%">Last 4</th>
                                    <th class="product-name" width="30%">Name on Card</th>
                                    <th class="product-name" width="10%">Expiration</th>
                                    <th class="product-name" width="5%"></th>
                                </tr>
                                </thead>
                                <tbody>
                                    <#assign selectedCardId = "None" >
                                    <#list customer.getCards() as card >
                                        <tr>
                                            <td>
                                                <input type="radio"
                                                       onChange="this.form.submit()"
                                                       name="cardSelector"
                                                       value="${card.getId()}"
                                                    <#if customer.getActiveCardId() == card.getId() >
                                                        <#assign selectedCardId = card.getId() >
                                                        checked
                                                    </#if>
                                                >
                                            </td>
                                            <td> ${card.getBrand()} </td>
                                            <td> ${card.getLast4()} </td>
                                            <td> ${card.getName()} </td>
                                            <td> ${card.getExpMonth()} / ${String.format("%d", card.getExpYear())} </td>
                                            <td>
                                                <button class="btn" name="removeCard-${card.getId()}" onclick="this.form.submit()">Remove</button>
                                            </td>
                                        </tr>
                                    </#list>

                                    <#--<tr>-->
                                        <#--<td>-->
                                            <#--<input type="radio"-->
                                                   <#--onChange="this.form.submit()"-->
                                                   <#--name="cardSelector"-->
                                                   <#--value="None"-->
                                                   <#--<#if selectedCardId == "None"> checked </#if>-->
                                            <#-->-->
                                        <#--</td>-->
                                        <#--<td>None</td>-->
                                        <#--<td>-->
                                        <#--</td>-->
                                    <#--</tr>-->
                                </tbody>
                            </table>
                            <p></p>
                            <a href="#" data-toggle="modal" data-target="#modalPayment" class="btn btn-primary">Add Another Credit Card</a>
                        </form>
                    <#else >
                        <h4>Credit Cards</h4>
                        <br>
                        <p>&nbsp;</p>
                    </#if>
                </div>
            </div>

            <!-- if customer display their past charges else prompt -->
            <#if isStripeCustomer >

                <div class="row">
                    <div class="col-sm-1"></div>
                    <div class="col-sm-10">
                        <p>&nbsp;</p>
                        <h4>Past Credit Card Charges</h4>

                        <@pastStripeCharges user />
                    </div>
                </div>
            <#else>
                <br>
                <a href="#" data-toggle="modal" data-target="#modalPayment" class="btn btn-primary">Add Credit Card</a>
            </#if>
        </#if>
    </div>
    <p>&nbsp;</p>

    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>


    <div id="modalPayment" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog add-to-cart-wrapper" role="document">
            <form action="/charge" method="post" id="payment-form">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title" id="modalTitle">Payment Details</h4>
                    </div>
                    <div class="modal-body" id="modalBody">
                        <div class="group">
                            <label>
                                <span>Name</span>
                                <input name="cardholder-name" class="field" placeholder="Jane Doe" />
                            </label>
                            <label>
                                <span>Phone</span>
                                <input name="cardholder-phone" class="field" placeholder="(123) 456-7890" type="tel" />
                            </label>
                        </div>
                        <div class="group">
                            <label>
                                <span>Card</span>
                                <div id="card-element" class="field"></div>
                            </label>
                        </div>                        
                        <div class="outcome">
                            <div class="error" role="alert"></div>
                            <div class="success">
                                Success! Your Stripe token is <span class="token"></span>
                            </div>
                        </div>                                                
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>                
                        <button type="submit" class="btn btn-primary">
                            <#if StripeCustomer.findByUserId(user.getId())?? >
                                Add Card
                            <#else >
                                Setup Account
                            </#if>
                        </button>
                    </div>
                </div><!-- /.modal-content -->
            </form>
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
    <script>

        function changeAutopay(autopay) {
            var url = "/stripe-payment-api/set?key=autoAddMeToRun&value=";
            if (autopay) {
                url += "true";
            } else {
                url += "false";
            }
            $.get(url, function(data, status){
                location.assign("/user-payment");
            });
        }

        var uid = "${user.getId()}";
        var stripePublishableKey =  "${system.getStripePublishableKey()}";//"pk_test_4oYUrXnbImBrmsV7W2zRibcM";
        var nextPage = "/user-payment";

    </script>
    <script src="js/payment.js"></script>

</body>
</html>
