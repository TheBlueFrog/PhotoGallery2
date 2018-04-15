<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Login to Photo Gallery</title>
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

    <div class="container">
        <div class="row">
            <form class="form-horizontal" method="post" >
                <div class="col-sm-5 col-md-5 col-lg-5">
                    <div class="form-group">
                        <label>Login</label>
                        <input type="text" class="form-control" id="loginName" name="loginName" placeholder="Login Name" value="" required/>
                    </div>
                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" class="form-control" name="password" placeholder="Password" value=""/>
                    </div>
                    <div class="form-group">
                        <p></p>
                        <input type="hidden" name="operation" value="Login" />
                        <button class="cart-button">Login</button>
                    </div>
                </div>
                <div class="col-sm-1 col-md-1 col-lg-1"></div>
                <div class="col-sm-3 col-md-3 col-lg-3">
                </div>
            </form>
        </div>
    </div>
    <div class="container">
        <div class="row">
            <div class="col-sm-1 col-md-1 col-lg-1"></div>
            <div class="col-sm-3 col-md-3 col-lg-3">
                <button class="btn btn-link " onclick="resetPassword()">Forgot your password?</button>
            </div>
        </div>
    </div>
    <p></p>

    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>

    <script>

        function resetPassword() {
            var loginName = document.getElementById('loginName').value;
            if ((typeof loginName == 'undefined') || (loginName.length < 1)) {
                alert("Please provide a Login Name");
            }
            else {
                var url = "/admin-api/reset-login?loginName=" + loginName;
                $.get(url, function (data, status) {

                    if (status == "success") {
                        var p = "?title=Login Reset&message=" + data;
                        location.assign("/general-message" + p);
                    }
                    else {

                    }
                });
            }
        }

    </script>
</body>
</html>