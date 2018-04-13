<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Administration</title>
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

    td {
            text-align: left;
            vertical-align: text-top;
    }

    </style>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>


</head>
<body class="">
    <#assign user = session.user >

    <@pageHeader3 />

    <p></p>
    <row class="container-fluid">
        <row class="col-sm-12">
            <div class="col-sm-1 col-md-1 col-lg-1"></div>
            <div class="col-md-2">
            <p></p>
            <h4>${user.getName()}'s Pages</h4>
            </div>
        </row>
        <div class="col-md-12">
            <div class="col-md-1"></div>
            <div class="col-md-5">
                <a href="/shop-list-view2"><strong>Home</strong></a>
                <br>
                <a href="/eater-address-editor" ><strong>My Addresses</strong></a>
                <br>
                <a href="/change-password" ><strong>Change My Password</strong></a>
                <p>&nbsp;</p>
                <form method="post">
                    <input type="hidden" name="operation" value="enableSearchTruncation" />
                        <input type="checkbox" name="enableSearchTruncation" onChange="this.form.submit()"
                        <#if user.getPrefs().getSearchTruncation() >
                            checked
                        </#if>
                        /> Truncate search results if no match
                </form>
            </div>
            <div class="col-md-4">
                <h4>Login Names</h4>
                <table>
                    <#list LoginName.findAllByUserId(user.getUsername()) as login >
                        <tr>
                            <td width="400px">${login.getLoginName()}</td>
                            <td width="300px">
                                <#if login.hasPasswordBeenReset() >
                                    Password Reset Code: &nbsp; ${login.getPwHash()}
                                <#else>
                                    <form class="form-horizontal" method="post">
                                        <input type="hidden" name="operation" value="Reset" />
                                        <input type="hidden" name="LoginName" value="${login.getLoginName()}" />
                                        <input type="submit" value="Reset">
                                    </form>
                                </#if>
                            </td>
                        </tr>
                    </#list>
                </table>
                <p></p>
                <form class="form-horizontal" method="post">
                    <div class="form-group">
                        <input type="hidden" name="operation" value="CreateLogin" />
                        <div class="col-sm-1"></div>
                        <div class="col-sm-5">
                            <input type="text" id="NewLoginName" name="NewLoginName" placeholder="New login name" value=""/>
                        </div>
                        <div class="col-sm-6">
                            <input type="submit" value="Create">
                        </div>
                    </div>
                </form>
            </div>
        </row>
        <p>&nbsp;</p>
        <row class="col-sm-12">
            <div class="col-sm-1" ></div>
            <div class="col-sm-9" >
                <div class="col-sm-6">
                    Reviews written by me
                    <br>
                    <#list Rating.getRatingsBy(user) as rating >
                        <div class="col-sm-2">
                            ${Util.formatTimestamp(rating.getTime(), "MM/DD/YY")}
                        </div>
                        <div class="col-sm-2">
                        ${rating.getRating()} stars
                        </div>
                        <div class="col-sm-8">
                        ${rating.getBody()}
                        </div>
                    </#list>
                </div>
                <div class="col-sm-6">
                    Reviews of Me
                    <br>
                    <#list Rating.getRatingsOf(user) as rating >
                        <div class="col-sm-2">
                        ${Util.formatTimestamp(rating.getTime(), "MM/DD/YY")}
                        </div>
                        <div class="col-sm-2">
                        ${rating.getRating()} stars
                        </div>
                        <div class="col-sm-8">
                        ${rating.getBody()}
                        </div>
                    </#list>
                </div>
            </div>
        </row>
        <p>&nbsp;</p>
        <p>&nbsp;</p>
        <row class="col-sm-12">
            <div class="col-sm-1" ></div>
            <div class="col-sm-3" >
                Your orders for the
                <a href="/milkrun/show2/${MilkRun.findOpen().getId()}/${user.username}"><strong>next MilkRun</strong></a>
            </div>
            <div class="col-sm-1" ></div>
            <div class="col-sm-7" >
            </div>
        </row>
        <p>&nbsp;</p>
        <p>&nbsp;</p>
        <row class="col-sm-12">
            <div class="col-sm-1" ></div>
            <div class="col-sm-10" >
                <strong>Past Orders</strong>
                <br>
                <label>
                    <input type="checkbox" id="showOrderHistory" onchange="showOrderHistoryChanged()" checked>
                    Show ordering history details
                </label>
                <br>

                <p></p>
                <table>
                    <tr>
                        <th>Order Again</th>
                        <th>Times Ordered</th>
                        <th>Total Quantity</th>
                        <th></th>
                        <th></th>
                    </tr>
                    <#list PastOrder.findByUser(session.user) as pastOrder >
                        <tr class="">
                            <td>
                                <#if pastOrder.getOffer().getEnabled() >
                                    <input type="checkbox" name="${pastOrder.getOffer().getTimeAsId()}"
                                           onchange="addToCart(${pastOrder.getOffer().getTimeAsId()})">
                                <#else>
                                    <a href="/shop-list-view2/similar/${pastOrder.getOffer().getTimeAsString()}">n/a</a>
                                </#if>

                            </td>
                            <td>
                                ${pastOrder.getNumOrders()}
                            </td>
                            <td>
                                ${pastOrder.getQuantity()}
                            </td>
                            <td>
                                ${pastOrder.getOffer().getItem().getShortOne()}

                                <#list pastOrder.getCartOffers() as cartoffer >
                                    <div class="pastOrderDiv">
                                        <#if cartoffer.getOffer().getEnabled() >
                                            ${Util.formatTimestamp(cartoffer.getTime(), "MM/dd/YYYY")}
                                        <#else>
                                            <i>${Util.formatTimestamp(cartoffer.getTime(), "MM/dd/YYYY")}</i>
                                        </#if>
                                        <br>
                                    </div>
                                </#list>
                            </td>
                            <td>
                                ${pastOrder.getOffer().getItem().getDescription()}
                            </td>
                        </tr>
                    </#list>
                </table>
            </div>
        </row>
    </div>

    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
    <script>
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
    if (chrTyped.match(/\d|[a-zA-Z0-9_]|[\b]|SPECIAL/))
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
    addEventHandler(document.getElementById("NewLoginName"),'keypress',filterChars);
    }

    window.onload = function() {
    init();
    }

    function showOrderHistoryChanged() {
        var x = document.getElementById('showOrderHistory').checked;
        if (x) {
            jQuery('.pastOrderDiv').show();
        } else {
            jQuery('.pastOrderDiv').hide();
        }
    }

    function showDisabledOrderHistoryChanged() {
        var x = document.getElementById('showDisabledOrderHistory').checked;
        if (x) {
            jQuery('.PastOrderDivDisabled').show();
        } else {
            jQuery('.PastOrderDivDisabled').hide();
        }
    }


    function addToCart(offerId) {
        var url = "/shop-api/addToCart/" + offerId + "/1/once";
        $.get(url, function(data, status){
            var x = 0;
            if(status == "success") {
                var y = 0;
            }
            if (status == "error") {
                var y = 0;
            }
        });

    }

    </script>
</body>
</html>