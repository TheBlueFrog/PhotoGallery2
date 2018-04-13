


<#macro showPickList list >
    <p></p>
    ${list}
    <p></p>
    <p></p>
</#macro>

<#macro showDropList list >
    <p></p>
    ${list}
    <p></p>
    <p></p>
</#macro>

<#macro showNotes milkRun, showAddNote >
    <h4>Notes</h4>
    <#if showAddNote >
        <a href="/note/create?milkRunSeriesName=${milkRun.getSeriesName()}&type=milkRun&returnTo=/milkrun/show2/${milkRun.getId()}"><strong>Add Note</strong></a>
    </#if>
    <p></p>
    <table style="width:90%">
        <#local seriesName = milkRun.getSeriesName() >
        <#list UserNote.findAllByMilkRunSeriesNameAndStatus(seriesName, "Open") as note>
            <tr  style="background-color: #${UserNote.getColor(note)}">
                <td>
                    <#if note.getUser()?? >
                        <a href="/note/edit?id=${note.id}&returnTo=/milkrun/show2/${seriesName}"
                           data-toggle="tooltip" title="${note.getBody()}"> ${note.getUser().getName()} </a>
                    </#if>
                </td>
                <td>
                    <#if note.getBody()?? >
                        <a href="/note/edit?id=${note.id}&returnTo=/milkrun/show2/${milkRun.getId()}"
                           data-toggle="tooltip" title="${note.getBody()}">
                            <span> ${note.getBody()} </span>
                        </a>
                    </#if>
                </td>
            </tr>
        </#list>
    </table>
</#macro>

<#macro showNotes2 milkRun, showAddNote >
    <h4>Notes</h4>
    <#if showAddNote >
        <a href="/note/create?milkRunSeriesName=${milkRun.getSeriesName()}&type=milkRun"><strong>Add Note</strong></a>
    </#if>
    <p></p>
    <table style="width:90%">
        <#local seriesName = milkRun.getSeriesName() >
        <#list UserNote.findAllByMilkRunSeriesNameAndStatus(seriesName, "Open") as note>
            <tr  style="background-color: #${UserNote.getColor(note)}">
                <td>
                    <#if note.getUser()?? >
                        <a href="/note/edit?id=${note.id}"
                           data-toggle="tooltip" title="${note.getBody()}">
                            ${note.getUser().getName()} </a>
                    </#if>
                </td>
                <td >
                    <#if note.getBody()?? >
                        <a href="/note/edit?id=${note.id}"
                           data-toggle="tooltip" title="${note.getBody()}">
                            <span > ${note.getBody()} </span>
                        </a>
                    </#if>
                </td>
            </tr>
        </#list>
    </table>
</#macro>

<#macro showRoute milkRun >
    <h4>Route</h4>

        <table style="width:100%">
            <#list milkRun.getRouteData().getStops() as stop >
                <#if (stop.getAddress().hasValidGeoLocation()) >
                    <tr>
                        <td style="width:4%">
                            <#if stop.getAction().toString() == "Stop" >
                                <i>${stop.getNumberAsString()}</i>
                            <#else>
                                ${stop.getNumberAsString()}
                            </#if>
                        </td>
                        <td style="width:8%">
                            <a href="http://maps.google.com/maps?daddr=${stop.getLocation().getLatitude()},${stop.getLocation().getLongitude()}">
                                <#if stop.getAction().toString() == "Stop" >
                                    <i>${stop.getAction().toString()}</i>
                                <#else>
                                    ${stop.getAction().toString()}
                                </#if>
                            </a>
                        </td>
                        <td style="width:25%">
                            <#list stop.getUserIds() as userId >
                                <a href="#${userId}">
                                    <span class="mine4">
                                        <#if stop.getAction().toString() == "Stop" >
                                            <i>${User.findById(userId).getName()}</i>
                                        <#else>
                                            ${User.findById(userId).getName()}
                                        </#if>
                                    </span>
                                </a>
                                <#if userId?has_next >, </#if>
                            </#list>
                        </td>
                        <td style="width:7%">
                            <#if stop.hasUnclosedNotes() >
                                <#local notes = stop.getUnclosedNotes() >
                                <#if (notes?size > 1) >
                                    <#local ids = "" >
                                    <#list stop.getUnclosedNotes() as note >
                                        <#local ids = ids + note.getId() + "," >
                                    </#list>
                                    <#local backURL = ("/milkrun/show2/" + milkRun.getId()) >
                                    <a href="/notes-list?title=MilkRun Stop Notes&backURL=${backURL}&ids=${ids}">
                                        <span class="text-danger">Notes</span>
                                    </a>
                                <#else>
                                    <#local backURL = ("/milkrun/show2/" + milkRun.getId()) >
                                    <a href="/note/edit?id=${notes?first.getId()}&backURL=${backURL}"
                                       data-toggle="tooltip" title="${notes?first.getBody()}">
                                        <span class="text-danger">Note</span>
                                    </a>
                                </#if>
                            </#if>
                        </td>
                        <td class="td-total" style="width:6%">
                            <#if ! stop?is_first >
                                ${String.format("%.1f", (Metrics.distance(prevStop, stop) / 1000))}
                            </#if>
                        </td>
                        <td class="td-total" style="width:2%">
                        </td>
                        <td style="width:55%">
                            <#if stop.streetAddress?contains("Unknown") >
                                <span class="text-danger">${stop.streetAddress}</span>
                            <#else>
                                <#if stop.getAction().toString() == "Stop" >
                                    <i>${stop.streetAddress}</i>
                                <#else>
                                    ${stop.streetAddress}
                                </#if>
                            </#if>
                        </td>
                    </tr>
                    <#local prevStop = stop >
                </#if>
            </#list>
        </table>
    <p></p>
</#macro>

<#macro noCartsCharge>
<tr>
    <td></td>
    <td></td>
    <td></td>
    <td>(no carts)</td>
    <td></td>
</tr>
</#macro>

<#macro nonStripeCharge buyerId evenItem buttons addNote >

    <#local theUser = User.findById(buyerId) >
    <#local addressIsValid = true >

    <#if ! Address.findNewestByUserIdAndUsageS(buyerId, "Delivery").isValid() >
        <#assign haveInvalidAddress = true >
        <#local addressIsValid = false >
    </#if>

    <tr style="background-color:
        <#if evenItem > lightcyan <#else > whitesmoke </#if>
        ">
        <td>
            <#local tt = "">
            <#if ! addressIsValid >
                <#local tt = tt + " Invalid address.">
            </#if>

            <span style="background-color: lightpink; color: lightpink" data-toggle="tooltip" title="${tt}">XXX</span>
        </td>

        <td> <@buttons buyerId 0 /> </td>
        <td> <@addNote buyerId /> </td>
        <td>
            <#local notes = UserNote.findByUserIdAndStatusOrderByTimestamp(buyerId, "Open" ) >
            <#list notes as note >
                <a href="javascript:void(0)" onclick="editNote('${note.getId()}')"
                    class="btn btn-link btn-sm"
                    <#if note.getColor().toString() != "Default" > style="background-color: #${UserNote.getColor(note)}"</#if>
                    data-toggle="tooltip" title="${note.getBody()}"
                    >
                    ${String.format("%30.30s", note.getBody())}
                </a>
                <#if note?has_next> <br> </#if>
            </#list>
        </td>
        <td>
            <#if ! addressIsValid >
                <a href="/user-details/${theUser.getId()}"> <span style="background-color: lightpink">${theUser.getName()}</span> </a>
            <#else >
                <a href="/user-details/${theUser.getId()}"> ${theUser.getName()} </a>
            </#if>

            <#list CartDiscount.findByDiscountUserIdAndMilkRunNameOrderByTimestampAsc(buyerId, milkRun.getName())
                    as cartDiscount >
                <br>
                <button class="btn btn-link btn-sm"
                        onClick="editCartDiscount('${buyerId}', '${String.format("%d", cartDiscount.getTimestamp().getTime())}')">
                    <i>Discount:
                    ${Util.formatTimestamp(cartDiscount.getTimestamp(), "MM/d/YY")}
                        &nbsp;
                    ${cartDiscount.getName()}
                    </i>
                </button>
            </#list>
        </td>

        <td class="td-total">
            <#local netAmount = pageState.getUserGrossAmount(buyerId) >
            ${String.format("$ %.2f", netAmount)}

            <#list CartDiscount.findByDiscountUserIdAndMilkRunNameOrderByTimestampAsc(buyerId, milkRun.getName())
                    as cartDiscount >
                <br>
                <i>
                    - &nbsp;${String.format("$ %.2f", cartDiscount.getAmount(netAmount))}
                </i>
                <#local netAmount -= cartDiscount.getAmount(netAmount) >
            </#list>
            <br>
            <#assign error = pageState.getUserNetAmount(buyerId) - netAmount >
            <#if (error > 0.01) >
                Error
            </#if>
            <span class="td-grand-total">${String.format("$ %.2f", netAmount)}</span>
            <br>&nbsp;
        </td>
    </tr>
</#macro>

<#macro nonStripeChargeEmail buyerId evenItem buttons >
    <tr>
        <td>
            <#list EmailAddress.findByUserId(buyerId) as email >
                ${email.getEmail()}  <br>
            </#list>
        </td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
    </tr>
</#macro>

<#macro withStripeCharge authd buyerId evenItem buttons addNote >

    <#local addressIsValid = true >

    <#if ! Address.findNewestByUserIdAndUsageS(buyerId, "Delivery").isValid() >
        <#assign haveInvalidAddress = true >
        <#local addressIsValid = false >
    </#if>

    <tr style="background-color:
        <#if evenItem > lightcyan <#else > whitesmoke </#if>
        ">

        <td>
            <#if addressIsValid && authd >
            <#else>
                <#local tt = "">
                <#if ! addressIsValid >
                    <#local tt = tt + " Invalid address.">
                </#if>
                <#if ! authd >
                    <#local tt = tt + " Not checked out.">
                </#if>

                <span style="background-color: lightpink; color: lightpink" data-toggle="tooltip" title="${tt}">XXX</span>
            </#if>
        </td>
        <td>
            <#if StripeCharge.hasPaidForMilkRun(buyerId, milkRun.getId()) >
                <span style="background-color: palegreen"> Paid </span>
            <#else >
                <@buttons buyerId pageState.getUserNetAmount(buyerId) />
            </#if>
        </td>
        <td> <@addNote buyerId /> </td>
        <td>
            <#local notes = UserNote.findByUserIdAndStatusOrderByTimestamp(buyerId, "Open" ) >
            <#list notes as note >
                <a href="javascript:void(0)" onclick="editNote('${note.getId()}')"
                   class="btn btn-link btn-sm"
                   <#if note.getColor().toString() != "Default" > style="background-color: #${UserNote.getColor(note)}"</#if>
                   data-toggle="tooltip" title="${note.getBody()}"
                >
                ${String.format("%30.30s", note.getBody())}
                </a>
                <#if note?has_next><br></#if>
            </#list>
        </td>
        <td>
            <#if ! addressIsValid >
                <a href="/user-details/${buyerId}"> <span style="background-color: lightpink">${User.findById(buyerId).getName()}</span> </a>
            <#else >
                <a href="/user-details/${buyerId}"> ${User.findById(buyerId).getName()} </a>
            </#if>
            <#list CartDiscount.findByDiscountUserIdAndMilkRunNameOrderByTimestampAsc(buyerId, milkRun.getName())
                as cartDiscount >
                <br>
                <button class="btn btn-link btn-sm"
                        onClick="editCartDiscount('${buyerId}', '${String.format("%d", cartDiscount.getTimestamp().getTime())}')">
                    <i>Discount:
                    ${Util.formatTimestamp(cartDiscount.getTimestamp(), "MM/d/YY")}
                        &nbsp;
                    ${cartDiscount.getName()}
                    </i>
                </button>
            </#list>
            <#list StripeCharge.findByUserIdAndMilkRunIdOrderByTimestampDesc(buyerId, milkRun.getId()).getCharges()
                    as charge >
                <br>
                <#if charge.getStatus() == "succeeded" >
                    <a href="/stripe-charge-details?userId=${buyerId}&id=${charge.getId()}">
                        Paid: ${Util.formatTimestamp(charge.getCreated()*1000, "MMM d, YY HH:mm")}
                    </a>
                <#else >
                    <span style="color: black; background-color: hotpink">
                        ${Util.formatTimestamp(charge.getCreated()*1000, "MMM d, YY HH:mm")}
                        <br>
                        ${charge.getFailureMessage()}
                    </span>
                </#if>
            </#list>
<#--
            <#if session.getAttributeS("stripeController-message-${buyerId}")?? >
                <br>
                <span style="color: black; background-color: hotpink">
                    ${session.getAttributeS("stripeController-message-${buyerId}")}
                </span>
            </#if>
-->
        </td>
        <td class="td-total">
            <#local netAmount = pageState.getUserGrossAmount(buyerId) >
            <#local numRows = 1 >
            ${String.format("$ %.2f", netAmount)}

            <#list CartDiscount.findByDiscountUserIdAndMilkRunNameOrderByTimestampAsc(buyerId, milkRun.getName())
                    as cartDiscount >
                <br>
                <i>
                    - &nbsp; ${String.format("$ %.2f", cartDiscount.getAmount(netAmount))}
                </i>
                <#local netAmount -= cartDiscount.getAmount(netAmount) >
                <#local numRows = numRows + 1 >
            </#list>

            <#list StripeCharge.findByUserIdAndMilkRunIdOrderByTimestampDesc(buyerId, milkRun.getId()).getCharges()
                    as charge >
                <br>
                <#if charge.getStatus() == "succeeded" >
                    <a href="/stripe-charge-details?userId=${buyerId}&id=${charge.getId()}">
                        - &nbsp; ${String.format("$ %.2f", StripeCharge.toDollars(charge.getAmount()))}
                    </a>
                    <#local netAmount -= StripeCharge.toDollars(charge.getAmount()) >
                <#else >
                </#if>
                <#local numRows = numRows + 1 >
            </#list>
            <br>
            <span class="td-grand-total"> ${String.format("$ %.2f", netAmount)}</span>
            <br>&nbsp;
        </td>
        <td>
            <#assign error = pageState.getUserNetAmount(buyerId) - netAmount >
            <#if (error > 0.01) >
                Error
            </#if>

            <#list 1..numRows as r >    <!-- move down to net owed -->
                <br>&nbsp;
            </#list>

            <#if UserRole.is(session.getUser().getId(), "StripeAdmin") >
                <#if (netAmount > StripeWrapper.getMinimumCharge()) >
                    <button class="btn btn-link btn-sm" style="background-color:#FFBBBB" onClick="chargeCart('${buyerId}', '${netAmount}')">Charge</button>
                <#else >
                    <#if (netAmount > 0.01) >
                        <span style="color: hotpink">  ${netAmount} is below Stripe Minimum</span>
                    </#if>
                </#if>
            </#if>
        </td>
        <td>
            <#list 1..numRows as r >    <!-- move down next to Charge button -->
                <br>&nbsp;
            </#list>
            <#if UserRole.is(session.getUser().getId(), "StripeAdmin") && (netAmount > StripeWrapper.getMinimumCharge()) >
                <input type="checkbox" onchange="groupChargeChanged(this, '${buyerId}')"/>GC
            </#if>
        </td>
    </tr>
</#macro>

<#macro showRouteErrors milkRun>
    <#if milkRun.getRouteData().isPostUnrouted() >
        <@showRouteErrorsPostUnrouted milkRun />
    <#else >
        <@showRouteErrorsNotPostUnrouted milkRun />
    </#if>
</#macro>

<#macro showRouteErrorsNotPostUnrouted milkRun>
    <#if milkRun.getRouteData().prohibitRouting() >
        <div class="row">
            <div class="col-sm-12 well"  style="background-color: #f90000">
                <#list milkRun.getRouteData().getRouteErrors().getErrors() as error >
                    <span style="color: #000000">
                        <#if error.getType().toString() == "DidNotPickFor" >
                            <#local addr = error.getUser().getAddress("Delivery") >
                            <a href="/user-details/${addr.getUserId()}" >
                                ${String.format("Route does not pick for user %s (%8.8s...)",
                                    addr.getAddress().getName(),
                                    addr.getUserId())}
                            </a>
                        </#if>
                        <#if error.getType().toString() == "DidNotDropTo" >
                            <#local addr = error.getUser().getAddress("Delivery") >
                            <a href="/user-details/${addr.getUserId()}" >
                                ${String.format("Route does not drop to user %s (%8.8s...)",
                                    addr.getName(),
                                    addr.getUserId())}
                            </a>
                        </#if>
                        <#if error.getType().toString() == "InvalidStopGeoLocation" >
                            <#local addr = error.getAddress() >
                            <a href="/user-details/${addr.getUserId()}" >
                                ${String.format("Can not make stop, %s address of user %s (%8.8s...) has an invalid geolocation",
                                    addr.getUsage().toString(),
                                    addr.getName(),
                                    addr.getUserId())}
                            </a>
                        </#if>
                        <#if error.getType().toString() == "InvalidExtraStopGeoLocation" >
                            <#local addr = error.getAddress() >
                            <a href="/extra-stops/edit?milkRunId=${milkRun.getId()}">
                                ${String.format("Can not make extra stop, %s address of user %s (%8.8s...) has an invalid geolocation",
                                    addr.getUsage().toString(),
                                    addr.getName(),
                                    addr.getUserId())}
                            </a>
                        </#if>
                        <#if error.getType().toString() == "AddressNotCurrent" >
                            <#local addr = error.getAddress() >
                            <a href="/extra-stops/edit?milkRunId=${milkRun.getId()}">
                                ${String.format("Route extra stop at %s, %s (%8.8s...) address is not current. Usage %s",
                                User.findById(error.getAddress().getUserId()).getName(),
                                    addr.getStreetAddress(),
                                    addr.getId(),
                                    addr.getUsage().toString())}
                            </a>
                        </#if>
                        <#if error.getType().toString() == "DeadStop" >
                            <#local addr = error.getStop().getAddress() >
                            <a href="/user-details/${addr.getUserId()}" >
                                ${String.format("Route stops at %s (%8.8s...) of user %s (%8.8s...) but does not pick or drop.",
                                    addr.getStreetAddress(),
                                    addr.getId(),
                                    addr.getName(),
                                    addr.getUserId())}
                            </a>
                        </#if>
                        <#--  missing extra stops is not an error until
                              after we are routed
                        <#if error.getType().toString() == "MissingExtraStop" >
                            <a href="/extra-stops/edit?milkRunId=${milkRun.getId()}">
                                <#local extraStop = error.getExtraStop() >
                                <#if extraStop.getStopUser()?? >
                                    ${String.format("Extra stop at %s, %s (%8.8s...) is not in the route. Usage %s",
                                        extraStop.getAddress().getStreetAddress(),
                                        extraStop.getStopUser().getName(),
                                        extraStop.getStopUser().getId(),
                                        extraStop.getAddress().getUsage().toString())}
                                <#else>
                                    ${String.format("Extra stop at %s, is not in the route. Usage %s",
                                        extraStop.getAddress().getStreetAddress(),
                                        extraStop.getAddress().getUsage().toString())}
                                </#if>
                            </a>
                        </#if>
                        -->
                    </span>
                    <br>
                </#list>
            </div>
        </div>
    </#if>
</#macro>

<#macro showRouteErrorsPostUnrouted milkRun>
    <#if (milkRun.getRouteData().getUniqueRouteErrors().getErrors()?size > 0) >
        <div class="row">
            <div class="col-sm-12 well"  style="background-color: #f90000">
                <#list milkRun.getRouteData().getRouteErrors().getErrors() as error >
                    <span style="color: #000000">
                        <#if error.getType().toString() == "DidNotPickFor" >
                            <#local addr = error.getUser().getAddress("Delivery") >
                            ${String.format("Route does not pick for user %s (%8.8s...)",
                                addr.getName(),
                                addr.getUserId())}
                        </#if>
                        <#if error.getType().toString() == "DidNotDropTo" >
                            <#local addr = error.getUser().getAddress("Delivery") >
                            ${String.format("Route does not drop to user %s (%8.8s...)",
                                addr.getName(),
                                addr.getUserId())}
                        </#if>
                        <#if error.getType().toString() == "InvalidStopGeoLocation" >
                            <#local addr = error.getStop().getAddress() >
                            ${String.format("Can not make stop, %s address of user %s (%8.8s...) has an invalid geolocation",
                                addr.getUsage().toString(),
                                addr.getName(),
                                addr.getUserId())}
                        </#if>
                        <#if error.getType().toString() == "InvalidExtraStopGeoLocation" >
                            <#local addr = error.getStop().getAddress() >
                            ${String.format("Can not make extra stop, %s address of user %s (%8.8s...) has an invalid geolocation",
                                addr.getUsage().toString(),
                                addr.getName(),
                                addr.getUserId())}
                        </#if>
                        <#if error.getType().toString() == "AddressNotCurrent" >
                            <#local addr = error.getStop().getAddress() >
                            ${String.format("Route extra stop at %s, %s (%8.8s...) address is not current. Usage %s",
                                User.findById(error.getAddress().getUserId()).getName(),
                                addr.getStreetAddress(),
                                addr.getId(),
                                addr.getUsage().toString())}
                        </#if>
                        <#if error.getType().toString() == "DeadStop" >
                            <#local user = User.findById(error.getStop().getAddress().getUserId()) >
                            ${String.format("Route stops at old address of user %s (%8.8s...) but does not pick or drop.",
                                user.getName(),
                                user.getId())}
                        </#if>
                        <#if error.getType().toString() == "MissingExtraStop" >
                            <a href="/extra-stops/edit?milkRunId=${milkRun.getId()}">
                                <#local extraStop = error.getExtraStop() >
                                <#if extraStop.getStopUser()?? >
                                    ${String.format("Extra stop at %s, %s (%8.8s...) is not in the route. Usage %s",
                                    extraStop.getAddress().getStreetAddress(),
                                    extraStop.getStopUser().getName(),
                                    extraStop.getStopUser().getId(),
                                    extraStop.getAddress().getUsage().toString())}
                                <#else>
                                    ${String.format("Extra stop at %s, is not in the route. Usage %s",
                                    extraStop.getAddress().getStreetAddress(),
                                    extraStop.getAddress().getUsage().toString())}
                                </#if>
                            </a>
                        </#if>
                    </span>
                    <br>
                </#list>
            </div>
        </div>
    </#if>
</#macro>
