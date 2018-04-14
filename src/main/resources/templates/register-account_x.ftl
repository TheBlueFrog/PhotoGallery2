<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Join the Photo Gallery</title>
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
    <@pageHeader3 "register-account.ftl"/>

    <section class="banner banner-about bg-parallax">
        <div class="overlay"></div>
        <div class="container">
            <div class="banner-content text-center">
                <h2 class="page-title"><img src="/images/thelook/MilkRun_logo_white.png" alt="MilkRun Farm Delivery" /></h2>
                <div class="breadcrumbs">
                    <a href="shop-list-view3">Home</a>
                    <span>Join</span>
                </div>
            </div>
        </div>
    </section>

    <div class="maincontainer">
        <form class="form-horizontal container" name="usernameForm" method="post" onsubmit="return validateForm()" >
            <div class="row">
                <div class="col-sm-5 col-md-5 col-lg-5">
                    <h2 class="crimson-text font-italic">Account</h2>
                    <div class="form-group">
                        <label for="username" class="w3-label">User Name - only alphanumeric characters</label>
                        <input class="form-control" id="username" type="text" name="username" value="" required>
                    </div>
                    <div class="form-group">
                        <label for="password" class="w3-label">Password</label>
                        <input class="submit" id="password" type="password" name="password" value="" required>
                    </div>
                    <div class="form-group">
                        <label for="password2" class="w3-label">Password Again</label>
                        <input class="submit" id="password2" type="password" name="password2" value="" required>
                    </div>
                    <div class="form-group">
                        <label for="email" class="w3-label">Email Address</label>
                        <input class="form-control" id="email" type="email" name="email" value="" required>
                    </div>
                    <div class="form-group">
                        <input type="hidden" name="operation" value="CreateAccount" />
                        <button class="cart-button">Create Account</button>
                    </div>
                    <p></p>
                </div>
                <div class="col-sm-1 col-md-1 col-lg-1"></div>
                <div class="col-sm-6 col-md-6 col-lg-6">
                    <h2 class="crimson-text font-italic">Address</h2>
                    <div class="form-group">
                        <label for="firstName" class="w3-label">First Name</label>
                        <input class="form-control" id="firstName" type="text" name="firstName" value="" required>
                    </div>
                    <div class="form-group">
                        <label for="lastName" class="w3-label">Last Name</label>
                        <input class="form-control" id="lastName" type="text" name="lastName" value="" required>
                    </div>
                    <div class="form-group">
                        <label for="street" class="w3-label">Street Address</label>
                        <input class="form-control" id="street" type="text" name="street" value="" required>
                    </div>
                    <div class="form-group">
                        <label for="city" class="w3-label">City</label>
                        <input class="form-control" id="city" type="text" name="city" value="" required>
                    </div>
                    <div class="form-group">
                        <label for="state" class="w3-label">State</label>
                        <input class="form-control" id="state" type="text" name="state" value="" required>
                    </div>
                    <div class="form-group">
                        <label for="zip" class="w3-label">Zip Code</label>
                        <input class="form-control" id="zip" type="text" name="zip" value="" required>
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
    var x = document.forms["usernameForm"]["password"].value;
    var y = document.forms["usernameForm"]["password2"].value;
    if (x == y) {
        return true;
    }
    else {
        alert("Passwords do not match.");
        return false;
    }
}
function filterChars(e) {
    var chrTyped, chrCode=0, evt=e?e:event;

    if (evt.charCode!=null)
        chrCode = evt.charCode;
    else if (evt.which!=null)
        chrCode = evt.which;
    else if (evt.keyCode!=null)
        chrCode = evt.keyCode;

    if (chrCode==0)
        chrTyped = 'SPECIAL KEY';
    else
        chrTyped = String.fromCharCode(chrCode);

    //[test only:] display chrTyped on the status bar
//    self.status='inputDigitsOnly: chrTyped = '+chrTyped;

    //Digits, special keys & backspace [\b] work as usual:
    if (chrTyped.match(/\d|[a-zA-Z_]|[\b]|SPECIAL/))
        return true;
    if (evt.altKey || evt.ctrlKey || chrCode<28)
        return true;

    //Any other input? Prevent the default response:
    if (evt.preventDefault)
        evt.preventDefault();

    evt.returnValue=false;
    return false;
}

function addEventHandler(elem,eventType,handler) {
    if (elem.addEventListener)
        elem.addEventListener (eventType,handler,false);
    else if (elem.attachEvent)
        elem.attachEvent ('on'+eventType,handler);
    else
        return 0;
    return 1;
}

// onload: Call the init() function to add event handlers!
function init() {
    addEventHandler(document.getElementById("username"),'keypress',filterChars);
}

window.onload = function() {
    init();
}

</script>
</body>
</html>


