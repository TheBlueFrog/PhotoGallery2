<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">

<#macro stopBody stop>
    <#if stop.isPickup() >
        <@pickBody stop />
    <#elseif stop.isDelivery() >
        <@dropBody stop />
    </#if>
</#macro>

<#macro dropBody stop>
    <#--<#assign subtotal = 0 >-->
    <#assign prevSeller = "" >
    <#assign prevBuyer = "" >

    <table width="100%">
        <#list UI.getStopItems(stop.getNumber()) as row >
            <tr>
                <td width="5%">${row.getTotalQuantity()}</td>
                <td width="10%">${row.getOffer().getUnits()}</td>
                <td width="25%">${row.getItem().getShortOne()}</td>
                <td width="25%"><small>
                    <#if prevSeller != row.getSeller().getCompanyName() >
                        ${row.getSeller().getCompanyName()}
                    <#else >
                        "
                    </#if>
    	        </small></td>
                <td width="20%"><small>
                    <#if prevBuyer != row.getCartOffer().getBuyer().getName() >
                        ${row.getCartOffer().getBuyer().getName()}
                    <#else >
                        "
                    </#if>
                </small></td>
                <#--<td class="td-total" width="10%">${String.format("$ %.2f", row.getCartOffer().getOurSellPrice())}</td>-->

                <#--<#assign subtotal += row.getCartOffer().getOurSellPrice() >-->
                <#assign prevSeller = row.getSeller().getCompanyName() >
                <#assign prevBuyer = row.getCartOffer().getBuyer().getName() >
            </tr>
        </#list>
        <#--
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td class="td-grand-total" width="15%">${String.format("$ %.2f", subtotal)}</td>
        </tr>
        -->
    </table>
</#macro>

<#macro pickBody stop >
    <#assign picks = stop.getPicks() >
    <table width="100%">
        <#list stop.getSellers(picks) as seller >
            <#list stop.getItems(picks, seller) as item  >
                <tr>
                    <td width="17%"><small>${seller.getCompanyName()}</small></td>
                    <td width="15%"><small>${Util.flatten(item.getOffer().getItem().getCategories())}</small></td>
                    <td width="25%">${item.getOffer().getItem().getShortOne()}</td>
                    <td width="5%">${item.getQuantity()}</td>
                    <td width="15%">${item.getOffer().getUnits()}</td>
                    <#--<td class="td-total" width="23%">${String.format("$ %.2f", item.getOurBuyPrice())}</td>-->
                </tr>
            </#list>
        </#list>
    </table>
</#macro>

<#--
    <#if stop.isErrored() >
        <span style="background-color: #f90000; color: #000000;"> ${stop.getError()} </span>
        <br>
    <#else >
    </#if>
-->


<#macro stopHeader milkRun, prevStop, stop >
    <#local isErrored = milkRun.getRouteData().getRouteErrors().hasErrors(stop) >
    <br>
    <#--<#if isErrored >Errored<#else>NotErrored</#if>-->
    <table width="100%" id="stop-${stop.getNumber()}">
        <tr
            <#if isErrored >
                 style="background-color: #f90000; color: #000000;"
            </#if>
        >
            <td width="10%"
                <#if isErrored >
                     style="background-color: #f90000; color: #000000;"
                </#if>
            >
                <span class="big"> ${stop.getNumber()} </span>
            </td>
            <td width="20%"
                <#if isErrored >
                     style="background-color: #f90000; color: #000000;"
                </#if>
            >
                <span class="big">
                    <#if stop.isPickup() > Pick
                    <#elseif stop.isDelivery() >Drop
                    <#elseif isErrored >
                        ${stop.getNamesComma()}
                    <#else >Stop
                    </#if>
                </span>
            </td>
            <td width="70%">
                <span
                    <#if isErrored >
                         style="background-color: #f90000; color: #000000;"
                    <#else>
                         class="big"
                    </#if>
                >
                <#if isErrored >
                    <#local error = milkRun.getRouteData().getRouteErrors().getErrors(stop)?first >
                    ${error.getType().toString() }
                <#else>
                    ${stop.getNamesComma()}
                </#if>
            </span></td>
        </tr>
    </table>
    <table width="100%">
    <#if ! isErrored >
        <tr>
            <td width="15%">
                <#if stop.hasRunnerTracking(milkRun.id, "Arrive") >Arrived
                <#else>
                <button class="mine3" id="${stop.getNumberAsString()}-Arrive">Arrive</button>
                </#if>
            </td>
            <td width="15%">
                <#if stop.hasRunnerTracking(milkRun.id, "Depart") >Departed
                <#else>
                    <button class="mine3"  id="${stop.getNumberAsString()}-Depart">Depart</button>
                </#if>
            </td>
            <td width="10%"><a href="#stop-${stop.getNumber()+1}">Next</a></td>
            <td width="15%"><a href="/milkrun-map?mapLines=true"><strong>Route Map</strong></a></td>
            <td width="15%">
                <#if (stop.getUsers()?size > 0) >
                    <#assign stopuser = stop.getUsers()?first >
                    <a href="/note/create?milkRunSeriesName=${milkRun.getSeriesName()}&type=milkRunuser&userId=${stopuser.getId()}"><strong>Add Note</strong>
                    </a>
                </#if>
            </td>
        </tr>
    </#if>
    </table>
    <table width="100%">
    <#if ! isErrored >
        <tr>
            <td width="20%">
                <#if prevStop != "" >
                    <strong>
                        Travel ${String.format("%.1f Km", (Metrics.distance(prevStop, stop) / 1000))}
                        &nbsp;
                        ${Util.formatTime(Metrics.travelTimeEstimatedMs(prevStop, stop), "HH:mm:ss ' est'")}
                        &nbsp;
                        <#assign travelTime = Metrics.travelTimeMs(prevStop, stop) >
                        <#if (travelTime > 0) >
                            ${Util.formatTime(travelTime, "HH:mm:ss ' avg'")}
                        </#if>
                        &nbsp;
                        <#assign dwellTime = Metrics.stopDwellTimeMs(stop) >
                        <#if (dwellTime > 0) >
                            Dwell ${Util.formatTime(dwellTime, "HH:mm:ss ' avg'")}
                        </#if>
                    </strong>
                </#if>
            </td>
        </tr>
    </#if>
        <tr>
            <td width="40%"
                <#if isErrored >
                     style="background-color: #f90000; color: #000000;"
                </#if>
            >
                <a href="http://maps.google.com/maps?daddr=${stop.getGoogleStreetAddress()}"><strong>
                    <#if stop.streetAddress?contains("Unknown") >
                        <span class="text-danger">${stop.streetAddress}</span>
                    <#else>
                        <strong>${stop.streetAddress}</strong>
                    </#if>
                    </strong>
                </a>
            </td>
        </tr>
    </table>

    <#if (stop.getUsers()?size > 0) >
        <#assign stopuser = stop.getUsers()?first >
        <div class="row col-xs-12">
            <div class="col-xs-1"></div>
            <div class="col-xs-6">
                <ul>
                    <#list UserNote.findAllByUserId(stopuser.getId(), "NotClosed") as note>
                        <li style="background-color: #${UserNote.getColor(note)}">
                            <#if note.getBody()?? >
                                <a href="/note/edit?id=${note.id}">
                                ${note.getBody()}
                                </a>
                            </#if>
                        </li>
                    </#list>
                </ul>
                <br>
            </div>
            <div class="col-xs-5">
            </div>
        </div>
    </#if>
</#macro>

<#include "macros-milkrun.ftl">
    <head>
        <#assign UI = milkrunDeliveringUI >
        <#assign milkRun = UI.getMilkRun() >

        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta charset="UTF-8">
        <title>Delivering ${milkRun.getName()}</title>
        <@styleSheets/>
        <style>
        th {
            text-align: left;
            border-bottom:1pt solid gray;
        }
        td {
            text-align: left;
            vertical-align: text-top;
            margin-right: 5px;
        }
        .td-total {
            text-align: right;
        }
        .td-sub-total {
            text-align: right;
            font-weight: bold;
        }
        .td-grand-total {
            text-align: right;
            border-top:1pt solid gray;
            font-weight: bold;
        }

        .mine {
            text-align: center;
            color: #FFFFFF;
            background-color: #8888FF
        }
        .mine2 {
            text-align: center;
            color: #FFFFFF;
            background-color: #AAAADD
        }
        .usernote {
            color: #000000;
            background-color: #ffcccc
        }

        .mine3 {
            padding: 0pt;
            margin: 0pt;
            font-size: 14px;
            text-align: center;
            color: #7070FF;
            border: 0pt;
        }
        .mine4 {
            padding: 0pt;
            margin: 0pt;
            font-size: 14px;
            text-align: center;
            color: #60BB60;
            border: 0pt;
        }
        .big {
            font-size: 22px;
            text-align: center;
        }
        .col {
            padding-right:0px;
            padding-left:7px;
        }

    </style>
        <style type="text/css">
        @media all {
            .page-break	{ display: none; }
        }

        @media print {
              a[href]:after {
                content: none !important;
              }
            .page-break	{ display: block; page-break-before: always; }
        }

    </style>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>

        <script>
            $(document).ready(function(){
                $("button").click(function(){
                    var i = this.id;        // e.g. 2-arrive
                    var iv = "#" + i;
                    //$(iv).prop("disabled",true);

                    var x = i.split("-");
                    if (x[1] == "Arrive") {
                        $(iv).text("Arrived");
                        $(iv).css('color', '#505050');
                    } else {
                        $(iv).text("Departed");
                        $(iv).css('color', '#505050');
                    }

                    var url = "/milkrun-api2/driver?milkRunId=${milkRun.getId()}&stopNumber=" + x[0] + "&status=" + x[1];
                    $.get(url, function(data, status){
                        if(status == "success") {
                            // can't figure out how to remove the button now...
                        }
                        if (status == "error") {
                            var y = 0;
                        }
                    });

                });
            });
        </script>

    </head>
    <body class="">
    <p></p>
    <p></p>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-3">
                <#if session.getUser().doesRole("Driver") >
                    <a href="/drivers-home"><strong>Driver Home</strong></a>
                <#else >
                    <a href="/"><strong>Home</strong></a>
                </#if>
                <br>
                <#if UserRole.isAnAdmin(session.getUser().getId()) >
                    <a href="/admin"><strong>Admin Home</strong></a>
                    <br>
                    <a href="/milkruns-history"><strong>Back to MilkRun History</strong></a>
                    <br>
                    <a href="/milkruns-closed"><strong>Back to Closed MilkRuns</strong></a>
                </#if>
            </div>
            <div class="col-md-5">
                <h3 >Delivering MilkRun
                    <br>
                    <span style="background-color:${milkRun.getColor()}">
                        ${milkRun.getName()} &nbsp; (${String.format("%8.8s...", milkRun.getId())})
                    </span>
                </h3>
            </div>
        </div>
    </div>
    <div class="container-fluid">
        <div class="row ">
            <div class="col-sm-3">
                <h4>Summary</h4>
                Pick Total ${UI.getSupplierGrandTotalAsString()}
                <br>
                Drop Total ${UI.getConsumerGrandTotalAsString()}
                <br>
                CartOffer Count: ${UI.getCartOfferCount()}
                <p>
            </div>
            <div class="col-sm-3">
                <br> Time ${milkRun.getRouteData().getMetrics().getCostTimeString()}
                <br> Length ${milkRun.getRouteData().getMetrics().getKmString()}
            </div>
            <div class="col-sm-1"></div>
            <div class="col-sm-4">
                <#if session.user.doesRole("ClosedPhaseAdmin") >
                    <p></p>
                    <strong>Mark Milk Run as Delivered</strong>
                    <p>This will mark all listed CartOffers and the MilkRun as Delivered.
                        <br>
                        A MilkRun cannot be un-delivered after this.
                    </p>
                    <a href="/milkrun-delivered" onclick="return verifyFunction();"><p class="mine">Delivered</p></a>
                </#if>
            </div>
        </div>

        <@showRouteErrors milkRun />

        <div class="row">
            <div class="col-sm-6 well">
                <a href="/milkrun-map?milkRunId=${milkRun.getId()}&mapLines=true"><strong>Pick/Drop Map</strong></a>
            </div>
            <div class="col-sm-6 well">
                <@showNotes2 milkRun, true />
            </div>
        </div>

         <!-- output the undeliverable users -->
        <div class="row">
            <div class="col-xs-12">
                <p></p>
                ${UI.getUndeliverable()}
                <p></p>
                <p></p>
            </div>
        </div>

        <div class="col-xs-12">
            <#assign prevStop = "" >
            <#list milkRun.getRouteData().getStops() as stop >

                <@stopHeader milkRun, prevStop, stop />
                <@stopBody stop />

                <#assign prevStop = stop >
            </#list>
        </div>

        <p>&nbsp;</p>
        <p>&nbsp;</p>
    </div>

    <@jsIncludes/>
    <script>
    </script>


    </body>
</html>
