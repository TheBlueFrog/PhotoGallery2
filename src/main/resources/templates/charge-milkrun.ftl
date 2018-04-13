<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/html">
<#include "macros.ftl">
<#include "macros-milkrun.ftl">

<#if pageState.haveMoneySummary()  >
    <#assign milkRun = MilkRunDB.findById(pageState.getMoneySummary().getMilkRunId()) >
    <#assign openMilkRun = (milkRun.getState().toString() == "Open") >
    <#assign haveInvalidAddress = false >
</#if>

<#if ! session.getAttribute("milkrun-open-charge-show-email")?? >
    <#assign showEmail = false >
<#else >
    <#assign showEmail = session.getAttributeB("milkrun-open-charge-show-email") >
</#if>

<#macro headers>
    <thead>
        <th width="5%"></th>
        <th width="15%"></th>
        <th width="10%"></th>
        <th width="10%"></th>
        <th width="30%"></th>
        <th width="15%"></th>
        <th width="15%"></th>
    </thead>
</#macro>
<#macro headersStripe>
    <thead>
    <th width="5%"></th>
    <th width="15%"></th>
    <th width="10%"></th>
    <th width="10%"></th>
    <th width="30%"></th>
    <th width="10%"></th>
    <th width="10%"></th>
    <th width="10%"></th>
    </thead>
</#macro>

<#macro nonStripeButtons buyerId amount >
    <#if milkRun.getState().toString() == "Closing" >
        <button class="btn btn-link btn-sm" onClick="moveToOpen('${buyerId}')">Move to Open</button>
        <br>
    </#if>
    <#if openMilkRun || (milkRun.getState().toString() == "Closing") >
        <button class="btn btn-link btn-sm" onClick="deleteCart('${buyerId}')">Delete</button>
        <br>
    </#if>
    <button class="btn btn-link btn-sm" onClick="createCartDiscount('${buyerId}')">Discount</button>
</#macro>

<#macro stripeButtons buyerId amount >
    <#if milkRun.getState().toString() == "Closing" >
        <button class="btn btn-link btn-sm" onClick="moveToOpen('${buyerId}')">Move to Open</button>
        <br>
    </#if>
    <#if openMilkRun || (milkRun.getState().toString() == "Closing") >
        <button class="btn btn-link btn-sm" onClick="deleteCart('${buyerId}')">Delete</button>
        <br>
    </#if>

    <!-- MR-439 disallow adding discounts after Stripe has been charged -->
    <#if (StripeCharge.findByUserIdAndMilkRunIdOrderByTimestampDesc(buyerId, milkRun.getId()).getCharges()?size == 0) >
        <button class="btn btn-link btn-sm" onClick="createCartDiscount('${buyerId}')">Discount</button>
    </#if>
</#macro>

<#macro addNote buyerId >
    <button class="btn btn-link btn-sm" onClick="addNote('${buyerId}')">Add Note</button>
</#macro>

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Charge MilkRun</title>
    <@styleSheets/>
    <style>
        th { text-align: left; }

        td {
            padding: 0;
            margin: 0;
            text-align: left;
            vertical-align: text-top;
        }
        .td-total {
            text-align: right;
        }
        .td-sub-total {
            text-align: right;
            font-weight: bold;
        }
        .td-grand-total {
            text-align: right;
            border-top:1pt solid gray;
            font-weight: bold;
        }
        .btn {
            padding: 0;
            margin: 0;
        }
        .docs {
            color: #88DD88;
                text-align: right;
                font-weight: bold;
        }
    </style>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>

</head>
<body class="">
    <header class="header">
        <@topOfPageHeader/>
    </header>

    <div class="container">
        <div class="row">
            <div class="col-md-3">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="/admin"><strong>Admin Home</strong></a>
                <br>
            </div>
            <div class="col-md-6">
                <#if milkRun?? >
                    <h2>Charge MilkRun</h2>
                    ${milkRun.getName()}  &nbsp;&nbsp;&nbsp;      (${String.format("%8.8s...", milkRun.getId())})
                <#else >
                    <h2>Charge A MilkRun</h2>
                </#if>
            </div>
            <div class="col-md-3">
                <a href="https://github.com/TheBlueFrog/milkrunDocs/blob/master/closing-a-run.md"  target="_blank">
                    <span class="docs pull-right">Charging a MilkRun</span></a>
                <br>
            </div>
        </div>
    </div>
<p>
    <div class="container">
        <div class="row">
            <div class="col-sm-2"></div>
            <div class="col-sm-6">
                <b>At this time no user is automatically charged via Stripe.  This
                will change as we gain experience.</b>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-3"></div>
            <div class="col-sm-6">
                <#if (session.getAttributeS("stripeController-message")?length > 0) >
                    <h2>
                        <span style="background-color: fuchsia"> ${session.getAttributeS("stripeController-message")} </span>
                    </h2>
                    <p></p>
                </#if>
            </div>
            <div class="col-sm-3"></div>
        </div>
        <div class="row">
            <div class="col-sm-4 well">
                MilkRuns
                <select class="mono" id="milkRun" onchange="milkRunSelected(this.value)">
                    <option value="None" selected >None</option>
                    <#list MilkRunDB.findAllOrderByNameDesc() as milkRunSelector >
                        <#if  ! (milkRunSelector.getState().toString() == "Split") >
                            <option value="${milkRunSelector.getId()}"
                                <#if milkRun?? && (milkRun.getId() == milkRunSelector.getId()) >
                                    selected
                                </#if>
                            >
                                <#assign s = String.format("%-12.12s %s %s %s",
                                    milkRunSelector.getName(),
                                    Util.formatTimestamp(milkRunSelector.getTimestamp(), "MMM dd, YYYY"),
                                    milkRunSelector.getState().toString(),
                                    String.format("%8.8s...", milkRunSelector.getId())).replace(" ", "&nbsp;") >
                                ${s}
                            </option>
                        </#if>
                    </#list>
                </select>
            </div>
            <div class="col-sm-1"></div>
            <#--
            <div class="col-sm-4 well">
                <input type="checkbox" onChange="showEmailChanged(this)"
                <#if showEmail >
                       checked
                </#if>
                > Show charge email addresses instead of user details.  Note
                this lists all email addresses for a user.  We need to have
                a pref or something to select which one.  Maybe use the
                Order Summary email pref?
            </div>
            -->
        </div>
    </div>
    <#if milkRun?? >
    <div class="container">
        <div class="row">
            <#assign money = pageState.getMoneySummary() >
            <div class="col-sm-1"> </div>
            <div class="col-sm-4">
                <div class="col-sm-8">
                    Drop Total (uncancelled)<br>
                    Pick Total<br>
                    Cancelled Order Total<br>
                    Discount Total<br>
                    Non-Stripe Total<br>
                </div>
                <div class="col-sm-4 td-total">
                    ${String.format("$ %.2f", money.getDropTotal())}<br>
                    ${String.format("$ %.2f", money.getPickTotal())}<br>
                    ${String.format("$ %.2f", money.getCancelledOrderTotal())}<br>
                    - ${String.format("$ %.2f", money.getDiscountTotal())}<br>
                    - ${String.format("$ %.2f", money.getNonStripeTotal())}<br>
                </div>
            </div>
            <div class="col-sm-1"> </div>
            <div class="col-sm-4">
                <strong>Stripe</strong><br>
                <div class="col-sm-8">
                    Failed Charge Total<br>
                    Yet to be Charged<br>
                    Payments<br>
                    Commission<br>
                    Net Deposit<br>
                </div>
                <div class="col-sm-4 td-total">
                    - ${String.format("$ %.2f", money.getFailedStripeTotal())}<br>
                    ${String.format("$ %.2f", money.getStripeUnpaid())}<br>
                    <span class="td-grand-total">${String.format("$ %.2f", money.getStripePaid())}</span><br>
                    - ${String.format("$ %.2f", money.getStripeCommission())}<br>
                    <span class="td-grand-total">${String.format("$ %.2f", money.getStripeNet())}</span><br>
                </div>
            </div>
        </div>
        <p>&nbsp;</p>
    </div>

        <div class="container">
            <div class="row">
                <div class="col-sm-12">
                    <div class="col-sm-10">
                        <h4>Non-Stripe accounts</b>.
                        </h4>
                        <table style="width:100%">
                            <@headers />
                            <#if (pageState.getUserIdNoStripeNoAuth()?size == 0) >
                                <@noCartsCharge />
                            <#else >
                                <#list pageState.getUserIdNoStripeNoAuth() as buyerId >
                                    <@nonStripeCharge buyerId buyerId?is_even_item nonStripeButtons addNote />
                                </#list>
                            </#if>
                        </table>
                    </div>
                </div>
            </div>
            <p style="border-top:1pt solid gray;"></p>
        </div>
        <div class="container">
            <div class="row">
                <input type="hidden" name="milkRunId" value="${milkRun.getId()}">
                <div class="col-sm-12">
                    <div class="col-sm-10">
                        <h4>
                            <#if ! Website.isProduction() >
                                NON-PRODUCTION &nbsp;
                            </#if>
                            Stripe users without auto-pay who have not checked out.
                        </h4>
                        <table style="width:100%" >
                            <@headers />
                            <#if (pageState.getUserIdWithStripeNoAuth()?size == 0) >
                                <@noCartsCharge />
                            <#else >
                                <#list pageState.getUserIdWithStripeNoAuth() as buyerId >
                                    <@withStripeCharge false buyerId buyerId?is_even_item stripeButtons addNote />
                                </#list>
                            </#if>
                        </table>
                    </div>
                </div>
            </div>
            <p style="border-top:1pt solid gray;"></p>
        </div>
        <div class="container">
            <div class="row">
                <input type="hidden" name="milkRunId" value="${milkRun.getId()}">
                <div class="col-sm-12">
                    <div class="col-sm-10">
                        <h4>
                            <#if ! Website.isProduction() >
                                NON-PRODUCTION &nbsp;
                            </#if>
                            Stripe users with auto-pay enabled or who have checked out.
                        </h4>
                        <table style="width:100%" >
                            <@headersStripe />
                            <#if (pageState.getUserIdWithStripeWithAuth()?size == 0) >
                                <@noCartsCharge />
                            <#else >
                                <#list pageState.getUserIdWithStripeWithAuth() as buyerId >
                                    <@withStripeCharge true buyerId buyerId?is_even_item stripeButtons addNote />
                                </#list>
                            </#if>
                        </table>
                    </div>
                </div>
            </div>
            <p style="border-top:1pt solid gray;"></p>
        </div>
        <div class="container">
            <div class="row">
                <input type="hidden" name="milkRunId" value="${milkRun.getId()}">
                <div class="col-sm-12">
                    <div class="col-sm-10">
                        <h4>
                            <#if ! Website.isProduction() >
                                NON-PRODUCTION &nbsp;
                            </#if>
                             Stripe users where the Stripe account is <b>unchargeable</b>
                        </h4>
                        <table style="width:100%" >
                            <@headersStripe />
                            <#if (pageState.getUserIdWithStripeUnchargeable()?size == 0) >
                                <@noCartsCharge />
                            <#else >
                                <#list pageState.getUserIdWithStripeUnchargeable() as buyerId >
                                    <@withStripeCharge true buyerId buyerId?is_even_item stripeButtons addNote />
                                </#list>
                            </#if>
                        </table>
                    </div>
                </div>
            </div>
            <p style="border-top:1pt solid gray;"></p>
        </div>
    </#if>
<p>
<hr>
    <#if milkRun?? >
        <#if ((milkRun.getState().toString() == "Closing")) && session.user.doesRole("OpenPhaseAdmin") >
            <#if haveInvalidAddress >
            <div class="container">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="col-sm-1"></div>
                        <div class="col-sm-8">
                            <p><b>This run contains invalid addresses.  User's without addresses must be
                                corrected or their cart deleted or moved to the Open run.</b></p>

                            <button onclick="moveBadAddressToOpen()" style="background-color:#BBBBFF">
                                &nbsp;&nbsp;Move all invalid-address carts to the Open MilkRun&nbsp;&nbsp;
                        </div>
                    </div>
                </div>
            </div>
            <#else >
            <div class="container">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="col-sm-1"></div>
                        <div class="col-sm-5">
                            <p>All the users who are checked will be charged.</p>
                            <button onclick="groupChargeMilkRun()" style="background-color:#BBBBFF">
                                &nbsp;&nbsp;Charge the Group&nbsp;&nbsp;
                            </button>
                        </div>
                        <div class="col-sm-1"></div>
                        <div class="col-sm-5">
                            <ul><li>Send out Order summary email to all users in the run.</li>
                                <li>Do the re-ordering for all users.</li>
                            </ul>
                            This can be done manually on the Admin Emailing page.
                            <button onclick="tidyUpClosing()" style="background-color:#BBBBFF">
                                Send Closing Summary and Do Reorders
                            </button>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <p>&nbsp;</p>
                    <p>&nbsp;</p>
                    <div class="col-sm-12">
                        <div class="col-sm-1"></div>
                        <div class="col-sm-5">
                            <p><b>All of the above carts will be included in the MilkRun</b>.  When this
                                is correct mark the MilkRun Closed.</p>
                            <button onclick="closeMilkRun()" style="background-color:#BBBBFF">
                                &nbsp;&nbsp;Mark the MilkRun Closed&nbsp;&nbsp;
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            </#if>
        </#if>
    </#if>
    <p></p>

    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>

    <script>
        <#if milkRun?? >
            function verifyFunction(txt) {
                if (confirm(txt) == true) {
                    return true;
                } else {
                    return false;
                }
            }
            function closeMilkRun() {
                if ( ! ${UserRole.is(session.getUser().getId(), "OpenPhaseAdmin")?c}) {
                    alert("Unauthorized Access, OpenPhaseAdmin privilege required.");
                    return;
                }

                var s = "Are you sure?\nMarking the MilkRun Routed is not undo-able.";
                if (verifyFunction(s)) {
                    location.assign("/milkrun-set-closed?milkRunId=${milkRun.getId()}");
                }
            }

            function addToRun(buyerId) {
                var s = "Confirm leaving this cart in this run?";
                if (verifyFunction(s)){
                    var url="/charge-milkrun/addToRun?buyerId="+buyerId;
                    location.assign(url);
                }
            }
            function moveToOpen(buyerId) {
                if ( ! ${UserRole.is(session.getUser().getId(), "OpenPhaseAdmin")?c}) {
                    alert("Unauthorized Access, OpenPhaseAdmin privilege required.");
                    return;
                }

                var s = "Confirm moving this cart to the Open run?";
                if (verifyFunction(s)){
                    var url="/charge-milkrun/moveToOpen?buyerId="+buyerId;
                    $.get(url, function(data, status){
                        location.reload();
                    });
                }
            }
            function chargeCart(buyerId, amount) {
                if ( ! ${UserRole.is(session.getUser().getId(), "StripeAdmin")?c}) {
                    alert("Unauthorized Access, StripeAdmin privilege required.");
                    return;
                }

                var s = "Confirm charging this cart to the user's credit card?";
                if (verifyFunction(s)){
                    var url="/charge-milkrun/chargeCart?buyerId=" + buyerId;// + "&amount=" + amount;
                    $.get(url, function(data, status){
                        location.reload();
                    });
                }
            }
            function deleteCart(buyerId) {
                if ( ! ${UserRole.is(session.getUser().getId(), "OpenPhaseAdmin")?c}) {
                    alert("Unauthorized Access, OpenPhaseAdmin privilege required.");
                    return;
                }

                var s = "Confirm deleting this cart?";
                if (verifyFunction(s)){
                    var url="/charge-milkrun/deleteCart?buyerId=" + buyerId;
                    $.get(url, function(data, status){
                        location.reload();
                    });
                }
            }
            function createCartDiscount(buyerId) {
                // tell the Discount page to come back here
                var url = "/session-api/set-attribute?name=cartDiscount-returnTo&type=string&value=/charge-milkrun?milkRunId=${milkRun.getId()}";
                $.get(url, function(data, status){});

                url="/discount/cart/create?cartDiscountMilkRunId=${milkRun.getId()}&cartDiscountUserId=" + buyerId;
                location.assign(url);
            }
            function editCartDiscount(buyerId, discountId) {
                // tell the Discount page to come back here
                var url = "/session-api/set-attribute?name=cartDiscount-returnTo&type=string&value=/charge-milkrun?milkRunId=${milkRun.getId()}";
                $.get(url, function(data, status){});

                url = "/discount/cart/edit?discountTime=" + discountId;
                location.assign(url);
            }
            function addNote(buyerId) {
                // tell the Note page to come back here
                var url = "/session-api/set-attribute?name=returnTo&type=string&value=/charge-milkrun?milkRunId=${milkRun.getId()}";
                $.get(url, function(data, status){});

                url = "/note/create?milkRunSeriesName=${milkRun.getSeriesName()}&userId=" + buyerId + "&color=Charge&status=Open&body=Added in Charge";
                location.assign(url);
            }
            function editNote(noteId) {
                // tell the Note page to come back here
                var url = "/session-api/set-attribute?name=returnTo&type=string&value=/charge-milkrun?milkRunId=${milkRun.getId()}";
                $.get(url, function(data, status){});

                url = "/note/edit?id=" + noteId;
                location.assign(url);
            }
            function moveBadAddressToOpen(noteId) {
                var url="/milkrun-api2/move-bad-addresses-to-open?milkRunId=${milkRun.getId()}";
                $.get(url, function(data, status) {
                    location.reload();
                });
            }
        </#if>

        function milkRunSelected(id) {
            var url="/charge-milkrun?milkRunId=" + id;
            location.assign(url);
        }
        function showEmailChanged(check) {
            var url="/session-api/set-attribute?name=milkrun-open-charge-show-email&type=boolean&value=" + check.checked;
            location.assign(url);
        }

        var groupCharge = [];

        function countChecks() {
            var i = 0;
            Object.keys(groupCharge).forEach(function (key, index) {
                if (groupCharge[key]) {
                    i = i + 1;
                }
            });
            return i;
        }
        function groupChargeChanged(check, userId) {
            groupCharge[userId] = check.checked;
        }
        function groupChargeMilkRun() {
            var s = "Charge " + countChecks() + " users?";
            if (verifyFunction(s)) {
                Object.keys(groupCharge).forEach(function (key, index) {
                    if (groupCharge[key]) {
                        var url = "/charge-milkrun/chargeCart?buyerId=" + key;
                        $.get(url, function (data, status) {
//                        location.reload();
                        });
                    }
                    else {
                        var k = 0;
                    }
                });

                location.reload();
            }
        }

        function tidyUpClosing() {
            if (verifyFunction('Are you sure?  Doing this more than once is a mess.')) {
                var url = '/milkrun-api2/render-ftl-send-email?milkRunId=${milkRun.getId()}&template=order-summary.ftl';
                $.get(url, function (data, status) {
                    url = '/admin-api/do-reordering';
                    $.get(url, function (data, status) {
                        location.reload();
                    });
                });
            }
        }
    </script>

</body>
</html>