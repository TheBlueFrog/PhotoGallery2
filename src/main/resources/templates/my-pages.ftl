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
    </style>

    </head>
    <body class="">
    <@pageHeader3 />

    <p></p>
    <div class="container-fluid">
        <div class="row col-sm-12">
            <p></p>
            <h4>${session.getUser().getName()}'s Pages</h4>
        </div>
        <div class="row col-sm-12">
            <div class="col-md-2">
                <a href="/shop-list-view2"><strong>Home</strong></a>
                <br>
            </div>
            <div class="col-sm-1 col-md-1 col-lg-1"></div>
            <#--
            <#if session.user.doesRole("Admin") >
                <div class="col-md-3">
                    Logins for this account
                    <br>
                    <table>
                        <#list loginNamesOfAccount as login>
                            <tr>
                                <td width="100px">${login.loginName}</td>
                                <td width="100px">
                                    <#if login.hasPasswordBeenReset() >
                                        ${login.pwHash}
                                        <#else>
                                            <form class="form-horizontal" method="post">
                                                <input type="hidden" name="operation" value="Reset" />
                                                <input type="hidden" name="LoginName" value="${login.loginName}" />
                                                <input class="col-sm-12" type="submit" value="Reset">
                                            </form>
                                    </#if>
                                </td>
                            </tr>
                        </#list>
                    </table>
                </div>
                <div class="col-md-3">
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
            </#if>
        </div>
        -->
        <p>&nbsp;</p>
        <#--
        <div class="row col-sm-12">
            <div class="col-sm-3 well" >
                Your orders for the
                <a href="/milkrun/show2/${MilkRun.findOpen().getId()}/${session.user.username}"><strong>next MilkRun</strong></a>
            </div>
        </div>
        <p></p>
        -->
        <div class="row col-sm-12">
            <div class="col-sm-8 well" >
                Past MilkRuns
                <p>Below are the MilkRuns you have ordered from.  Selecting one will
                display the details of that run.</p>

                <#list Participation.findByUserId(session.getUser().getId()) as participation >
                    <#assign milkRun = MilkRunDB.findById(participation.getMilkRunId()) >
                    <div class="col-sm-12">
                        <div class="col-sm-2" > ${Util.formatTimestamp(milkRun.getTimestamp(), "MMM dd, YYYY")}</div>
                        <div class="col-sm-2" >
                            <a href="/milkrun/show2/${milkRun.getId()}">
                                <strong>${milkRun.getName()}</strong></a>
                        </div>
                        <div class="col-sm-2" style="text-align: right" >
                            ${String.format("$ %.2f", participation.getSellPrice())}
                        </div>
                    </div>
                </#list>
            </div>
        </div>
        <hr>

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
    </script>
    </body>
</html>
