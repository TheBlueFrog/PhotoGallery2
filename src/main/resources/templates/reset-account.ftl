<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Reset Account</title>
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

    </style>

</head>
<body class="">
    <@pageHeader3 />

    <section class="banner banner-about bg-parallax">
        <div class="overlay">       </div>
        <div class="container">
            <div class="banner-content text-center">
                <h2 class="page-title"><img src="/images/thelook/MilkRun_logo_white.png" alt="MilkRun Farm Delivery" /></h2>
                <div class="breadcrumbs">
                    <a href="shop-list-view2">Home</a>
                    <span>Reset Login</span>
                </div>
            </div>
        </div>
    </section>

    <div class="container">
        <row class="col-sm-12">
            <div class="col-sm-1 col-md-1 col-lg-1"></div>
            <div class="col-md-6">
                <p></p>
                <h4>Your login has been reset</h4>

                <p></p>
                <p>
                    You should have received an email with a link that
                    allows you to set a new password.
                </p>
            </div>
        </row>
    </div>
    <p></p>

    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>


</body>
</html>