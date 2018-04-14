<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Support</title>
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
    <@pageHeader3 "support.ftl"/>

    <section class="banner banner-about bg-parallax">
        <div class="overlay"></div>
        <div class="container">
            <div class="banner-content text-center">
                <h2 class="page-title"><img src="/images/thelook/MilkRun_logo_white.png" alt="MilkRun Farm Delivery" /></h2>
                <div class="breadcrumbs">
                    <a href="shop-list-view3">Home</a>
                    <span>Request Support</span>
                </div>
            </div>
        </div>
    </section>

    <div class="maincontainer">
        <form class="form-horizontal container"  name="login" method="post">
            <div class="row">
                <div class="col-sm-5 col-md-5 col-lg-5">
                    <div class="form-group">
                        <p></p>
                        <p></p>
                        <h5>Request support from ${system.site.Company}</h5>
                        <p>We will respond by email shortly.  Thanks for your patience while
                        we get things up and running smoothly.</p>
                    </div>
                    <div class="form-group">
                        <label >Email address we should respond to</label>
                        <input type="email" class="form-control" name="email" placeholder="Your email">
                    </div>
                    <div class="form-group">
                        <label >What can we help with?</label>
                        <input type="text" class="form-control" name="message" placeholder="Your request">
                    </div>
                    <div class="form-group">
                        <input type="hidden" name="operation" value="RequestSupport" />
                        <button class="cart-button">Submit</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
</body>
</html>