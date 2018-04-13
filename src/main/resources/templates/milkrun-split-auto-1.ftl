<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <title>${system.site.Company} Users</title>
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
            text-align: left;
    vertical-align: top;
        }
        .mine {
            color: #FFFFFF;
            background-color: #8888FF
        }
    </style>
</head>
<body>
<script>

      var aMarkers = [];
      var bMarkers = [];

      function initMap() {
        var aLocations = [
            <#list aMapMarkers as marker>
                {   lat: ${String.format("%.6f", marker.lat)},
                    lng: ${String.format("%.6f", marker.lng)},
                    label: "${marker.label}",
                    color: "${marker.color}",
                    url: "${marker.url}"}
                <#if marker?has_next >,
                </#if>
            </#list>
        ];
        var bLocations = [
            <#list bMapMarkers as marker>
                {   lat: ${String.format("%.6f", marker.lat)},
                    lng: ${String.format("%.6f", marker.lng)},
                    label: "${marker.label}",
                    color: "${marker.color}",
                    url: "${marker.url}"}
                <#if marker?has_next >,
                </#if>
            </#list>
        ];

        var aFlightPath = new google.maps.Polyline({
          path: aLocations,
          geodesic: true,
          strokeColor: '#0000FF',
          strokeOpacity: 1.0,
          strokeWeight: 1
        });
        var bFlightPath = new google.maps.Polyline({
          path: bLocations,
          geodesic: true,
          strokeColor: '#FF0000',
          strokeOpacity: 1.0,
          strokeWeight: 1
        });

        var map = new google.maps.Map(document.getElementById('map'), {
          zoom: ${zoom},
          center: { lat: ${centerLat}, lng: ${centerLng} }
        });

        <#if mapLines == true >
            aFlightPath.setMap(map);
            bFlightPath.setMap(map);
        </#if>

        var i;
        for (i = 0; i < aLocations.length; i++) {
            aMarkers[i] = new google.maps.Marker({
              position: aLocations[i],
              map: map,
              title: aLocations[i].label,

              icon: 'http://maps.gstatic.com/mapfiles/ridefinder-images/' + aLocations[i].color + '.png',
              url: aLocations[i].url
            });

            google.maps.event.addListener(aMarkers[i], 'click', function() {
                window.location.href = this.url;
            });
        }
        for (i = 0; i < bLocations.length; i++) {
            bMarkers[i] = new google.maps.Marker({
              position: bLocations[i],
              map: map,
              title: bLocations[i].label,

              icon: 'http://maps.gstatic.com/mapfiles/ridefinder-images/' + bLocations[i].color + '.png',
              url: bLocations[i].url
            });

            google.maps.event.addListener(bMarkers[i], 'click', function() {
                window.location.href = this.url;
            });
        }
      }
    </script>
<script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBxzR8TEdR9Ssp_-saKp5OPOd4caoVKqaE&callback=initMap">
</script>

<strong> A tool for splitting a MilkRuns into two MilkRuns</strong>
<table>
    <tr>
        <th width="500px"></th>
        <th width="15px"></th>
        <th width="500px"></th>
    </tr>
    <tr>
        <td width="500px" margin="20px">
            Automatic partitioning of a MilkRun into two approximately
            equal runs.
        </td>
        <td width="15px"></td>
        <td width="500px">
            Red markers are stops only in Red run
            <br>
            Blue markers are stops only in Blue run
            <br>
            Yellow markers are stops in both Red and Blue runs
            <p>
                At the bottom on the page is the current length of the each run.
            </p>
            <#if session.user.doesRole("ClosedPhaseAdmin") >
                <a href="/milkrun-split-auto-1/finish"><strong>Split MilkRun</strong></a>
            </#if>
        </td>
    </tr>
</table>
<p>
</p>
<table>
    <tr>
        <th width="600px"></th>
        <th width="250px">Blue MilkRun</th>
        <th width="250px">Red MilkRun</th>
    </tr>
    <tr>
        <td >
            <div id="map" style="width:600px; height:600px"></div></td>

        <td>
            <div style="overflow: auto">
                <#list aMilkRun.route.stops as stop >
                    ${stop.kind}
                    &nbsp;
                    <#if stop.companyName == "" >
                        ${stop.name}
                    <#else>
                        ${stop.companyName}
                    </#if>
                    <br>
                </#list>
            </div>
        </td>

        <td>
            <div style="overflow: auto">
                <#list bMilkRun.route.stops as stop >
                    ${stop.kind}
                    &nbsp;
                    <#if stop.companyName == "" >
                        ${stop.name}
                        <#else>
                            ${stop.companyName}
                    </#if>
                    <br>
                </#list>
            </div>
        </td>
    </tr>
    <tr>
        <td>
        </td>
        <td>
            A length ${aMilkRun.route.lengthKm} km
        </td>
        <td>
            B length ${bMilkRun.route.lengthKm} km
        </td>
    </tr>
</table>
</body>
</html>