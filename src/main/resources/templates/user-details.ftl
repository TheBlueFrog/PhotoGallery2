<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">

<#macro userAttributes user targetUser >
<div class="col-md-1">
    <input type="checkbox" name="Eater" onChange="this.form.submit()"
        ${UserRole.is(targetUser.getId(), "Eater")?then(' checked ', '')}
    >Eater
    <br>
    <input type="checkbox" name="Seeder" onChange="this.form.submit()"
        ${UserRole.is(targetUser.getId(), "Seeder")?then(' checked ', '')}
    >Seeder
    <br>
    <input type="checkbox" name="Feeder" onChange="this.form.submit()"
        ${UserRole.is(targetUser.getId(), "Feeder")?then(' checked ', '')}
    >Feeder
</div>
<div class="col-md-1">
    <input type="checkbox" name="Farmer" onChange="this.form.submit()"
        ${UserRole.is(targetUser.getId(), "Farmer")?then(' checked ', '')}
    >Farmer
    <br>
    <input type="checkbox" name="Butcher" onChange="this.form.submit()"
        ${UserRole.is(targetUser.getId(), "Butcher")?then(' checked ', '')}
    >Butcher
    <br>
    <input type="checkbox" name="Baker" onChange="this.form.submit()"
        ${UserRole.is(targetUser.getId(), "Baker")?then(' checked ', '')}
    >Baker
    <br>
    <input type="checkbox" name="Maker" onChange="this.form.submit()"
        ${UserRole.is(targetUser.getId(), "Maker")?then(' checked ', '')}
    >Maker
    <br>
    <input type="checkbox" name="Chef" onChange="this.form.submit()"
        ${UserRole.is(targetUser.getId(), "Chef")?then(' checked ', '')}
    >Chef
</div>
</#macro>

<!-- gets complicated because of hierarchical authority -->
<#macro adminRoles user targetUser >
    <div class="col-md-4">
        <!-- only SupremeLeader can make somebody an Admin -->
        <#if user.doesRole("SupremeLeader") >
            <input type="checkbox" name="Admin" onChange="this.form.submit()"
                ${UserRole.is(targetUser.getId(), "Admin")?then(' checked ', '')}
            >Admin
            <br>
        </#if>

        <!-- only a general Admin can make somebody an specific Admin -->
        <#if user.doesRole("Admin") >
            <input type="checkbox" name="StripeAdmin" onChange="this.form.submit()"
                ${UserRole.is(targetUser.getId(), "StripeAdmin")?then(' checked ', '')}
            >StripeAdmin
            <#if (UserRole.findByRole("StripeAdmin")?size > 0) >
                (Currently ${User.findByUserId(UserRole.findByRole("StripeAdmin")?first.getUserId()).getName()})
            </#if>
            <br>

            <input type="checkbox" name="OpenPhaseAdmin" onChange="this.form.submit()"
                ${UserRole.is(targetUser.getId(), "OpenPhaseAdmin")?then(' checked ', '')}
            >OpenPhaseAdmin
            <#if (UserRole.findByRole("OpenPhaseAdmin")?size > 0) >
                (Currently ${User.findByUserId(UserRole.findByRole("OpenPhaseAdmin")?first.getUserId()).getName()})
            </#if>

            <br>
            <input type="checkbox" name="RoutingAdmin" onChange="this.form.submit()"
                ${UserRole.is(targetUser.getId(), "RoutingAdmin")?then(' checked ', '')}
            >RoutingAdmin
            <#if (UserRole.findByRole("RoutingAdmin")?size > 0) >
               (Currently ${User.findByUserId(UserRole.findByRole("RoutingAdmin")?first.getUserId()).getName()})
            </#if>
            <br>
            <input type="checkbox" name="ClosedPhaseAdmin" onChange="this.form.submit()"
                ${UserRole.is(targetUser.getId(), "ClosedPhaseAdmin")?then(' checked ', '')}
            >ClosedPhaseAdmin
            <#if (UserRole.findByRole("ClosedPhaseAdmin")?size > 0) >
               (Currently ${User.findByUserId(UserRole.findByRole("ClosedPhaseAdmin")?first.getUserId()).getName()})
            </#if>

            <br>
            <input type="checkbox" name="ProductAdmin" onChange="this.form.submit()"
                ${UserRole.is(targetUser.getId(), "ProductAdmin")?then(' checked ', '')}
            >Product Admin
            <br>
            <input type="checkbox" name="UserAdmin" onChange="this.form.submit()"
                ${UserRole.is(targetUser.getId(), "UserAdmin")?then(' checked ', '')}
            >User Admin
            <br>
            <input type="checkbox" name="BrowsingAdmin" onChange="this.form.submit()"
                ${UserRole.is(targetUser.getId(), "BrowsingAdmin")?then(' checked ', '')}
            >Browsing Admin
        </#if>
    </div>
</#macro>


<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title> ${User.findById(session.getAttribute("targetUserId")).getName()}</title>
    <@styleSheets/>
    <style>
        th { text-align: left; }
        td {
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
    </style>

</head>
    <body class="">
    <header class="header">
        <@topOfPageHeader/>
    </header>

    <#assign targetUser = User.findById(session.getAttribute("targetUserId")) >
    <#assign user = session.getUser() >

    <div class="container">
        <p></p>
        <div class="row" >
            <div class="col-md-3">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="/admin"><strong>Back to Admin Home</strong></a>
                <br>
                <a href="/users2"><strong>Back to Users</strong></a>
                <br>
                <#if ( ! session.getPushedUser()??) && ( ! UserRole.isAnAdmin(targetUser.getId())) >
                    <!-- Switch to is not allowed if we have already switched-to since we don't have a stack
                        and we don't support switching to another Admin
                    -->
                    <a href="/switch-user?userId=${targetUser.getId()}"><strong>Switch to ${targetUser.getName()}</strong></a>
                    <br>
                </#if>
            </div>
            <div class="col-md-5">
                <h4>Manage Account of ${targetUser.name}</h4>
                <strong>UUID:</strong> ${targetUser.username}
                <#if ! targetUser.getEnabled() >
                    <br><span style="background-color: #ffaaaa">Account is DISABLED</span>
                </#if>
            </div>
        </div>
    </div>
    <p></p>
    <div class="container">
        <div class="row" >
            <ul class="nav nav-tabs">
                <li class="active"><a data-toggle="tab" href="#roles">Roles</a></li>
                <li><a data-toggle="tab" href="#ordering">Ordering</a></li>
                <li><a data-toggle="tab" href="#addresses">Addresses</a></li>
                <li><a data-toggle="tab" href="#email">Email</a></li>
                <li><a data-toggle="tab" href="#login">Login Names</a></li>
                <li><a data-toggle="tab" href="#stripe">Stripe</a></li>
                <li><a data-toggle="tab" href="#notes">Notes</a></li>
                <li><a data-toggle="tab" href="#uploads">Uploads</a></li>
                <li><a data-toggle="tab" href="#security">Security Events</a></li>
            </ul>
            <div class="tab-content">
                <div id="roles" class="tab-pane fade in active">
                    <br>
                    <form class="form-horizontal" method="post">
                        <input type="hidden" name="operation" value="update" />
                        <div class="col-md-12">
                            <div class="col-md-2">
                                <input type="checkbox" name="Enabled" onChange="this.form.submit()"
                                ${targetUser.getEnabled()?then(' checked ', '')}
                                >Enabled
                                <br>
                                <input type="checkbox" name="AccountPending" onChange="this.form.submit()"
                                ${UserRole.is(targetUser.getId(), "AccountPending")?then(' checked ', '')}
                                >AccountPending
                            </div>
                            <@userAttributes user targetUser />
                            <div class="col-md-2">
                                <input type="checkbox" name="Driver" onChange="this.form.submit()"
                                ${UserRole.is(targetUser.getId(), "Driver")?then(' checked ', '')}
                                >Driver
                                <br>
                                <br>
                                <input type="checkbox" name="InDevelopment" onChange="this.form.submit()"
                                ${UserRole.is(targetUser.getId(), "InDevelopment")?then(' checked ', '')}
                                >InDevelopment
                                <br>
                                <br>
                                <input type="checkbox" name="Depot" onChange="this.form.submit()"
                                ${UserRole.is(targetUser.getId(), "Depot")?then(' checked ', '')}
                                >Depot
                            </div>
                            <@adminRoles user targetUser />
                        </div>
                    </form>
                </div>
                <div id="ordering" class="tab-pane fade">
                    <br>
                    <div class="col-md-4">
                        <a href="/user-charts/${targetUser.getId()}" ><strong>Ordering Chart</strong></a>
                        <p></p>
                        Joined ${Util.formatTimestamp(targetUser.getJoinTimestamp(), "MMM dd, YYYY")}
                        <br>
                        Referred by
                        <#if Referrers.findByUserId(targetUser.getId())?? >
                            <#assign referrerId = Referrers.findByUserId(targetUser.getId()).getReferredByUserId() >
                            <a href="/user-details/${referrerId}" >
                                <strong>${User.findById(referrerId).getName()}</strong>
                            </a>
                        <#else >
                            n/a
                        </#if>
                        <br>

                        <#assign activity = targetUser.getActivity() >
                            Percent of possible MilkRuns ordered:
                        <#if activity.hasValidMetric() >
                            ${String.format("%.0f%%", (activity.getMetric() * 100.0))}
                        <#else >
                            0
                        </#if>
                        <br>
                        Ordered in MilkRuns: ${activity.getNumMilkRuns()}
                        <br>
                        Total Spend:
                        <#if activity.hasValidMetric() >
                            ${String.format("$ %.2f", activity.getTotalSpend())}
                        <#else >
                            0
                        </#if>
                        <br>
                        Average Spend:
                        <#if activity.hasValidMetric() >
                            ${String.format("$ %.2f", activity.getAverageSpend())}
                        <#else >
                            0
                        </#if>
                    </div>
                    <div class="col-md-8">
                        <div class="row">
                            <strong>Past Orders</strong>
                            <br>
                        </div>
                        <#list Participation.findByUserIdOrderByMilkRunSeriesName(targetUser.getId()) as participation >
                            <div class="row">
                                <#assign seriesName = participation.getMilkRunSeriesName() >
                                <div class="col-sm-3" > </div>
                                <div class="col-sm-3" >
                                    ${seriesName}
                                </div>
                                <div class="col-sm-3" style="text-align: right" >
                                    ${String.format("$ %.2f", participation.getSellPrice())}
                                </div>
                                <div class="col-sm-3" ></div>
                            </div>
                        </#list>
                    </div>
                </div>
                <div id="addresses" class="tab-pane fade">
                    <br>
                    <a href="/user-map?userId=${targetUser.getId()}"><strong>Map with all addresses</strong></a>
                    <br>
                    <div class="col-md-10 well">
                    <#list targetUser.getAddresses() as address >
                        <div class="row ">
                            <div class="col-md-1">
                            ${address.getUsageAsString()}
                            </div>
                            <div class="col-md-1">
                                <a href="/user-map?userId=${targetUser.getId()}&addressId=${address.getId()}"><strong>Map</strong></a>
                            </div>
                            <div class="col-md-8">
                            ${address.getMailingAddress()}
                            </div>
                            <div class="col-md-1">
                                <button onclick="deleteAddress('${address.getId()}')" >Delete</button>
                            </div>
                        </div>
                    </#list>
                    </div>
                </div>
                <div id="email" class="tab-pane fade">
                    <div class="col-md-3 well">
                        <strong>Email Addresses</strong>
                        <br>
                        <#list targetUser.getEmailAddresses() as emails >
                        ${emails.getEmail()}
                            <br>
                        </#list>
                        <p></p>
                        <form class="form-horizontal" method="post">
                            <div class="form-group">
                                <input type="hidden" name="operation" value="CreateEmail" />
                                <input class="col-sm-3 btn" type="submit" value="Create">
                                <div class="col-sm-3">
                                    <input type="text" id="newEmailAddress" name="newEmailAddress" placeholder="New email address" value=""/>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="col-md-1"></div>
                    <div class="col-md-4 well">
                        <strong>Preferences</strong>
                        <br>
                        MilkRun Opening: send email here when a MilkRun is Opened
                        <form method="post">
                            <input type="hidden" name="operation" value="setSendOnOpenEmailAddressId" />
                            <select name="emailAddressId" onChange="this.form.submit()" >
                                <option value="None"
                                <#if targetUser.getPrefs().getSendOnOpenEmailAddressId() == "" >
                                        selected
                                </#if>
                                >None</option>
                            <#list targetUser.getEmailAddresses() as email>
                                <option value="${email.getId()}"
                                    <#if email.getId() == targetUser.getPrefs().getSendOnOpenEmailAddressId() >
                                        selected
                                    </#if>
                                >${email.getEmail()}</option>
                            </#list>
                            </select>
                        </form>
                        <br>
                        MilkRun Closing: send email here when a MilkRun is Closed
                        <form method="post">
                            <input type="hidden" name="operation" value="setSendOnCloseEmailAddressId" />
                            <select name="emailAddressId" onChange="this.form.submit()" >
                                <option value="None"
                                <#if targetUser.getPrefs().getSendOnCloseEmailAddressId() == "" >
                                        selected
                                </#if>
                                >None</option>
                            <#list targetUser.getEmailAddresses() as email>
                                <option value="${email.getId()}"
                                    <#if email.getId() == targetUser.getPrefs().getSendOnCloseEmailAddressId() >
                                        selected
                                    </#if>
                                >${email.getEmail()}</option>
                            </#list>
                            </select>
                        </form>
                        <br>
                        Supplier Order: send MilkRun supplier order email here
                        <form method="post">
                            <input type="hidden" name="operation" value="setSendSupplieOrderEmailAddressId" />
                            <select name="emailAddressId" onChange="this.form.submit()" >
                                <option value="None"
                                <#if targetUser.getPrefs().getSendSupplierOrderEmailId() == "" >
                                        selected
                                </#if>
                                >None</option>
                            <#list targetUser.getEmailAddresses() as email>
                                <option value="${email.getId()}"
                                    <#if email.getId() == targetUser.getPrefs().getSendSupplierOrderEmailId() >
                                        selected
                                    </#if>
                                >${email.getEmail()}</option>
                            </#list>
                            </select>
                        </form>
                        <br>

                        Login Name Reset: send email here when a login name is reset
                        <form method="post">
                            <input type="hidden" name="operation" value="setSendOnLoginResetEmailAddressId" />
                            <select name="emailAddressId" onChange="this.form.submit()" >
                                <option value="None"
                                <#if targetUser.getPrefs().getSendEmailOnLoginResetAddressId() == "" >
                                        selected
                                </#if>
                                >None</option>
                            <#list targetUser.getEmailAddresses() as email>
                                <option value="${email.getId()}"
                                    <#if email.getId() == targetUser.getPrefs().getSendEmailOnLoginResetAddressId() >
                                        selected
                                    </#if>
                                >${email.getEmail()}</option>
                            </#list>
                            </select>
                        </form>
                    <#if targetUser.doesRole("UserAdmin") >
                        <br>
                        Pending Account Notification: send email here when a pending account occurs
                        <form method="post">
                            <input type="hidden" name="operation" value="setSendOnPendingEmailAddressId" />
                            <select name="emailAddressId" onChange="this.form.submit()" >
                                <option value="None"
                                    <#if ! targetUser.getPrefs().hasSendOnPendingAccountEmailAddress() >
                                        selected
                                    </#if>
                                >None</option>
                                <#list targetUser.getEmailAddresses() as email>
                                    <option value="${email.getId()}"
                                        <#if email.getId() == targetUser.getPrefs().getSendOnPendingAccountEmailAddressId() >
                                            selected
                                        </#if>
                                    >${email.getEmail()}</option>
                                </#list>
                            </select>
                        </form>
                    </#if>
                        <br>
                    </div>
                </div>
                <div id="login" class="tab-pane fade">
                    <div class="col-md-12 well">
                        <div class="col-md-5">
                            <p></p><strong>Login Names of the account</strong>
                            <p>
                                If the login has not been
                                reset, and is being used normally it may be reset by clicking
                                the Reset button.  If a login name has been reset the
                                URL can be used to create a new password.
                            </p>
                            <p>
                                Email containing the reset URL will be sent to the email address
                                in the User Preferences selected for login reset.
                            </p>
                        </div>
                        <div class="col-md-6">
                            <br>
                            <form class="form-horizontal" method="post">
                                <div class="form-group">
                                    <input type="hidden" name="operation" value="CreateLogin" />
                                    <input class="col-sm-3" type="submit" value="Create">

                                    <div class="col-sm-1"></div>
                                    <div class="col-sm-2">
                                        <input type="text" id="NewLoginName" name="NewLoginName" placeholder="New login name" value=""/>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                    <div class="col-md-12">
                        <table width="100%">
                            <thead>
                            <th width="20%">Login Name</th>
                            <th width="5%"></th>
                            <th width="40%">Reset Code</th>
                            <th width="35%">Accounts</th>
                            </thead>
                        <#if LoginName.hasDuplicate(targetUser.getId()) >
                            <tr>
                                <td><span style="background-color: hotpink">Has Duplicates</span></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                        </#if>
                        <#list loginNamesOfAccount as login>
                            <#assign loginName = login.getLoginName() >
                            <tr>
                                <td width="20%">
                                ${login.getLoginNameRaw()}
                                </td>
                                <td width="10%">
                                    <#if login.hasPasswordBeenReset() >
                                    <#else>
                                        <button onclick="resetLogin('${loginName}')">Reset</button>
                                    </#if>
                                </td>
                                <td width="40%">
                                    <#if login.hasPasswordBeenReset() >
                                        https://${StringData.findByUserIdAndKey("", "DNSName").getValue()}/reset-password?resetLogin=${loginName}&resetCode=${login.pwHash}
                                    </#if>
                                </td>
                                <td width="25%">
                                    <#if EmailAddress.findByEmail(loginName)?? >
                                        <#list EmailAddress.findByEmail(loginName) as otherEmails >
                                        ${otherEmails.getUserId()}<br>
                                        </#list>
                                    </#if>
                                </td>
                            </tr>
                        </#list>
                        </table>
                    </div>
                </div>
                <div id="stripe" class="tab-pane fade">
                    <div class="col-md-12 well">
                        <br>
                    <#if StripeCustomer.findByUserId(targetUser.getId())?? >
                        <#assign customer = StripeCustomer.findByUserId(targetUser.getId()) >
                        <div class="col-sm-4">
                            <#if customer.getCards()?? >
                            ${customer.getCards()?size} cards
                                <br>
                                <strong>Active card</strong> ${customer.getActiveCardId()}
                                <br>
                                <strong>Customer ID</strong> ${customer.getStripeCustomerId()}
                                <br>
                                <strong>Since</strong> ${Util.formatTimestamp(customer.getTimestamp(), "MMM dd, YYYY")}
                            <#else >
                                No cards found
                            </#if>
                        </div>
                        <div class="col-sm-8">
                            <strong>Charges</strong>
                            <br>
                            <@pastStripeCharges targetUser />
                        </div>
                    </#if>
                    </div>
                </div>
                <div id="uploads" class="tab-pane fade">
                    <br>
                    <form class="form-horizontal" method="POST" enctype="multipart/form-data" action="/upload-item-image">
                        <div class="col-sm-1">
                            <input type="submit" value="Upload" />
                        </div>
                        <div class="col-sm-3">
                            <input type="file" name="files" multiple/> &nbsp;
                        </div>
                    </form>
                    <div class="col-sm-4">
                        Uploaded files
                        <br>
                        <textarea rows="8" cols="50"  spellcheck="false">
                            <#list targetUser.getStoredImages() as filename >
                                ${filename}
                            </#list>
                        </textarea>
                    </div>
                </div>
                <div id="notes" class="tab-pane fade">
                        <br>
                        <a href="/notes/filters?userIdSelector=${targetUser.getId()}"><strong>Notes of this user</strong></a>
                        <br>
                        <a href="/note/create?userIdSelector=${targetUser.username}"><strong>Create Note</strong></a>
                </div>
                <div id="security" class="tab-pane fade">
                    <div class="col-md-12">
                        <br>Security Events in the last 60 days for this account
                        <br>
                        <#list SystemEvent.findLoginEvents(targetUser.getUsername()) as event >
                            <div class="col-sm-3">
                            ${Util.formatTimestamp(event.getTimestamp(), "MMM dd HH:MM")}
                            </div>
                            <div class="col-sm-9">
                            ${event.getEvent()}
                            </div>
                            <br>
                        </#list>
                    </div>
                </div>
            </div>
        </div>

    </div>
    <p>&nbsp;</p>
    <p>&nbsp;</p>
    <p>&nbsp;</p>
    <p>&nbsp;</p>
    <p>&nbsp;</p>

    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>

    <script>
        function verifyFunction(txt) {
            if (confirm(txt) == true) {
                return true;
            } else {
                return false;
            }
        }

        function resetLogin(loginName) {
            if ( ! ${UserRole.does(user.getId(), "UserAdmin")?c}) {
                alert("Unauthorized Access, UserAdmin privilege required.");
                return;
            }

            var url = "/admin-api/reset-login?loginName=" + loginName;
            $.get(url, function(data, status) {
                if (data === 'OK') {
                    location.assign("/user-details/${targetUser.getUsername()}")
                }
                else {
                    alert(data);
                }
            });
        }

        function deleteAddress(addressId) {
            if ( ! ${UserRole.is(user.getId(), "UserAdmin")?c}) {
                alert("Unauthorized Access, UserAdmin privilege required.");
                return;
            }

            if (verifyFunction("Really delete an address?")) {
                var url = "/admin-api/delete/address?addressId=" + addressId;
                $.get(url, function (data, status) {
                    if (data === 'OK') {
                        location.assign("/user-details/${targetUser.getUsername()}");
                    }
                    else {
                        alert(data);
                    }
                });
            }
        }
    </script>

    </body>

</html>