<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <title>MilkRun Routing Test2</title>
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
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="/admin"><strong>Admin Home</strong></a>
        </td>
        <td width="50%">
            <h2>MilkRun Routing Adjuster v2</h2>
            MilkRun <strong>${state.getMilkRun().getId()}</strong>
        </td>
    </tr>
</table>
<br>

<table>
    <tr>
        <th width="600px">
            <#if error?? >
                <span style="background-color:#ffaaaa">${error}</span>
            <#else>
            </#if>

            <button onclick="exit()">Abandon</button>
            &nbsp;
            <button onclick="freezeRun()">Freeze</button>
            &nbsp;
            ${state.getMilkRun().getRoute().getLengthKm()}
        </th>
        <th width="75px">
            History
        </th>
        <th width="400px">
            <button onclick="swap()">Swap Two Stops</button>
            <button onclick="insertAfter()">Insert After Last</button>
        </th>
    </tr>
    <tr>
        <td >
            <div id="map" style="width:600px; height:600px"></div>
        </td>
        <td>
            <#list state.getHistory() as ordering >
                <a href="/milkrun-routing/load/${ordering.getId()}">${ordering.getLength()}</a>
                <br>
            </#list>
        </td>
        <td>
            <div style="overflow: auto">
                <table width="100%">
                    <th  width="10%"></th>
                    <th width="25%"></th>
                    <th width="15%" class="td-right">Km</th>
                    <th width="15%" class="td-right">Time</th>
                    <th width="10%" class="td-right">Dwell</th>
                    <th width="10%" class="td-right">Samples</th>
                    <th width="10%" class="td-right">Ratio</th>
                    <#list state.getMilkRun().route.stops as stop >
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
                                <#if ! stop?is_first >
                                    ${Metrics.numSamples(prevStop, stop)}
                                </#if>
                            </td>
                            <td class="td-right">
                                <#if ! stop?is_first >
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

<script>
    function freezeRun() {
        location.assign("/milkrun-routing/do/freeze");
    }
    function exit() {
        location.assign("/milkrun-routing/do/exit");
    }
    function back() {
        location.assign("/milkrun-routing/do/back");
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
        location.assign("/milkrun-routing/do/swap?ids=" + checkedStops);
    }
    function insertAfter() {
        location.assign("/milkrun-routing/do/insertAfter?ids=" + checkedStops);
    }

</script>

<script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBxzR8TEdR9Ssp_-saKp5OPOd4caoVKqaE&callback=initMap"></script>
<script>
    var markers = [];
    var stops = [
        <#list state.getMilkRun().getRoute().getStops() as stop>
            {   lat: ${stop.getLocation().latitude},
                lng: ${stop.getLocation().longitude}}
            <#if stop?has_next >,
            </#if>
        </#list>
    ];

    function initMap() {
        var locations = [
            <#list state.getMarkers() as marker>
                {   lat: ${String.format("%.6f", marker.lat)},
                    lng: ${String.format("%.6f", marker.lng)},
                    label: "${marker.label}",
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
            zoom: ${state.getZoom()},
            center: { lat: ${state.getCenter().latitude}, lng: ${state.getCenter().longitude} }
        });

        <#if state.getMapLines() == true >
            flightPath.setMap(map);
        </#if>

        var i;
        for (i = 0; i < locations.length; i++) {
            markers[i] = new google.maps.Marker({
                position: locations[i],
                map: map,
                title: locations[i].label,

                icon: 'http://maps.gstatic.com/mapfiles/ridefinder-images/' + locations[i].color + '.png',
                url: locations[i].url
            });

            google.maps.event.addListener(markers[i], 'click', function() {
                window.location.href = this.url;
            });
        }

        map.addListener('zoom_changed', function() {
            var zoom = map.getZoom());
        });

    }
</script>

</body>
</html>