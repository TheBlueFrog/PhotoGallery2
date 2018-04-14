<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>User Address Editor</title>
    <@styleSheets/>

    <style>
        hr {
            display: block;
            margin-top: 0.5em;
            margin-bottom: 0.5em;
            margin-left: auto;
            margin-right: auto;
            border-style: inset;
            border-width: 1px;
        }
    </style>
</head>
<body class="">
    <header class="header">
        <@topOfPageHeader/>
    </header>

    <div class="maincontainer">
        <row class="col-sm-12">
            <div class="col-sm-1"></div>
            <div class="col-sm-8">
                <#if session.user.doesRole("Seeder") >
                    <p></p>
                    <h4>User Address Editor</h4>
                    <p>
                        The company name for ${session.user.username} can be edited here.
                    </p>
                    <form class="form-horizontal" method="post" >
                        <input type="hidden" name="operation" value="updateCompanyName" />
                        <div class="form-group">
                            <div class="form-group col-sm-3">
                                <input type="submit" value="Update">
                            </div>
                            <div class="form-group col-sm-3">
                                CompanyName
                            </div>
                            <div class="form-group col-sm-3">
                                <input type="text" name="companyName" placeholder="" value="${session.user.companyName}"/>
                            </div>
                        </div>
                    </form>
                </#if>
                <p></p>
                <h4>User Address Editor</h4>
                <p>
                </p>
                <p>
                    By default a user will have one address record, as defined during
                    the registration process.  This record will have no explicit <b>usage</b> and
                    will then be used in all situations.
                </p>
                <p>
                    The order of the below list is important since the default address is the
                    first in the list except in the usages defined below.  In the case of multiple
                    Pickup or Delivery records the first one is used.
                </p>
                <p>
                    However users may have additional address records which are used in specific
                    situations.  In this case enter the situation in which the specific record
                    is to be used in the <b>usage</b> column.
                </p>
                <p>
                    Defined usage values are:
                    <ul>
                       <li>Pickup - if the usage string contains <b>Pickup</b> this address will be used
                           during the MilkRun pickup phase instead of the default address.
                       </li>
                       <li>Delivery - if the usage string contains <b>Delivery</b> this address will be used
                           during the MilkRun delivery phase instead of the default address.
                        </li>
                    </ul>
                </p>
            </div>
        </row>
        <row>
            <div class="col-sm-1"></div>
            <div class="col-sm-2">Usage</div>
            <div class="col-sm-2">First Name</div>
            <div class="col-sm-2">Last Name</div>
            <div class="col-sm-2">Street</div>
            <div class="col-sm-1">City</div>
            <div class="col-sm-1">State</div>
            <div class="col-sm-1">Zip</div>
        </row>
    </div>
    <div class="maincontainer">

        <#list session.user.addresses as address>
            <row class="col-sm-12">
                <form class="form-horizontal" method="post" >
                    <input type="hidden" name="operation" value="updateAddress" />
                    <input type="hidden" name="addressId" value="${address.id}" />
                    <div class="form-group">
                        <div class="form-group col-sm-1">
                            <input type="submit" value="Update">
                        </div>
                        <div class="col-sm-2">
                            <input type="text" name="usage" placeholder="" value="${address.usage}"/>
                        </div>
                        <div class="col-sm-2">
                            <input type="text" name="firstName" placeholder="" value="${address.firstName}"/>
                        </div>
                        <div class="col-sm-2">
                            <input type="text" name="lastName" placeholder="" value="${address.lastName}"/>
                        </div>
                        <div class="col-sm-2">
                            <input type="text" name="street" placeholder="" value="${address.street}"/>
                        </div>
                        <div class="col-sm-1">
                            <input type="text" name="city" placeholder="" value="${address.city}"/>
                        </div>
                        <div class="col-sm-1">
                            <input type="text" name="state" placeholder="" value="${address.state}"/>
                        </div>
                        <div class="col-sm-1">
                            <input type="text" name="zip" placeholder="" value="${address.zip}"/>
                        </div>
                    </div>
                </form>
            </row>
        </#list>
    </div>
    <hr>
    <div class="col-sm-12">
        <form class="form-horizontal" id="addressForm" method="post">
            <div class="form-group">
                <input type="hidden" name="operation" value="createAddress" />
                <input class="col-sm-1" type="submit" value="Add">

                <div class="col-sm-2">
                    <input type="text" name="usage" placeholder="" value=""/>
                </div>
                <div class="col-sm-2">
                    <input type="text" name="firstName" placeholder="" value=""/>
                </div>
                <div class="col-sm-2">
                    <input type="text" name="lastName" placeholder="" value=""/>
                </div>
                <div class="col-sm-2">
                    <input type="text" name="street" placeholder="" value=""/>
                </div>
                <div class="col-sm-1">
                    <input type="text" name="city" placeholder="" value=""/>
                </div>
                <div class="col-sm-1">
                    <input type="text" name="state" placeholder="" value=""/>
                </div>
                <div class="col-sm-1">
                    <input type="text" name="zip" placeholder="" value=""/>
                </div>
        </form>
    </div>
    <p></p>
    <p></p>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
</body>
</html>
