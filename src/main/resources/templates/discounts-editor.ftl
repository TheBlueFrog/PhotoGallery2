<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/html">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Discount Editor</title>
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
        .total {
            width:90px;
            margin: 0px;
            padding: 0px;
            text-align: right;
        }

    </style>
</head>
<body class="">
    <header class="header">
        <@topOfPageHeader/>
    </header>

    <div class="container-fluid">
        <div class="row">
            <div class="col-md-1"></div>
            <div class="col-md-3">
                <a href="/"><strong>Home</strong></a>
                <br>
                <#if UserRole.isAnAdmin(session.getId()) >
                    <a href="/admin"><strong>Admin Home</strong></a>
                    <br>
                </#if>
            </div>
            <div class="col-md-8">
                <h2>Discount Editor</h2>
                <p></p>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="row">
            <div class="col-sm-1">
            </div>
            <div class="col-sm-5">
                Use this page to define discounts in the system.  Once defined
                a discount may be applied to a particular charge.
                <p>
                    There are two types of discounts, <b>Fixed</b> and <b>Percent</b>.
                    <ul>
                        <li>Fixed discounts are for a fixed dollar amount.  This
                            is simply subtracted from the gross charge.  Fixed
                            discounts can not be so large that the net amount goes
                            negative.
                        </li>
                        <li>
                            Percent discounts are a percentage of the gross
                            charge.
                        </li>
                    </ul>
                </p>
            </div>
        </div>

        <div class="row">
            <div class="col-sm-1">

            </div>
            <div class="col-sm-1">
                <strong>Type</strong>
            </div>
            <div class="col-sm-2">
                <strong>Amount</strong>
            </div>
            <div class="col-sm-3">
                <strong>Name</strong>
            </div>
            <div class="col-sm-3">
                <strong>Example - $10 charge</strong>
            </div>
        </div>

        <#assign discount = session.getAttribute("discount") >

        <!--  a prototype discount that can be edited and saved -->
        <div class="row">
            <form method="post" action="/discounts">
                <div class="col-sm-1">
                    <button  class="btn" onclick="this.form.submit()" >
                        &nbsp;&nbsp;
                        Save
                        &nbsp;&nbsp;
                    </button>
                </div>
                <div class="col-sm-1">
                    <select name="discountType" >
                        <option value="Fixed"
                        <#if discount.getType().toString() == "Fixed" > selected </#if>
                        > Fixed</option>

                        <option value="Percent"
                        <#if discount.getType().toString() == "Percent" > selected </#if>
                        > Percent </option>
                    </select>
                </div>
                <div class="col-sm-2">
                    <#assign d = discount.getDiscount() >
                    <#if discount.getType().toString() == "Percent" >
                        <#assign d = d * 100.0 >
                    </#if>
                    <input type="text"
                           name="discountAmount"
                           placeholder="Discount"
                           value="${d}" required>
                </div>
                <div class="col-sm-3">
                    <input type="text"
                           name="name"
                           placeholder="Name"
                           value="${discount.getName()}" required>
                </div>
                <div class="col-sm-5">
                    <div class="col-sm-2">
                        Discount
                        <br>Net
                    </div>
                    <div class="col-sm-4 money">
                    ${String.format("%.2f", discount.getAmount(10.0))}
                        <br><span  style="border-top: 1pt solid gray">
                                $ ${String.format("%.2f", (10.0 - discount.getAmount(10.0)))}
                            </span>
                    </div>
                    <div class="col-sm-6">
                        <p>&nbsp;</p>
                    </div>
                </div>
            </form>
        </div>
<p></p>
        <!--  list of existing discounts, no delete, no edit -->
        <#list Discount.findByOrderByName() as discount >
            <div class="row">
                <div class="col-sm-1">
                </div>
                <div class="col-sm-1">
                     ${discount.getType().toString()}
                </div>
                <div class="col-sm-2">
                    <#assign d = discount.getDiscount() >
                    <#if discount.getType().toString() == "Percent" >
                        <#assign d = d * 100.0 >
                    </#if>
                    ${d}
                </div>
                <div class="col-sm-3">
                    ${discount.getName()}
                </div>
            </div>
        </#list>
    </div>

    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
</body>
</html>
