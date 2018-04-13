<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<#assign user = session.getUser() >
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Stripe Charge</title>
    <@styleSheets/>
    <link rel="stylesheet" href="/css/payment.css">
    <script src="https://js.stripe.com/v3/"></script>
</head>
<body class="">
    <@pageHeader "cart.html"/>
    <section class="banner banner-short banner-cart bg-parallax">
        <div class="overlay"></div>
        <div class="container">
            <div class="banner-content text-center">
                <h2 class="page-title">Stripe Charge Details</h2>
                <div class="breadcrumbs">
                    <a href="/">Home</a>
                    <span>Stripe Charge Details</span>
                </div>
            </div>
        </div>
    </section>

    <@messageHeader session.getAttributeS("stripeChargeController-message") />

    <#assign charge = stripeCharge.getCharges()?first >

    <div class="maincontainer">
        <div class="container">
            <div class="row">
                <div class="col-md-2">
                </div>
                <div class="col-md-8">
                    <h3>Details of Stripe Payment ${charge.getId()}</h3>
                </div>
            </div>

            <#if session.user?? >
                <div class="row">
                    <div class="col-sm-12">
                        <table class="shop_table cart">
                            <thead>
                                <tr>
                                    <th class="product-name"></th>
                                    <th class="product-name"></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="product-name">Description</td>
                                    <td class="product-name">${charge.getDescription()}</td>
                                </tr>
                                <tr>
                                    <td class="product-name">Amount</td>
                                    <td>
                                        ${String.format("$ %.2f", StripeCharge.toDollars(charge.getAmount()))}
                                    </td>
                                </tr>
                                <tr>
                                    <td class="product-name">Status</td>
                                    <td class="product-name">${charge.getStatus()}</td>
                                <tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </#if>
        </div>
    </div>
    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>

    <script>
    </script>

</body>
</html>