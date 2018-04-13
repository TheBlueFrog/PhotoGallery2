<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <title>Users</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <@styleSheets/>

    <#macro showUserName user, pending, valid >
        <div class="col-md-3">
            ${pending?then('<i>', '')}
            ${valid?then('', '<span class="text-danger">')}
                        ${user.address.lastName}, ${user.address.firstName}
                        ${valid?then('', '</span>')}
            ${pending?then('</i>', '')}
        </div>
    </#macro>

    <#macro showUUID user, pending, valid >
        <div class="col-md-2">
            ${pending?then('<i>', '')}
            ${valid?then('', '<span class="text-danger">')}
                            ${user.getUsernameShort()}...
                            ${valid?then('', '</span>')}
            ${pending?then('</i>', '')}
        </div>
    </#macro>

    <#macro showDetailLink user, valid >
        <div class="col-md-1">
            <a href="/user-details/${user.username}">
                ${valid?then('', '<span class="text-danger">')}
                    Details
                ${valid?then('', '</span>')}
            </a>
        </div>
    </#macro>

    <#macro showSwitchToLink user, valid >
        <div class="col-md-2">
            <#if session.getUser().doesRole("Admin") && ( ! UserRole.isAnAdmin(user.getId())) >
                <a href="/switch-user?userId=${user.username}">
                    ${valid?then('', '<span class="text-danger">')}
                        Switch to
                    ${valid?then('', '</span>')}
                </a>
            <#else>
                &nbsp;
            </#if>
        </div>
    </#macro>

    <#macro showCompanyName user, pending, valid >
        <div class="col-md-3">
            ${pending?then('<i>', '')}
            ${valid?then('', '<span class="text-danger">')}
                ${user.getCompanyName()}
            ${valid?then('', '</span>')}
            ${pending?then('</i>', '')}
        </div>
    </#macro>

    <#macro showNoteLink user >
        <div class="col-md-1">
            <#if user.hasUnclosedNotes() >
                <a href="/notes/filter?userIdSelector=${user.getId()}">Notes</a>
            </#if>
        </div>
    </#macro>

    <#macro showReferrer user >
        <div class="col-md-2">
            <#if user.getReferrer()?? >
                ${user.getReferrer().name}
            </#if>
        </div>
    </#macro>

    <#macro showBasicUser users >
        <div class="row">
            <div class="col-md-3"><strong>Name</strong></div>
            <div class="col-md-2"><strong>UUID</strong></div>
            <div class="col-md-1"><strong></strong></div>
            <div class="col-md-2"><strong></strong></div>
            <div class="col-md-1"><strong></strong></div>
            <div class="col-md-1"><strong>Referrer</strong></div>
        </div>
        <#list users as user >
            <#assign pending = user.doesRole("AccountPending") >
            <#assign valid = user.validAddress() >
            <div class="row">
                <@showUserName user, pending, valid />
                <@showUUID user, pending, valid />
                <@showNoteLink user />
                <@showDetailLink user, valid />
                <@showSwitchToLink user, valid />
                <@showReferrer user />
            </div>
        </#list>
    </#macro>

    <#macro showCorpUser users >
        <div class="row">
            <div class="col-md-2"><strong>Company Name</strong></div>
            <div class="col-md-3"><strong>Name</strong></div>
            <div class="col-md-2"><strong>UUID</strong></div>
            <div class="col-md-1"><strong></strong></div>
            <div class="col-md-2"><strong></strong></div>
            <div class="col-md-1"><strong></strong></div>
            <div class="col-md-1"><strong>Referrer</strong></div>
        </div>
        <#list users as user >
            <#assign pending = user.doesRole("AccountPending") >
            <#assign valid = user.validAddress() >
            <div class="row">
                <@showCompanyName user, pending, valid />
                <@showUserName user, pending, valid />
                <@showUUID user, pending, valid />
                <@showNoteLink user />
                <@showDetailLink user, valid />
                <@showSwitchToLink user, valid />
                <@showReferrer user />
            </div>
        </#list>
    </#macro>

</head>
<body class="">

<header class="header">
<@topOfPageHeader/>
</header>
<p></p>

    <div class="container">
        <div class="row" >
            <div class="col-md-3">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="/admin"><strong>Admin Home</strong></a>
                <br>
            </div>
            <div class="col-md-5">
                <h4>System Users</h4>
            </div>
            <div class="col-md-4">
            </div>
            <div class="col-md-1"></div>
        </div>

        <div class="row" >
            <p></p>
            Users with missing/incomplete Address records are shown in <span class="text-danger">red</span>.
            <br>Users who are pending are shown in italics.
            <p></p>

            <ul class="nav nav-tabs nav-stacked col-sm-1">
                <li class="active"><a data-toggle="tab" href="#search">Search</a></li>
                <li><a data-toggle="tab" href="#nonseeders">Eaters</a></li>
                <li><a data-toggle="tab" href="#seeders">Seeders</a></li>
                <li><a data-toggle="tab" href="#feeders">Feeders</a></li>
                <li><a data-toggle="tab" href="#admin">Admins</a></li>
                <li><a data-toggle="tab" href="#stripe">Stripe</a></li>
                <li><a data-toggle="tab" href="#depot">Depot</a></li>
                <li><a data-toggle="tab" href="#disabled">Disabled</a></li>
                <li><a data-toggle="tab" href="#db-utils">CSV Lists</a></li>
            </ul>
            <div  class="col-md-8" id="statisticsOutput" >
                <div class="tab-content">
                    <div id="search" class="tab-pane fade in active">
                        Search matches againt account UUID's, address record first or last name
                        and email addresses.
                        <br>
                        Search is case insensitive.
                        <br>
                        <input class="searchtext" type="text"
                               id="searchText"
                               placeholder="Search text"
                               value=""
                               autofocus
                        />
                        <div  class="col-md-12" id="matches" >
                        </div>
                    </div>
                    <div id="seeders" class="tab-pane fade">
                        <@showCorpUser seeders />
                    </div>
                    <div id="feeders" class="tab-pane fade">
                        <@showCorpUser feeders />
                    </div>
                    <div id="nonseeders" class="tab-pane fade">
                        <@showBasicUser nonSeeders />
                    </div>
                    <div id="admin" class="tab-pane fade">
                        <@showBasicUser admins />
                    </div>
                    <div id="stripe" class="tab-pane fade">
                        <@showBasicUser stripers />
                    </div>
                    <div id="depot" class="tab-pane fade">
                        <@showBasicUser depots />
                    </div>
                    <div id="disabled" class="tab-pane fade">
                        <div class="row">
                            <div class="col-md-3"><strong>Name</strong></div>
                            <div class="col-md-3"><strong>UUID</strong></div>
                            <div class="col-md-1"><strong></strong></div>
                            <div class="col-md-1"><strong></strong></div>
                            <div class="col-md-1"><strong>Referrer</strong></div>
                        </div>
                        <#list disabledUsers as user >
                            <div class="row">
                                <@showUserName user, pending, valid />
                                <div class="col-md-3">
                                    ${user.address.lastName}, ${user.address.firstName}
                                </div>
                                <div class="col-md-3">
                                    ${user.username}
                                </div>
                                <div class="col-md-1">
                                    <a href="/user-details/${user.username}">Details</a>
                                </div>
                                <div class="col-md-1">
                                </div>
                                <@showReferrer user />
                            </div>
                        </#list>
                    </div>
                    <div id="db-utils" class="tab-pane fade">
                        <div class="row">
                            <div class="col-md-4 well">
                                <small>User Filters</small>
                                <br>
                                <input type="checkbox" id="eaterCheck"> Eater
                                <br>
                                <input type="checkbox" id="seederCheck"> Seeder
                                <br>
                                <input type="checkbox" id="feederCheck"> Feeder
                                <br>
                                <p></p>
                                <small>Output Columns</small>
                                <br>
                                <input type="checkbox" id="idCheck"> Unique ID
                                <br>
                                <input type="checkbox" id="emailCheck"> email Address
                                <br>
                                <input type="checkbox" id="lastNameCheck"> Last Name
                                <br>
                                <input type="checkbox" id="firstNameCheck"> First Name
                                <br>
                                <input type="checkbox" id="firstOrderCheck"> First Order Date
                                <br>
                                <input type="checkbox" id="lastOrderCheck"> Last Order Date

                                <br>
                                <small>Seeder's Pickup, Eater's Delivery</small>
                                <br>
                                <input type="checkbox" id="geoLocationCheck"> Geo-location
                                <br>
                                <input type="checkbox" id="fuzzedGeoLocationCheck"> Fuzzed geo-location

                                <br>
                                <p></p>
                                <button onclick="emailDump()">Generate</button>
                                <br>
                                <a href="/../tmp/email-dump.csv" download>Download list shown to the right (.csv)</a>
                                <br>
                                <#--
                                    this code works up to the point where SendGrid says
                                    nope, forbidden.  probably need to pay them $
                                -->
                                <#if session.getUser().getId() == "mike" >
                                    <button onclick="sendGridContactList('b-list')">SendGrid</button>
                                </#if>
                            </div>
                            <div  class="col-md-8" id="userList" >
                            </div>
                        </div>
                </div>
            </div>
        </div>
    </div>

    <script>
    $(document).ready(function(){
        $(".nav-tabs a").click(function(){
            $(this).tab('show');
        });
    });

    var filters = '';
    var columns = '';

    function setupFilters() {
        filters = '';
        columns = '';

        // these are UserRole.Role enum values

        if($('#eaterCheck')[0].checked) {
            filters += 'Eater,'
        }
        if($('#seederCheck')[0].checked) {
            filters += 'Seeder,'
        }
        if($('#feederCheck')[0].checked) {
            filters += 'Feeder,'
        }

        if($('#idCheck')[0].checked) {
            columns += 'id,'
        }
        if($('#emailCheck')[0].checked) {
            columns += 'email,'
        }
        if($('#lastNameCheck')[0].checked) {
            columns += 'lastName,'
        }
        if($('#firstNameCheck')[0].checked) {
            columns += 'firstName,'
        }
        if($('#firstOrderCheck')[0].checked) {
            columns += 'firstOrder,'
        }
        if($('#lastOrderCheck')[0].checked) {
            columns += 'lastOrder,'
        }
        if($('#geoLocationCheck')[0].checked) {
            columns += 'lat,lng,'
        }
        if($('#fuzzedGeoLocationCheck')[0].checked) {
            columns += 'fuzzLat,fuzzLng,'
        }

        columns = columns.slice(0, columns.length-1);
    }

    function  emailDump() {
        setupFilters();
        var url = "/admin-api/get-user-list?filters=" + filters + "&columns=" + columns;
        dump(url);
    }
//        <input type="checkbox" id="lastNameCheck"> Last Name
//        <input type="checkbox" id="firstNameCheck"> Last Name
//        <input type="checkbox" id="firstOrderCheck"> First Order Date
//        <input type="checkbox" id="lastOrderCheck"> Last Order Date

    function dump(url) {
        $.get(url, function(data, status){
            var node = document.getElementById('userList');
            node.innerHTML = data;
        });
    }

    function sendGridContactList(listName) {
        setupFilters();
        var url = "/admin-api/get-user-list?filters=" + filters + "&columns=" + columns;
        $.get(url, function(data, status) {
            // we now have a file in a well-known place
            var url = "/users/create/contact-list?listName=" + listName;
            $.get(url, function(data, status) {
                var x = 0;
            });
        });
    }

    function  firstLastOrder() {
        var url = "/admin-api/get-user-list?columns=email,lastName,firstName,firstOrder,lastOrder";
        $.get(url, function(data, status){
            var x = 0;
            if(status == "success") {
                var node = document.getElementById('userList');
                node.innerHTML = data;
            }
            if (status == "error") {
                var y = 0;
            }
        });
    }

    $('#searchText').bind("keyup", function (event) {

        var node = document.getElementById('matches');
        while (node.hasChildNodes()) {
            node.removeChild(node.lastChild);
        }

        var s = "";
        var txt = document.getElementById ("searchText").value;
        var re = new RegExp(txt, "i");
        for (var i = 0; i < users.length; i++) {
            var found = users[i][0].match(re) || users[i][1].match(re) || users[i][2].match(re);
            if (found) {
                s += users[i][3];
            }
        }
        node.innerHTML = s;
    });

    function searchChange(txt) {
        var node = document.getElementById('matches');
        var s = "";
        for (var i = 0; i < users.length; i++) {
            var re = new RegExp(txt, "i");
            var found = users[i][0].match(re) || users[i][1].match(re) || users[i][2].match(re);
            if (found) {
               s += users[i][3];
            }
        }
        node.innerHTML = s;
    }

    // table of user info
    // UUID, concat of emails, concat of names, HTML display row
    var users = [
        <#list User.findByEnabled(true) as user >
            [   "${user.getId()}",
                "${user.getName()}"
                <#list EmailAddress.findByUserId(user.getId()) as email >
                    + '${email.getEmail()}'
                </#list>
                ,
                <#list Address.findAllByUserNameOrderByUsageDesc(user.getId()) as address >
                    '${address.getName().replace("'", "")}'
                    <#if address?has_next > + </#if>
                </#list>
                ,
                         '<div class="col-md-3">'
                    +      "${user.getName()}"
                    +    '</div>'

                    +    '<div class="col-md-2">'
                    +      "${user.getIdShort()}..."
                    +    '</div>'

                    +    '<div class="col-md-1">'
                    +      '<a href="/user-details/' + "${user.username}" + '">Details</a>'
                    +    '</div>'

                    +    '<div class="col-md-2">'
                           <#if UserRole.isAnAdmin(user.getId()) >
                    +        '&nbsp;'
                           <#else>
                    +        '<a href="/switch-user?userId=${user.username}">Switch to</a>'
                           </#if>
                    +    '</div>'
                    +    '<div class="col-md-4">&nbsp;</div>'
                    +  '<br>'

             ] <#if user?has_next >, </#if>
        </#list>
    ];

    </script>

</body>
</html>
