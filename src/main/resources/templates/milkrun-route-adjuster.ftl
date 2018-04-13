<!DOCTYPE html>
<#include "macros.ftl">
<#include "macros-milkrun.ftl">

<#macro showRouteErrors milkRun >
    <#list milkRun.getRouteData().getRouteErrors().getErrors() as error >
        <span style="background-color: lightpink; color: lightpink" >XXX</span>

        <span style="color: #000000">
            <#if error.getType().toString() == "DidNotPickFor" >
                ${String.format("Route does not pick for user %s (%8.8s...)",
                error.getUser().getAddress().getName(),
                error.getUser().getAddress().getUserId())}
            </#if>
            <#if error.getType().toString() == "DidNotDropTo" >
                ${String.format("Route does not drop to user %s (%8.8s...)",
                error.getUser().getAddress().getName(),
                error.getUser().getAddress().getUserId())}
            </#if>
            <#if error.getType().toString() == "InvalidStopGeoLocation" >
                ${String.format("Can not make stop, %s address of user %s (%8.8s...) has an invalid geolocation",
                error.getAddress().getUsage().toString(),
                error.getAddress().getName(),
                error.getAddress().getUserId())}
            </#if>
            <#if error.getType().toString() == "InvalidExtraStopGeoLocation" >
                ${String.format("Can not make extra stop, %s address of user %s (%8.8s...) has an invalid geolocation",
                error.getAddress().getUsage().toString(),
                error.getAddress().getName(),
                error.getAddress().getUserId())}
            </#if>
            <#if error.getType().toString() == "AddressNotCurrent" >
                ${String.format("Route extra stop at %s, %s (%8.8s...) address is not current. Usage %s",
                User.findById(error.getAddress().getUserId()).getName(),
                error.getAddress().getStreetAddress(),
                error.getAddress().getId(),
                error.getAddress().getUsage().toString())}
            </#if>
            <#if error.getType().toString() == "DeadStop" >
                ${String.format("Route stops at %s (%8.8s...) of user %s (%8.8s...) but does not pick or drop.",
                error.getAddress().getStreetAddress(),
                error.getAddress().getId(),
                error.getAddress().getName(),
                error.getAddress().getUserId())}
            </#if>
            <#if error.getType().toString() == "MissingExtraStop" >
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
            </#if>
        </span>
        <br>
    </#list>
</#macro>

<html>
<head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <title>MilkRun Routing Test</title>
    <style>
      /* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
      /* Optional: 100% Makes the sample page fill the window. */
      html, body {
        margin: 10px;
        padding: 10px;
      }
        th { text-align: left; }
        td {
            margin: 0px;
            padding: 0px;
            text-align: left;
            vertical-align: top;
        }
        .td-right {
            margin: 0px;
            padding: 0px;
            text-align: right;
            vertical-align: top;
        }
        .mine {
            color: #FFFFFF;
            background-color: #8888FF
        }
    </style>
</head>
<body>

<table width="100%">
    <tr>
        <td width = "20%">
        </td>
        <td width="50%">
            <h2>MilkRun Route Adjuster</h2>
            MilkRun <strong>${pageState.getMilkRun().getName()}
                ${String.format("(%8.8s...)", pageState.getMilkRun().getId())}</strong>
        </td>
    </tr>
</table>
<br>

<table>
    <tr>
        <th width="100%">
            <button onclick="exit()">
                <span data-toggle="tooltip" title="Abandon editing of this route and discard all changes">
                    Abandon & Exit</span></button>
            &nbsp;
            <button onclick="freezeRun()">
                <#if ! pageState.getMilkRun().getRouteData().hasRouteErrors() >
                    <span data-toggle="tooltip" title="Save the current route and exit">
                        Save & Exit</span></button>
                </#if>
            &nbsp;
            <#--
            the code is pretty broken if you do this bad things happen
            <button onclick="discardFrozen()">
                <span data-toggle="tooltip" title="Discard any frozen route">Discard Frozen</span></button>
            &nbsp;
            -->
            Length ${String.format("%.1fkm", pageState.getMilkRun().getRouteData().getMetrics().getLengthMeters() / 1000)}
            &nbsp;
            Time ${Util.formatTime(pageState.getMilkRun().getRouteData().getMetrics().getLengthMs(), "HH:mm")} (travel + dwell)
        </th>
    </tr>
</table>
<p></p>
<table>
    <tr>
        <td width="25%"></td>
        </td>
        <td width="75%"></td>
            <@showRouteErrors pageState.getMilkRun() />
        </td>
    </tr>
</table>
<p></p>
<table>
    <tr>
        <td width="600px"></td>
        <td  width="75px">
            <span data-toggle="tooltip"
title="Successive routes in order they were built.
Selecting one will reload that version.">History</span>
        </td>
        <td width="450px" >
            <button onclick="swap()">
                <span data-toggle="tooltip" title="Only swap the first 2 checked stops">Swap Two Stops</span></button>
            <button onclick="insertAfter()">
                <span data-toggle="tooltip" title="Insert all checked stops after the last checked stop.
Stops are inserted in the order checked.">Insert After Last</button>
            <button onclick="optimize()">
                <span data-toggle="tooltip" title="Run the optimizer on current route.">Optimize</button>
        </td>
    </tr>
</table>
<p></p>
<table>
    <tr>
        <td  width="600px" >
            <div id="map" style="width:600px; height:600px"></div>
        </td>
        <td width="75px" >
            <#list pageState.getHistory() as ordering >
                <button onclick="load('${ordering.getId()}')"
                    <#if (ordering.getErrors().hasErrors()) >
                        style="background-color: #ff7777"
                    </#if>
                >
                    <#if pageState.isCurrent(ordering) >
                        **
                    <#else >
                        &nbsp;&nbsp;
                    </#if>
                    ${ordering.getMetrics().getKmString()}
                </button>
                <br>
            </#list>
        </td>
        <td width=450px" >
            <div style="overflow: auto">
                <table width="100%">
                    <th  width="10%"></th>
                    <th width="30%"></th>
                    <th width="15%" class="td-right">
                        <span data-toggle="tooltip"
                              title="Crow-flies distance in Km">Geo Km</span></th>
                    </th>
                    <th width="15%" class="td-right">
                        <span data-toggle="tooltip"
                              title="Estimated travel time HH:MM">Drive</span></th>
                    <th width="15%" class="td-right">
                        <span data-toggle="tooltip"
                              title="Avg. measured unload time HH:MM">Dwell</span></th>
                    <th width="15%" class="td-right">
                        <span data-toggle="tooltip"
                              title="(Avg measured travel time) / (30k/h travel time)
Blank = no measured travel time.
Values greater than 1.0 are slower than 30k/h
Values less than 1.0 are faster than 30k/h">Ratio</span></th>
                    <#list pageState.getMilkRun().getRouteData().getStops() as stop >
                        <tr>
                            <td>
                                <input type="checkbox" onchange="checkChanged(this, ${stop.getNumber()})"/>
                                ${stop.getNumber()}
                            </td>
                            <td>
                                <#assign stopUser = User.findByUsername(stop.getAddress().getUserId()) >
                                <#if stop.isDelivery() >
                                    ${stop.getNamesDots()}
                                <#else>
                                    <#if stop.isPickup() >
                                        <i>
                                            ${stop.getCompanyNamesDots()}
                                        </i>
                                    <#else>
                                        <!-- a plain stop -->
                                             ${stop.getNamesDots()}
                                    </#if>
                                </#if>
                            </td>
                            <td class="td-right">
                                <#if ! stop?is_first >
                                    ${String.format("%.1f",
                                    (Metrics.distance(prevStop, stop) / 1000))
                                    }
                                </#if>
                            </td>
                            <td class="td-right">
                                <#if ! stop?is_first >
                                    ${Util.formatTime(Metrics.travelTimeMs(prevStop, stop), "HH:mm")}
                                </#if>
                            </td>
                            <td class="td-right">
                                ${Util.formatTime(Metrics.stopDwellTimeMs(stop), "HH:mm")}
                            </td>
                            <td class="td-right">
                                <#if ( ! stop?is_first) && (Metrics.getTravelTimeFraction(prevStop, stop) != 1.0) >
                                    ${String.format("%.1f", Metrics.getTravelTimeFraction(prevStop, stop))}
                                </#if>
                            </td>
                        </tr>
                        <#assign prevStop = stop >
                    </#list>
                </table>
            </div>
        </td>
    </tr>
</table>

<script
        src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script>

    function load(id) {
        var url = "/milkrun-api2/milkrun-routing/adjust?op=load&orderingId=" + id;
        $.get(url, function(data, status) {
            if (status == "success") {
                location.assign("/milkrun-routing");
            }
        });
    }
    function freezeRun() {
        var url = "/milkrun-api2/milkrun-routing/adjust?op=routed";
        $.get(url, function(data, status) {
            if (status == "success") {
                location.assign("/admin");
            }
        });
    }
    function exit() {
        var url = "/milkrun-api2/milkrun-routing/adjust?op=exit";
        $.get(url, function(data, status) {
            if (status == "success") {
                location.assign("/admin");
            }
        });
    }
    function back() {
        var url = "/milkrun-api2/milkrun-routing/adjust?op=back";
        $.get(url, function(data, status) {
            if (status == "success") {
                location.assign("/milkrun-routing");
            }
        });
    }

    var checkedStops = [];
    function checkChanged(check, id) {
        var x = check.checked;
        var i = checkedStops.indexOf(id);
        if (x) {
            if (i < 0) {
                checkedStops.push(id);
            }
        }
        else {
            if (i > -1) {
                checkedStops.splice(i, 1);
            }
        }
    }
    function swap() {
        var url = "/milkrun-api2/milkrun-routing/adjust?op=swap&ids=" + checkedStops;
        $.get(url, function(data, status) {
            if (status == "success") {
                location.assign("/milkrun-routing");
            }
        });
    }
    function insertAfter() {
        var url = "/milkrun-api2/milkrun-routing/adjust?op=insertAfter&ids=" + checkedStops;
        $.get(url, function(data, status) {
            if (status == "success") {
                location.assign("/milkrun-routing");
            }
            else {

            }
        });
    }
    function discardFrozen() {
        var url = "/milkrun-api2/milkrun-routing/adjust?op=discardFrozen";
        $.get(url, function(data, status) {
            if (status == "success") {
                location.assign("/milkrun-routing");
            }
        });
    }
    function optimize() {
        var url = "/milkrun-api2/milkrun-routing/adjust?op=optimize";
        $.get(url, function(data, status) {
            if (status == "success") {
                location.assign("/milkrun-routing");
            }
        });
    }
</script>

<script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBxzR8TEdR9Ssp_-saKp5OPOd4caoVKqaE&callback=initMap"></script>
<script>
    var markers = [];
    var stops = [
        <#list pageState.getMilkRun().getRouteData().getStops() as stop>
            {   lat: ${String.format("%.6f", stop.getLocation().latitude)},
                lng: ${String.format("%.6f", stop.getLocation().longitude)}}
            <#if stop?has_next >,
            </#if>
        </#list>
    ];

    function initMap() {
        var locations = [
            <#list pageState.getMarkers() as marker>
                {   lat: ${String.format("%.6f", marker.lat)},
                    lng: ${String.format("%.6f", marker.lng)},
                    title: "${marker.getTitle()}",
                    label: "${marker.getLabel()}",
                    color: "${marker.color}",
                    url: "${marker.url}"}
                <#if marker?has_next >,
                </#if>
            </#list>
        ];

        var flightPath = new google.maps.Polyline({
            path: stops,
            geodesic: true,
            strokeColor: '#FF0000',
            strokeOpacity: 1.0,
            strokeWeight: 1
        });

        var map = new google.maps.Map(document.getElementById('map'), {
            zoom: ${pageState.getZoom()},
            center: { lat: ${pageState.getCenter().latitude}, lng: ${pageState.getCenter().longitude} },
            gestureHandling: 'greedy'
        });

        <#if pageState.getMapLines() == true >
            flightPath.setMap(map);
        </#if>

        var i;
        for (i = 0; i < locations.length; i++) {
            markers[i] = new google.maps.Marker({
                position: locations[i],
                map: map,
                title: locations[i].title,
                label: locations[i].label,
//                icon: 'http://maps.gstatic.com/mapfiles/ridefinder-images/' + locations[i].color + '.png',
                url: locations[i].url
            });

            google.maps.event.addListener(markers[i], 'click', function() {
                window.location.href = this.url;
            });
        }

        map.addListener('zoom_changed', function() {
            var zoom = map.getZoom();
            var url = "/milkrun-api2/milkrun-routing/adjust?op=zoom&value=" + zoom;
            $.get(url, function(data, status) {
                if (status == "success") {
                }
            });
        });

        map.addListener('center_changed', function() {
            var center = map.getCenter();
            var url = "/milkrun-api2/milkrun-routing/adjust?op=center&lat=" + center.lat() + "&lng=" + center.lng();
            $.get(url, function(data, status) {
                if (status == "success") {
                }
            });
        });

    }
</script>

</body>
</html>