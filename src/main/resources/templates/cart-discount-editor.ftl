<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Seeder Item Editor</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
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
        .mono {
            font-size: 12px;
            font-family:Consolas,Monaco,Lucida Console,Liberation Mono,DejaVu Sans Mono,Bitstream Vera Sans Mono,Courier New, monospace;
        }

    </style>
</head>
<body class="">
    <header class="header">
        <@topOfPageHeader/>
    </header>

    <#assign cartDiscount = session.getAttribute("cartDiscount") >
    <#assign userId = cartDiscount.getDiscountUserId() >
    <#assign user = User.findById(userId) >
    <#assign milkRunId = cartDiscount.getMilkRunId() >
    <#assign milkRun = MilkRunDB.findById(milkRunId) >

    <div class="container-fluid">
        <div class="row col-md-12">
            <div class="col-md-1"></div>
            <div class="col-md-3">
                <a href="/"><strong>Home</strong></a>
                <br>
                <#if UserRole.isAnAdmin(session.getUser().getId()) >
                    <a href="/admin"><strong>Admin Home</strong></a>
                    <br>
                </#if>

                <#if session.getAttributeS("cartDiscount-returnTo")?? >
                    <#assign where = session.getAttributeS("cartDiscount-returnTo") >
                    <#if where[1..10] == "charge-mil" >
                        <#assign dest = "Charge MilkRun" >
                    </#if>

                    <a href="${session.getAttributeS("cartDiscount-returnTo")}"><strong>Back to ${dest}</strong></a>
                    <br>
                </#if>
            </div>
            <div class="col-md-8">
                <h2>Cart Discount Editor</h2>
                <p></p>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="col-sm-5">
            Discounts come in multiple flavors, e.g. percentage or fixed amount.
            If there are multiple discounts and they are of different flavors
            the order that discounts are applied is important.
            <p>
                E.g. a 50% discount followed by a $10.00 off discount on a $50
                order yields a bill of $15.00.
            </p>
            <p>
                E.g. a $10.00 discount followed by a 50% off discount on a $50
                order yields a bill of $20.00.
            </p>
            Discount for ${user.getName()} in MilkRun ${milkRun.getName()}
            <br>
            Authorized by ${User.findById(cartDiscount.getAuthorizingUserId()).getName()}
            <p></p>
            <form method="post" action="/discount/cart?type=standard">
                <h3>Standard Discounts</h3>
                <select id="discountSelect" name="discountSelect"  onchange="discountSelected(this.value)" >
                    <option value="None">None</option>
                    <#list Discount.findAll() as discount >
                        <option value="${discount.getId()}"
                                <#if cartDiscount.getDiscountId() == discount.getId() > selected </#if>
                        >
                            <#if discount.getType().toString() == "Percent" >
                                <#assign d = String.format("%2.0f%%", (discount.getDiscount() * 100.0)) >
                            <#elseif discount.getType().toString() == "Fixed" >
                                <#assign d = String.format("$ %.2f", discount.getDiscount()) >
                            <#else >
                            </#if>
                            ${String.format("%-40.40s%-10.10s%8.8s",
                                discount.getName(),
                                discount.getType().toString(),
                                d).replace(" ", "&nbsp;")}
                        </option>
                    </#list>
                </select>
                <br>
                &nbsp;&nbsp;
                <br>
                <button class="hidden" id="createStandardButton" onclick="this.form.submit()" style="background-color:#BBBBFF"
                        action="/discount/cart">
                    &nbsp;&nbsp;
                    <#if cartDiscount.getTimestamp()?? >
                        Change Standard Discount
                    <#else >
                        Create Standard Discount
                    </#if>
                    &nbsp;&nbsp;
                </button>
            </form>

                <p></p>

            <form method="post" action="/discount/cart?type=custom">
                <h3>Custom Discount</h3>
                    <input type="text"
                           id="customAmount"
                           name="customAmount"
                           placeholder="Custom Amount"
                           onchange="customAmountChanged()"
                           required
                           data-toggle="tooltip" title="Discount amount in dollars"
                           <#if cartDiscount.isCustom() >
                               value="${String.format("%.2f", cartDiscount.getCustomAmount())}"
                           </#if>
                    >
                <br>
                    <input type="text"
                           id="customName"
                           name="customName"
                           placeholder="Note"
                           onchange="customNameChanged()"
                           required
                           data-toggle="tooltip" title="Reason for discount"
                            <#if cartDiscount.isCustom() >
                                   value="${cartDiscount.getCustomName()}"
                            </#if>
                    >
                <br>
                &nbsp;&nbsp;
                <br>
                <button id="createCustomButton"
                        onclick="this.form.submit()"
                        style="background-color:#BBBBFF"
                        action="/discount/cart">
                    &nbsp;&nbsp;
                    <#if cartDiscount.getTimestamp()?? >
                        Change Custom Discount
                    <#else >
                        Create Custom Discount
                    </#if>
                    &nbsp;&nbsp;
                </button>
            </form>
            <p></p>
            <#if session.getAttribute("cartDiscountEditorMode") == "edit" >
                <form method="post" action="/discount/cart/delete">
                    <button onclick="this.form.submit()" style="background-color:#BBBBFF">
                        &nbsp;&nbsp;
                        Delete Discount&nbsp;&nbsp;
                    </button>
                </form>
            </#if>
        </div>
    </div>

    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>

    <script>
        function discountSelected(discountId) {
            if (discountId == 'None') {
                $('#createStandardButton').addClass('hidden');
            }
            else {
                $('#createStandardButton').removeClass('hidden');
            }

            $('#customName')[0].value = '';
            $('#customAmount')[0].value = '0';
        }

        function customAmountChanged() {
            $('#discountSelect').val('None').prop('selected', true);
        }
        function customNameChanged() {
            $('#discountSelect').val('None').prop('selected', true);
        }

        $(document).ready(function() {
//            $('#createButton').addClass('hidden');
        })

    </script>

</body>
</html>
