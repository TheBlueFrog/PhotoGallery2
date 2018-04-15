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
    <@pageHeader3 />

    <section class=" banner-short ">
        <div class="container">
            <div class=" text-center">
                <h2 class="page-title">Create Your Account</h2>
                <div class="breadcrumbs">
                    <a href="/">Home</a>
                    <span>Create Account</span>
                </div>
            </div>
        </div>
    </section>

    <@messageHeader session.getAttributeS("registerUserController-message") />

    <div class="maincontainer">
        <form class="form-horizontal container"
              name="usernameForm" method="post" onsubmit="return validateForm()" action="/register-account">
            <div class="row">
                <div class="col-sm-4 col-md-4 col-lg-4">
                    <div class="form-group">
                        <label for="username" class="w3-label">Email Address</label>
                        <input class="form-control" id="username"
                               type="text" name="username"
                               value="${session.getAttributeS("registerUsername")}" required />
                    </div>
                    <div class="form-group">
                        <label for="password" class="w3-label">Password</label>
                        <input class="form-control" id="password"
                               type="password" name="password"
                               placeholder=""
                               value="" required/>
                    </div>
                    <div class="form-group">
                        <label for="password2" class="w3-label">Password Again</label>
                        <input class="form-control" id="password2" type="password" name="password2" value="" required>
                    </div>
                </div>
                <div class="col-sm-1 col-md-1 col-lg-1"></div>
                <div class="col-sm-3 col-md-3 col-lg-3">
                    <div class="form-group">
                        <input type="hidden" name="operation" value="CreateAccount" />
                        <button class="btn btn-primary">Create Account</button>
                    </div>
                </div>
                <div class="col-sm-4 col-md-4 col-lg-4">
                    <div class="form-group">
                        <label for="referrer" class="w3-label">Referred by</label>
                        <input class="form-control" id="referrer" type="text" name="referrer" placeholder="Email of referring customer" >
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
    // var xx = document.forms["usernameForm"]["username"].value;
    // if (xx.match(/[^a-zA-Z0-9_\-+@\.]/)) {
    //     alert("Invalid characters in email address.");
    //     return false;
    // }
    // if ((xx.match(/[@]/) == null) || (xx.match(/[.]/) == null)) {
    //     alert("Email does not look like a valid email address.");
    //     return false;
    // }

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
    if (chrTyped.match(/\d|[a-zA-Z0-9_+\-@\.]|[\b]|SPECIAL/))
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


