<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Emailing Manager</title>
    <@styleSheets/>
    
    <style>

        .mono {
            font-family: "monospace";
        }
        hr {
            display: block;
            margin-top: 0.5em;
            margin-bottom: 0.5em;
            margin-left: auto;
            margin-right: auto;
            border-style: inset;
            border-width: 1px;
        }

        #params-0, #params-1, #params-2, #params-3, #params-4 {
            display: none;
        }

    </style>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>

</head>
<body class="">
    <@pageHeader3 />

    <p></p>
    <div class="container">
        <div class="row">
            <div class="col-md-2">
                <a href="/"><h4>Home</h4></a>
                <a href="admin"><h4>Admin Home</h4></a>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6 well">
                <ul class="nav nav-pills nav-stacked">
                    <li><a href="/system-string-editor"><strong>System String Editor</strong></a></li>
                    <li><button class="btn btn-link btn-sm" onClick="doReordering()">Do User Reordering</button></li>
                </ul>
            </div>
        </div>
        <div class="row">
            <div class="col-md-4">
                Email templates are kept in GitHub <a href="https://github.com/TheBlueFrog/milkrunFiles/tree/master/email-templates"> here </a>.
                The particular server is set to track a particular branch of the repo.  In the Admin page
                at the bottom is a button to fetch the latest from the repo.
            </div>
        </div>
        <div class="row">
            <div class="col-md-4 well">
                Email Template
                <select id="template" name="template"  onchange="templateChanged(this.value)">
                    <option value="0" selected>None</option>
                    <option value="1" >
                        MilkRun Opening
                    </option>
                    <option value="2" >
                        MilkRun Closing Customer Order Summary
                    </option>
                    <option value="6" >
                        MilkRun Closed Supplier Order Summary
                    </option>
                    <option value="3" >
                        User Login Reset
                    </option>
                    <option value="4" >
                        New User Email
                    </option>
                    <option value="5" >
                        Bounced Cart Email
                    </option>
                </select>

                <p></p>
                <button onclick="emailTest()">Test</button>

                <p>&nbsp;</p>
                <button style="background-color: #ff7777" id="sendEmailButton" onclick="sendEmail()"
                    <#if ! Website.getEmailEnabled() >
                        hidden="hidden"
                    </#if>
                    >Send</button>
                <#if ! Website.getProduction() >
                    &nbsp;  &nbsp; &nbsp; &nbsp;
                    &nbsp;
                    <input type="checkbox" id="sendEmail" onchange="sendEmailChanged(this)"
                           <#if Website.getEmailEnabled() > checked </#if>
                    >
                        Actually send email from here
                    </input>
                </#if>

            <#--
                            <p>&nbsp;</p>
                                <a href="/admin/email-order-summary?template=order-summary.ftl"><strong>Link to rendering of email Order Summary (hardcoded MilkRun & User)</strong></a>
            -->
                <p>&nbsp;</p>
            </div>
            <div class="col-md-4 well params" id="params-0">
                <small>Parameters</small>
                <br>
                None
            </div>
            <div class="col-md-4 well params" id="params-1">
                <small>Parameters</small>
                <!-- opening -->
                <br>
                deliveryDate
                <input type="text" id="deliveryDate-1" value="${Util.formatTimestamp(MilkRunDB.findOpen().getDeliveryDate(), "MMM dd, YYYY")}">
                <br>
                MilkRun <span id="milkRun-1" value="${MilkRunDB.findOpen().getId()}">${MilkRunDB.findOpen().getId()}</span>
            </div>
            <div class="col-md-4 well params" id="params-2">
                <small>Parameters</small>
                <!-- consumer order summary -->
                <br>
                deliveryDate
                <input type="text" id="deliveryDate-2" value="${Util.formatTimestamp(MilkRunDB.findOpen().getDeliveryDate(), "MMM dd, YYYY")}">
                <br>
                MilkRun
                <select class="mono" id="milkRun-2" >
                    <#list MilkRunDB.findByStatusOrderByTimestampDesc("Unrouted") as closed >
                        <option value="${closed.getId()}" >
                            ${closed.getState().toString()}
                            &nbsp;
                            ${Util.formatTimestamp(closed.getTimestamp(), "MMM d, YY")}
                                &nbsp;
                            ${closed.getName()}
                                &nbsp;
                            ${String.format("%8.8s...", closed.getId())}
                        </option>
                    </#list>
                    <#list MilkRunDB.findByStatusOrderByTimestampDesc("Routed") as closed >
                        <option value="${closed.getId()}" >
                            ${closed.getState().toString()}
                            &nbsp;
                            ${Util.formatTimestamp(closed.getTimestamp(), "MMM d, YY")}
                            &nbsp;
                            ${closed.getName()}
                            &nbsp;
                            ${String.format("%8.8s...", closed.getId())}
                        </option>
                    </#list>
                </select>
            </div>
            <div class="col-md-4 well params" id="params-6">
                <small>Parameters</small>
                <!-- supplier order -->
                <br>
                deliveryDate
                <input type="text" id="deliveryDate-6" value="${Util.formatTimestamp(MilkRunDB.findOpen().getDeliveryDate(), "MMM dd, YYYY")}">
                <br>
                MilkRun
                <select class="mono" id="milkRun-6" >
                    <#list MilkRunDB.findByStatusOrderByTimestampDesc("Unrouted") as closed >
                        <option value="${closed.getId()}" >
                            ${closed.getState().toString()}
                            &nbsp;
                            ${Util.formatTimestamp(closed.getTimestamp(), "MMM d, YY")}
                            &nbsp;
                            ${closed.getName()}
                            &nbsp;
                            ${String.format("%8.8s...", closed.getId())}
                        </option>
                    </#list>
                    <#list MilkRunDB.findByStatusOrderByTimestampDesc("Routed") as closed >
                        <option value="${closed.getId()}" >
                            ${closed.getState().toString()}
                            &nbsp;
                            ${Util.formatTimestamp(closed.getTimestamp(), "MMM d, YY")}
                            &nbsp;
                            ${closed.getName()}
                            &nbsp;
                            ${String.format("%8.8s...", closed.getId())}
                        </option>
                    </#list>
                </select>
            </div>
            <div class="col-md-4 well params" id="params-3">
                <small>Parameters</small>
                <br>
                Select the reset login name to send email to
                <select class="mono" id="loginName" >
                    <#list LoginName.findReset() as loginName >
                        <option value="${loginName.getLoginName()}" >
                            ${String.format("%-8.8s", loginName.getUserId())} &nbsp; ${loginName.getLoginName()}
                        </option>
                    </#list>
                </select>
                <br>
            </div>
            <div class="col-md-4 well params" id="params-4">
                <small>Parameters</small>
                <br>
                Select the account to send welcome email to
                <br>
                <select class="mono" id="userId" >
                    <#if Website.getProduction() >
                        <#list Util.sortByUserName(User.findNeverOrdered()) as user >
                            <option value="${user.getId()}" >
                            ${user.getIdShort()} &nbsp; ${String.format("%-40s", user.getName())}
                            </option>
                        </#list>
                    <#else >
                        <#list Util.sortByUserName(User.findByEnabled(true)) as user >
                            <option value="${user.getId()}" >
                            ${user.getIdShort()} &nbsp; ${String.format("%-40s", user.getName())}
                            </option>
                        </#list>
                    </#if>
                </select>
                <br>
            </div>
            <div class="col-md-4 well params" id="params-5">
                <small>Parameters</small>
                <!-- bounced cart -->
                <br>
                MilkRun
                <select class="mono" id="milkRun-5" >
                    <#list MilkRunDB.findByStatusOrderByTimestampDesc("Open") as closed >
                        <option value="${closed.getId()}" >
                        ${closed.getState().toString()}
                            &nbsp;
                        ${closed.getName()}
                            &nbsp;
                        ${String.format("%8.8s...", closed.getId())}
                        </option>
                    </#list>
                </select>
                <br>
                Select the account to send bounced cart email to
                <br>
                <select class="mono" id="userId-5" >
                    <#list Util.sortByUserName(User.findByEnabled(true)) as user >
                        <option value="${user.getId()}" >
                        ${user.getIdShort()} &nbsp; ${String.format("%-40s", user.getName())}
                        </option>
                    </#list>
                </select>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6 well" id="testResults">
            </div>
        </div>
        <p></p>
    </div>

    <script>

    function sendEmailChanged(check) {
        var url = '/admin-api/enable?emailOnStage=' ;
        if (check.checked) {
            url += "true";
            $('#sendEmailButton').show();
        }
        else {
            url += "false";
            $('#sendEmailButton').hide();
        }

        $.get(url, function(data, status){
        });
    }

    var templates = [
        '',                         // 0
        'milkrun-opening.ftl',      // 1
        'order-summary.ftl',        // 2
        'user-login-reset.ftl',     // 3
        'new-user-welcome.ftl',     // 4
        'bounced-cart-email.ftl',   // 5
        'supplier-order.ftl'        // 6
    ];

    function templateChanged(s) {

        $(".params").hide();
        $('#params-' + s).show();
    }

    function sendEmail() {
        var s = "Are you sure?\nA LOT of email could be sent.";
        if (verifyFunction(s)) {
            doIt(false);
        }
    }
    function emailTest() {
        doIt(true);
    }
    function verifyFunction(txt) {
        if (confirm(txt) == true) {
            return true;
        } else {
            return false;
        }
    }

    function doReordering () {
        if (confirm('Put all re-orders in users carts?')) {
            var url = '/admin-api/do-reordering';
            $.get(url, function(data, status){
                location.reload();
            });
        }
    }


    function doIt(isTest) {
        if ( ! ${UserRole.is(session.getUser().getId(), "Admin")?c}) {
            alert("Unauthorized Access, Admin privilege required.");
            return;
        }

        var templateIndex = document.getElementById('template').value;
        var url = "/milkrun-api2/render-ftl-send-email"
                + "?template=" + templates[templateIndex];

        if (templateIndex == 1) {
            var deliveryDate = $('#deliveryDate-' + templateIndex);
            var milkRunId = document.getElementById('milkRun-' + templateIndex).innerText;
            url += '&milkRunId=' + milkRunId
                 + '&deliveryDate=' + deliveryDate[0].value;
        }
        if (templateIndex == 2) {
            var deliveryDate = $('#deliveryDate-' + templateIndex);
            var milkRunId = document.getElementById('milkRun-' + templateIndex).value;
            url += '&milkRunId=' + milkRunId
                    + '&deliveryDate=' + deliveryDate[0].value;
        }
        if(templateIndex == 3) {
            url += '&loginName=' + document.getElementById('loginName').value;
        }
        if(templateIndex == 4) {
            url += '&userId=' + document.getElementById('userId').value;
        }
        if(templateIndex == 5) {
            url += '&userId=' + document.getElementById('userId-5').value +
                   '&milkRunId=' + document.getElementById('milkRun-5').value;
        }
        if (templateIndex == 6) {
            var deliveryDate = $('#deliveryDate-' + templateIndex);
            var milkRunId = document.getElementById('milkRun-' + templateIndex).value;
            url += '&milkRunId=' + milkRunId
                    + '&deliveryDate=' + deliveryDate[0].value;
        }

        if (isTest) {
            url += '&isTest=' + true;
        } else {
            url += '&isTest=' + false;
        }

        $.get(url, function(data, status){
            document.getElementById('testResults').innerHTML = data;
        });
    }

    </script>
</body>
</html>


