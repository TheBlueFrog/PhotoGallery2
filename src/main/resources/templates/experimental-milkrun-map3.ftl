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

      var markers = [];

      function initMap() {
        var locationsA = [
            <#list mapLocationsA as marker>
                {   lat: ${String.format("%.6f", marker.lat)},
                    lng: ${String.format("%.6f", marker.lng)},
                    label: "${marker.label}",
                    color: "${marker.color}",
                    url: "${marker.url}"}
                <#if marker?has_next >
                    ,
                </#if>
            </#list>
        ];
        var locationsB = [
            <#list mapLocationsB as marker>
                {   lat: ${String.format("%.6f", marker.lat)},
                    lng: ${String.format("%.6f", marker.lng)},
                    label: "${marker.label}",
                    color: "${marker.color}",
                    url: "${marker.url}"}
                <#if marker?has_next >
                    ,
                </#if>
            </#list>
        ];

        var flightPathA = new google.maps.Polyline({
          path: locationsA,
          geodesic: true,
          strokeColor: '${mapLinesColorA}',
          strokeOpacity: 1.0,
          strokeWeight: 2
        });
        var flightPathB = new google.maps.Polyline({
          path: locationsB,
          geodesic: true,
          strokeColor: '${mapLinesColorB}',
          strokeOpacity: 1.0,
          strokeWeight: 2
        });

        var map = new google.maps.Map(document.getElementById('map'), {
          zoom: ${zoom},
          center: { lat: ${centerLat}, lng: ${centerLng} }
        });

        <#if mapLines == true >
            flightPathA.setMap(map);
            flightPathB.setMap(map);
        </#if>

        var i;
        <#if mapMarkers == true >
            for (i = 0; i < locationsA.length; i++) {
                markers[i] = new google.maps.Marker({
                  position: locationsA[i],
                  map: map,
                  title: locationsA[i].label,

                  icon: 'http://maps.gstatic.com/mapfiles/ridefinder-images/' + locationsA[i].color + '.png',
                  //icon: 'http://maps.google.com/mapfiles/ms/icons/' + locationsA[i].color + '-dot.png',
                  url: locationsA[i].url
                });

                google.maps.event.addListener(markers[i], 'click', function() {
                    window.location.href = this.url;
                });
            }
            for (i = 0; i < locationsB.length; i++) {
                markers[i] = new google.maps.Marker({
                  position: locationsB[i],
                  map: map,
                  title: locationsB[i].label,

                  icon: 'http://maps.gstatic.com/mapfiles/ridefinder-images/' + locationsB[i].color + '.png',
                  //icon: 'http://maps.google.com/mapfiles/ms/icons/' + locationsB[i].color + '-dot.png',
                  url: locationsB[i].url
                });

                google.maps.event.addListener(markers[i], 'click', function() {
                    window.location.href = this.url;
                });
            }
        </#if>
      }
    </script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>

<script>

$(document).ready(function(){
    $("#getEpsilon").click(function(){
        $("#epsilon").load("/milkrun-api/experimental-milkrun-map3/get/epsilon");
    });
});

</script>

<script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBxzR8TEdR9Ssp_-saKp5OPOd4caoVKqaE&callback=initMap">
</script>

<strong> Another tool to play with splitting a MilkRun into sub-MilkRuns.</strong>
<table>
    <tr>
        <th width="500px"></th>
        <th width="15px"></th>
        <th width="500px"></th>
    </tr>
    <tr>
        <td width="500px" margin="20px">
            <p>
                The data is from a particular MilkRun (344b8437 from 3/16/17) has 16 Eaters, 119 CartOffers and 150
                individual items.
            </p>
            <p>
                Markers in white are eaters that are not part of any group.  Other colors are just to
                identify different groups.
            </p>
            <p>
                Partioning eaters into clusters doesn't help with partitioning seeders since
                it's blind to the seeders.
            </p>
            <p>
                It is possible that clustering eaters is valuable since it minimizes the time
                spent on retail deliveries.  This probably comes at the expense of additional
                pickups.  Maybe we need a 3rd dimension that encodes the supplier cost.
            </p>
        </td>
        <td width="15px"></td>
        <td width="500px">
            <p>
                The <strong>epsilon</strong> control determines the maximum distance
                between two eaters for them to be part of the same group.  The units
                are uncalibrated.  A value of 0.075 seems useful.
            </p>
        </td>
    </tr>
</table>
<p>
</p>
<table>
    <tr>
        <th width="500px"></th>
        <th width="300px">Controls</th>
        <th width="300px"></th>
    </tr>
    <tr>
        <td >
            <div id="map" style="width:500px; height:500px"></div>
        </td>
        <td>
            <div id="epsilon">xxxx</div>
            <button id="getEpsilon">Get Epsilon</button>
            <p></p>
            epsilon ${controller.epsilonAsString}
            <br>
            <a href="/experimental-milkrun-map3/epsilon/bigger">More</a>
            <br>
            <a href="/experimental-milkrun-map3/epsilon/smaller">Less</a>
            <br>
            <a href="/experimental-milkrun-map3/epsilon/lotBigger">Lot more</a>
            <br>
            <a href="/experimental-milkrun-map3/epsilon/lotSmaller">Lot less</a>
        </td>
        <td>
        </td>
    </tr>
    <tr>
        <td>
        </td>
        <td>
        </td>
        <td>
        </td>
    </tr>
</table>
</body>
</html>
