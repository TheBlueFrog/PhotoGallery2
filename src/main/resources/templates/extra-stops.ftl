<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <#assign extraStop = session.getAttribute("extraStop") >
    <#assign milkRunId = extraStop.getMilkRunId() >
    <#assign milkRunDB = MilkRunDB.findById(milkRunId) >

    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Extra Stops for MilkRun ${milkRunId}</title>
    <@styleSheets/>
    <style>
        th { text-align: left; }
        td {
            text-align: left;
            vertical-align: text-top;
        }
        .mono {
            font-size: 14px;
            font-family:Consolas,Monaco,Lucida Console,Liberation Mono,DejaVu Sans Mono,Bitstream Vera Sans Mono,Courier New, monospace;
        }
    </style>

</head>
    <body class="">
    <header class="header">
        <@topOfPageHeader/>
    </header>
    <p></p>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-3">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="/admin"><strong>Admin Home</strong></a>
                <br>
                <a href="/milkrun/show2/${milkRunId}">
                    <strong>
                        Back to ${milkRunDB.getName()} &nbsp; (${String.format("%8.8s...", milkRunId)})
                    </strong>
                </a>

            </div>
            <div class="col-md-8">
                <h3>Manage Extra Stops of ${milkRunDB.getName()} &nbsp; (${String.format("%8.8s...", milkRunId)})
                </h3>
            </div>
        </div>
    </div>
    <div class="maincontainer">
        <div class="row">
            <div class="col-md-2"></div>
            <div class="col-md-2">Stop User</div>
            <div class="col-md-3">Stop Address</div>
            <div class="col-md-3">Note</div>
            <div class="col-md-2">Creator</div>
        </div>
        <#list MilkRunExtraStop.findByMilkRunId(milkRunId) as extraStop >
            <div class="row">
                <div class="col-md-1"></div>
                <form class="form-horizontal" method="post" action="/extra-stops" >
                    <input type="hidden" name="operation" value="Delete" />
                    <input type="hidden" name="milkRunId" value="${milkRunId}" />
                    <input type="hidden" name="extraStopId" value="${extraStop.getId()}" />
                    <div class="col-md-1">
                        <input type="submit" value="Delete">
                    </div>
                    <div class="col-md-2">
                        ${extraStop.getAddress().getName()}
                    </div>
                    <div class="col-md-3">
                        ${extraStop.getAddress().getStreetAddress()}
                    </div>
                    <div class="col-md-3">
                        ${extraStop.getNote()}
                    </div>
                    <div class="col-md-2">
                        ${extraStop.getCreatorName()}
                    </div>
                </form>
            </div>
        </#list>
    </div>
    <#if session.getUser().doesRole("ClosedPhaseAdmin")
            && (   (milkRunDB.getState().toString() == "Open")
                || (milkRunDB.getState().toString() == "Unrouted" )) >
        <div class="maincontainer">
            <form class="form-horizontal" method="post" action="/extra-stops">
                <row class="col-sm-12">
                    <input type="hidden" name="operation" value="Create" />
                    <div class="col-sm-1"></div>
                    <input class="col-sm-1" type="submit" id="createButton" value="Create">
                    <div class="col-sm-3">
                        <select  class="mono" id="StopUserSelect" onchange="stopUserChanged()">
                            <option value="None" selected >
                                None
                            </option>
                            <#list Util.sortByUserName(User.findByEnabled(true)) as user >
                                <#assign name = user.getName() >
                                <#if ! (name?contains("...")) >
                                    <option value="${user.getId()}"
                                            <#if extraStop.getStopUserId() == user.getId() >
                                                selected
                                            </#if>
                                    >
                                        ${String.format("%-60.60s   %8.8s...", name, user.getId())}
                                    </option>
                                </#if>
                            </#list>
                        </select>
                    </div>
                </row>
                <row class="col-sm-12">
                    <div class="col-sm-2"></div>
                    <div class="col-sm-3">
                        <select  class="mono" id="StopAddressSelect" onchange="stopAddressChanged()">
                            <#if extraStop.getStopUserId() != "" >
                                <option value="None" selected >
                                    None
                                </option>
                                <#list Address.findNewestByUserId(extraStop.getStopUserId()) as address >
                                    <#-- this keeps incomplete addresses out -->
                                    <#if (address.getStreet()?length > 1) && (address.getCity()?length > 1) >
                                        <option value="${address.getId()}"
                                            <#if extraStop.getStopAddressId() == address.getId() >
                                                selected
                                            </#if>
                                        > ${String.format("%-15s  %s", address.getUsage().toString(), address.getStreetAddress())}
                                        </option>
                                    </#if>
                                </#list >
                            </#if>
                        </select>
                    </div>
                </row>
                <row class="col-sm-12">
                    <div class="col-sm-2"></div>
                    <div class="col-sm-4">
                        <input type="text" name="Note" placeholder="Note" value=""/>
                    </div>
                </row>
            </form>
        </div>
    </#if>
    <p></p>
    <p></p>
    &nbsp;<br>
    &nbsp;<br>
    &nbsp;<br>

    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
    <script>
        $(document).ready(function() {
            var addressId = document.getElementById('StopAddressSelect').value;
            if (addressId.length > 10) {
                $('#createButton').attr("disabled", false);
                console.log('enable createButton');
            }
            else {
                $('#createButton').attr("disabled", true);
                console.log('disable createButton ' + addressId);
            }
        });

        function stopUserChanged() {
        var stopUserId = document.getElementById('StopUserSelect').value;
        var url = "/extra-stops/edit?milkRunId=${milkRunId}&stopUserId=" + stopUserId;
        location.assign(url);
    }
    function stopAddressChanged() {
        var stopUserId = document.getElementById('StopUserSelect').value;
        var addressId = document.getElementById('StopAddressSelect').value;
        var url = "/extra-stops/edit?milkRunId=${milkRunId}&stopUserId=" + stopUserId + "&stopAddressId=" + addressId;
        location.assign(url);
    }
    </script>
    </body>
</html>