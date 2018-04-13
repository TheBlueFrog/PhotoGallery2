<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Pending User Accounts</title>
    <@styleSheets/>
    <style>
        th { text-align: left; }
        td {
            text-align: left;
            vertical-align: text-top;
        }
        .usernote {
            color: #000000;
            background-color: #ffcccc
        }
    </style>

</head>
    <body class="">
    <header class="header">
        <@pageHeader3/>
    </header>

    <div class="container-fluid">
        <div class="row col-md-12">
            <div class="col-md-1"></div>
            <div class="col-md-3">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="/admin"><strong>Back to Admin</strong></a>
            </div>
            <div class="col-md-8">
                <h2>Pending User Accounts</h2>
                <p></p>
            </div>
        </div>

        <div class="row col-md-12">
            <div class="col-md-1"></div>
            <div class="col-md-4">
                <form method="post">
                    <input type="hidden" name="operation" value="showDisabledUsers" />
                    <input type="checkbox" name="showDisabledUsers" onChange="this.form.submit()"
                    <#if session.getAttributeB("showDisabledUsers") >
                           checked
                    </#if>
                    /> Show enabled and disabled accounts
                </form>
            </div>
            <div class="col-md-5">
                If you are not sure a pending account should be un-pended don't do it, just leave it
                Pending.  Check the Map for where the given address has geo-coded, this will be
                the default address used for delivery unless an additional address is provided
                later.
                <p></p>
            </div>
            <div class="col-md-2"></div>
        </div>
        <#if User.findPending(session.getAttributeB("showDisabledUsers"))?size == 0 >
            <div class="row col-md-12">
                <div class="col-md-1"></div>
                <div class="col-md-11">
                    There are no pending new users
                </div>
            </div>
        <#else >
            <#list User.findPending(session.getAttributeB("showDisabledUsers")) as user >
                <div class="row col-md-12">
                    <form class="form-horizontal container" method="post" >
                        <input type="hidden" name="operation" value="update" />
                        <input type="hidden" name="username" value="${user.getUsername()}" />
                        <p></p>
                        <div class="col-md-3">
                            <div class="col-md-2"></div>
                            <div class="col-md-10">
                                <span class="usernote">
                                    <input type="checkbox" name="pending-${user.getUsername()}" onChange="this.form.submit()"
                                        ${UserRole.does(user.getId(), "UserAdmin")?then(' checked ', '')}
                                    />Pending</span>
                                <br>
                                <br>
                                <input type="checkbox" name="enable-${user.getUsername()}"
                                    ${user.getEnabled()?then(' checked ', '')}
                                    />Enabled
                                <br>
                                <input type="checkbox" name="new-user-email-${user.getUsername()}" checked />Send welcome email
                                <br>
                                <input type="checkbox" name="eater-${user.getUsername()}"
                                    ${user.doesRole("Eater")?then(' checked ', '')}
                                    />Eater
                            </div>
                        </div>
                        <div class="col-md-5">
                            Pending since: ${Util.formatTimestamp(
                                UserRole.findFirstByUserIdAndRoleOrderByTimestampDesc(user.getId(), "AccountPending").getTimestamp(),
                                "MMM d, YYYY")}
                            <br>
                            UUID: ${user.getId()}
                            <br>
                            ${user.getName()}
                            <br>
                            ${user.getAddress().street} ${user.getAddress().city} ${user.getAddress().state} ${user.getAddress().zip}
                            <br>
                            <a href="/user-map?userId=${user.getId()}&closest=5"><strong>Map</strong></a>
                            <br>
                            Incremental cost metric ${String.format("%.0f", user.getPendingUserIncrementalCostMetric())}
                            <br>(Smaller is better)
                        </div>
                        <div class="col-md-4">
                            Referred by
                            <#if Referrers.findByUserId(user.getId())?? >
                                <#assign referrerId = Referrers.findByUserId(user.getId()).getReferredByUserId() >
                                <a href="/user-details/${referrerId}" >
                                    <strong>${User.findById(referrerId).getName()}</strong>
                                </a>
                            <#else >
                                n/a
                            </#if>
                            <br>
                            <#list EmailAddress.findByUserId(user.getId()) as email >
                                ${email.getEmail()}
                                <br>
                            </#list>
                        </div>
                    <form>
                </div>
            </#list>
        </#if>

    </div>
    <p></p>
    <@jsIncludes/>

    <script>
    </script>
    </body>
</html>