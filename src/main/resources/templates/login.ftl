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

    <div class="maincontainer">
        <row class="col-sm-12">
            <form class="form-horizontal" method="post" >
                <div class="col-sm-5 col-md-5 col-lg-5">
                    <div class="form-group">
                        <label>Login</label>
                        <input type="text" class="form-control" name="loginName" placeholder="Login Name" value="" required/>
                    </div>
                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" class="form-control" name="password" placeholder="Password" value=""/>
                    </div>
                </div>
                <div class="col-sm-1 col-md-1 col-lg-1"></div>
                <div class="col-sm-3 col-md-3 col-lg-3">
                    <div class="form-group">
                        <p></p>
                        <input type="hidden" name="operation" value="Login" />
                        <button class="cart-button">Login</button>
                    </div>
                </div>
            </form>
        </row>
    </div>
    <div class="maincontainer">
        <row class="col-sm-12">
            <form class="form-horizontal"  method="post">
                <div class="col-sm-1 col-md-1 col-lg-1"></div>
                <div class="col-sm-3 col-md-3 col-lg-3"></div>
                    Forgotten your password?
                    <p>
                    We will reset your password and send you an email containing a
                        login link to the  email address in your account.  (This may take a few hours, as
                    this is not automated yet.)
                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" class="form-control" name="username" placeholder="Username" value="" required/>
                    </div>
                    <div class="form-group">
                        <input type="hidden" name="operation" value="ResetPasswordRequest" />
                        <button class="cart-button">Reset My Password</button>
                    </div>
                </div>
            </form>
        </row>
    </div>
    <p></p>

    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>


</body>
</html>