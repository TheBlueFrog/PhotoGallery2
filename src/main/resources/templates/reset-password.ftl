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
    <@pageHeader3 />

    <#assign resetAccount = session.getAttributeS("resetLogin") >

    <div class="maincontainer">
        <form class="form-horizontal container"  name="login" method="post"  onsubmit="return validateForm()" >
            <div class="row">
                <div class="col-sm-5 col-md-5 col-lg-5">
                    <h5>This will reset the password for ${resetAccount}</h5>
                    <div class="form-group">
                        <label>New password</label>
                        <input type="hidden" name="username" value="${resetAccount}"/>
                        <input type="password" class="form-control" name="password" placeholder="Password" value="" required/>
                    </div>
                    <div class="form-group">
                        <label>New password again</label>
                        <input type="password" class="form-control" name="password2" placeholder="Password" value="" required/>
                    </div>
                    <div class="form-group">
                        <p></p>
                        <input type="hidden" name="operation" value="ResetPassword" />
                        <button class="cart-button">Reset Password</button>
                    </div>
                </div>
            </div>
        </form>
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