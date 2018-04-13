<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<#include "macros-milkrun.ftl">

<#macro showByCategoryHeaders needHeaders category >
    <div class="row">
        <div class="col-xs-12 npm">
            <p></p>
            <span class="mine3">${category}</span>
        </div>
    </div>
    <div class="row">
        <div class="col-xs-12 npm">
            <#assign needHeaders = false >
            <div class="col-xs-2 npms" >      Supplier     </div>
            <div class="col-xs-4 npms" >Item</div>
            <#if session.getAttributeB("showPickDetails") >
                <div class="col-xs-2 npm" >
                    Buyer
                </div>
            </#if>
            <div class="col-xs-3 npm" >
                <div class="col-xs-2 npmrs" ></div>
                <#--<div class="col-xs-1 npms" >Of Qty</div>-->
                <#--<div class="col-xs-1 npms" >Tot Qty</div>-->
                <div class="col-xs-4 npms" >Qty</div>
                <div class="col-xs-4 npmrs" >Price</div>
                <div class="col-xs-2" ></div>
            </div>
            <#if ! session.getAttributeB("showPickDetails") >
                <div class="col-xs-2 npm" ></div>
            </#if>
            <div class="col-xs-1" ></div>
        </div>
    </div>
</#macro>

<#macro showCartOffer prevCartOffer totalCOQty hasMore >
    <#-- different Offer, output what we have accumulated about the previous cartoffer -->
    <div class="row">
        <div class="col-xs-12 npm">
            <#local offer = prevCartOffer.getOffer() >
            <#local item = offer.getItem() >
            <div class="col-xs-2 npm" >         ${item.getSupplier().getCompanyName()} </div>
            <div class="col-xs-4 npm" >         ${item.getShortOne()}           </div>
            <#if session.getAttributeB("showPickDetails") >
                <div class="col-xs-2 npm" >
                    <span class="sf"><i>${User.findById(prevCartOffer.getUserId()).getName()}</i></span>
                </div>
            </#if>
            <div class="col-xs-3 npm" >
                <div class="col-xs-2 npmr" >         ${totalCOQty}               </div>
                <#--<div class="col-xs-1 npmr" >         ${offer.getQuantity()}      </div>-->
                <#--<div class="col-xs-1 npmr" >         ${totalCOQty * offer.getQuantity()}   </div>-->
                <div class="col-xs-4 npmu" >         ${offer.getUnits()}         </div>
                <div class="col-xs-4 npmr" >         ${String.format("$ %.2f", (totalCOQty * prevCartOffer.getOurBuyPrice()))}    </div>
                <div class="col-xs-2" ></div>
            </div>
            <#if ! session.getAttributeB("showPickDetails") >
                <div class="col-xs-2 npm" ></div>
            </#if>
            <#if hasMore >
                <div class="col-xs-1 npm" ></div>
            <#else >
                <div class="col-xs-1 npmE" >&nbsp;</div>
            </#if>

            <#assign totalCOQty = 0 >
        </div>
    </div>
</#macro>

<head>
    <#assign UI = milkrunUnroutedUI >
    <#assign milkRun = UI.milkRun >

    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>By Category MilkRun ${milkRun.getShortId()} ${milkRun.getName()} </title>
    <@styleSheets/>
    <style>
        th {
            text-align: left;
            border-bottom:1pt solid gray;
        }
        td {
            text-align: left;
            vertical-align: text-top;
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

        .mine3 {
            padding: 0pt;
            margin: 0pt;
            font-size: 16px;
            text-align: center;
            border: 0pt;
            font-weight: bold;
        }
        .mine4 {
            padding: 0pt;
            margin: 0pt;
            font-size: 14px;
            text-align: center;
            color: #60BB60;
            border: 0pt;
        }
        .npm {
            padding: 0pt;
            margin: 0pt;
            border: 0pt;
        }
        .npmE {
            padding: 0pt;
            margin: 0pt;
            border: 0pt;
            line-height: 150%;
        }
        .npms {
            padding: 0pt;
            margin: 0pt;
            border: 0pt;
            font-weight: bold;
        }
        .npmcs {
            padding: 0pt;
            margin: 0pt;
            border: 0pt;
            font-weight: bold;
            text-align: center;
        }
        .npmrs {
            padding: 0pt;
            margin: 0pt;
            border: 0pt;
            font-weight: bold;
            text-align: right;
        }
        .npmu {
            padding: 0pt;
            margin: 0pt;
            padding-left: 8px;
            border: 0pt;
        }
        .npmr {
            padding: 0pt;
            margin: 0pt;
            border: 0pt;
            text-align: right;
        }
        .sf {
            font-size: 11px;
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
    </script>

</head>
<body class="">

    <p></p>
    <p></p>
    <div class="container">
        <div class="row">
            <div class="col-md-3">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="/admin"><strong>Admin Home</strong></a>
                <br>
                <a href="/milkrun/show/unrouted-by-consumer/${milkRun.id}"><strong>Consumer View</strong></a>
            </div>
            <div class="col-md-5">
                <h3 >${milkRun.getState().toString()} MilkRun Supplier View
                    <br>
                    <span id="theUUID" style="background-color: ${milkRun.getColor()}" >
                        &nbsp; ${milkRun.name} &nbsp; (${String.format("%8.8s...", milkRun.id)})&nbsp;
                    </span>
                </h3>
            </div>
            <div class="col-md-3">
                <a href="https://github.com/TheBlueFrog/milkrunDocs/blob/master/the-closed-milkrun.md"  target="_blank">
                    <span class="docs pull-right">Closed MilkRun</span></a>
                <p>&nbsp;</p>
                Set color
                <select id="colorSelect" onchange="colorChanged()" >
                    <#list MilkRunDB.colors as color >
                        <option value="${color}" style="background-color:${color}"
                        <#if color == milkRun.getMilkRunDB().getColor() >
                            selected
                        </#if>
                        >${MilkRunDB.getColorName(color)}</option>
                    </#list>
                </select>
            </div>
        </div>
    </div>
    <p></p>
    <div class="container">
        <div class="row">
            <div class="col-sm-4 well">
                <#if session.user.doesRole("ClosedPhaseAdmin") >
                    Split this Milkrun into two MilkRuns
                    <br>
                    <a href="/milkrun-split-manual-by-eater3/start/${milkRun.id}">
                        <p class="mine2">Manually split this MilkRun</p></a>
                    <br>
                </#if>
            </div>
            <div class="col-sm-4 well">
                <div class="col-sm-6">
                    <small>Summary</small><br>
                    Pick Total ${UI.getSupplierGrandTotalAsString()}
                    <br>
                    Drop Total ${UI.getConsumerGrandTotalAsString()}
                </div>
                <div class="col-sm-6">
                    <br>
                    Supplier Count: ${UI.getSupplierCount()}
                    <br>
                    Consumer Count: ${UI.getConsumerCount()}
                    <br>
                    CartOffer Count: ${UI.getCartOfferCount()}
                </div>
            </div>
            <div class="col-sm-3 well">
                <small>Routing</small><br>
                <a href="/milkrun-map?mapLines=false"><strong>Route Map</strong></a>
                <br>
                <a href="/extra-stops/edit?milkRunId=${milkRun.id}">
                    <strong>Extra Stops (${milkRun.getExtraStopCount()})</strong></a>
                <br>
                <#if session.user.doesRole("RoutingAdmin") >
                    <#if  ! milkRun.getRouteData().prohibitRouting() >
                        <a href="/milkrun-routing?milkRunId=${milkRun.getId()}&dumpFrozen=true" >
                            <strong>Adjust Routing</strong>
                        </a>
                    <#else >
                        <span style="background-color: #ff7777">MilkRun has errors, not routeable </span>
                    </#if>
                </#if>
            </div>
        </div>
        <p></p>

        <@showRouteErrors milkRun />

        <div class="col-sm-12">
            <div class="col-sm-3">
                <p></p>
                MilkRun start ${milkRun.getStart().getName()}
                <#--
                <select id="startSelect" onchange="startChanged(this.value)">
                    <#list system.getUsersByRoles("Admin") as admin >
                        <option value="${admin.username}"
                        <#if admin.username == milkRun.start.username >
                            selected
                        </#if>
                        >${admin.getName()}</option>
                    </#list>
                </select>
                -->
            </div>
            <div class="col-sm-3">
                <p></p>
                MilkRun end ${milkRun.getStart().getName()}
                <#--
                <select id="endSelect" onchange="endChanged(this.value)">
                    <#list system.getUsersByRoles("Admin") as admin >
                        <option value="${admin.username}"
                        <#if admin.username == milkRun.end.username >
                            selected
                        </#if>
                        >${admin.getName()}</option>
                    </#list>
                </select>
                -->
            </div>
            <div class="col-sm-3">
                <br>
                <input type="checkbox" id="showPickDetails" value="showPickDetails" onchange="showPickDetailsChanged(this.checked)"
                    <#if session.getAttributeB("showPickDetails") >
                        checked
                    </#if>
                >
                    Show Pick List Details
                </input>
                <br>
                <input type="checkbox" id="showView" value="showView" onchange="showViewChanged(this.checked)"
                >
                By Category
                </input>
                <br>
                <input type="checkbox" id="showNotes" value="showNotes"  onchange="showNotesChanged(this.checked)" checked >
                    Show Notes
                </input>
            </div>
        </div>
        <div class="row " id="noteDiv">
            <div class="col-sm-10">
            <@showNotes milkRun, true />
            </div>
            <div class="col-sm-2"></div>
        </div>
        <div id="byCategoryDiv">
            <#list ItemCategory.getItemCategories() as category >
                <#assign needHeaders = true >
                <#assign showPickListDetails = false >
                <#assign prevCartOffer = "" >
                <#assign totalCOQty = 0 >
                <#list UI.getCartOffersOfCategory(category) as cartOffer >
                    <#if needHeaders >
                        <@showByCategoryHeaders needHeaders category />
                    </#if>

                    <#if prevCartOffer != "" >
                        <!-- never show the first one, we'll do it at the end of the group -->
                        <#if session.getAttributeB("showPickDetails")
                                || (cartOffer.getOffer().getTimestamp() != prevCartOffer.getOffer().getTimestamp()) >

                            <#assign x = (cartOffer.getSeller().getId() != prevCartOffer.getSeller().getId()) >
                            <@showCartOffer prevCartOffer totalCOQty x />
                        </#if>
                    </#if>

                    <!-- accumulate totals while the offer doesn't change -->
                    <#assign totalCOQty += cartOffer.getQuantity() >
                    <#assign prevCartOffer = cartOffer >
                </#list>

                <#if prevCartOffer != "" >
                    <#-- output the last cartoffer we didn't do above -->
                    <@showCartOffer prevCartOffer totalCOQty true />
                </#if>
            </#list>
        </div>
        <div id="bySupplierDiv">
            ${UI.getSupplierTable()}
        </div>


        <p>&nbsp;</p>
    </div>

    <@jsIncludes/>
    <script>
    $(document).ready(function(){
        $('#byCategoryDiv').hide();
        $('#bySupplierDiv').show();
    });
    function verifyFunction() {
        if (confirm("Are you sure?  Closing the MilkRun is not undo-able.") == true) {
            return true;
        } else {
            return false;
        }
    }
    function startChanged(value) {
        location.assign("/milkrun/set/start/" + value);
    }
    function endChanged(value) {
        location.assign("/milkrun/set/end/" + value);
    }
    function showNotesChanged(check) {
        if (check) {
            $('#noteDiv').show();
        } else {
            $('#noteDiv').hide();
        }
    }
    function showViewChanged(check) {
        if (check) {
            $('#byCategoryDiv').show();
            $('#bySupplierDiv').hide();
        } else {
            $('#byCategoryDiv').hide();
            $('#bySupplierDiv').show();
        }
    }
    function showPickDetailsChanged(check) {
        location.assign("/milkrun/set/show-pick-details/" + check + "/${milkRun.id}");
    }
    function colorChanged() {
        var color = document.getElementById('colorSelect').value;

        var x = document.getElementById('theUUID');
        $(x).css('background-color', color);

        var y = document.getElementById('colorSelect');
        $(y).css('background-color', color);

        var index = color.indexOf('#');
        if (index > -1) {
            color = color.substring(index+1, color.length);
        }
        var url = "/session-api/milkrun/set?color=" + color + "&milkRunId=${milkRun.id}";
        $.get(url, function(data, status) {
        });
    }
    </script>


</body>
</html>