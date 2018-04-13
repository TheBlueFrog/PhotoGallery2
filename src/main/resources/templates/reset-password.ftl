<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Reset Password</title>
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
    <@pageHeader "shop-list-view2.ftl"/>

    <section class="banner banner-short bg-parallax">
        <div class="overlay"></div>
        <div class="container">
            <div class="banner-content text-center">
                <h2 class="page-title">Set Password</h2>
                <div class="breadcrumbs">
                    <a href="shop-list-view2">Home</a>
                    <span>Set Password</span>
                </div>
            </div>
        </div>
    </section>

    <@messageHeader session.getAttributeS("resetPasswordController-message") />

    <div class="maincontainer">
        <#if pageState.getResetUser()?? >
            <form class="form-horizontal container" name="login" method="post"  onsubmit="return validateForm()" action="/reset-password" >
                <div class="row">
                    <div class="col-sm-5 col-md-offset-2">
                        <div class="login-box">
                            <div class="form-group">
                                <label>Set the password for &nbsp; </label> ${pageState.getResetLogin()}</label>
                            </div>
                            <div class="form-group">
                                <label>New password</label>
                                <input type="password" class="form-control" name="password" placeholder="Password" value="" required/>
                            </div>
                            <div class="form-group">
                                <label>New password again</label>
                                <input type="password" class="form-control" name="password2" placeholder="Password" value="" required/>
                            </div>
                            <div class="form-group text-right">
                                <input type="hidden" name="operation" value="SetPasswordOfUser" />
                                <input type="hidden" name="resetUser" value="${pageState.getResetUser().getId()}"/>
                                <input type="hidden" name="resetLogin" value="${pageState.getResetLogin()}" />
                                <button class="btn btn-default" >Set Password</button>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </#if>
    </div>
    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>

    <script type="text/javascript" language=JavaScript>

function validateForm() {
    var x = document.forms["login"]["password"].value;
    var y = document.forms["login"]["password2"].value;
    if (x == y) {
        return true;
    }
    else {
        alert("Passwords do not match.");
        return false;
    }
}
</script>

</body>
</html>