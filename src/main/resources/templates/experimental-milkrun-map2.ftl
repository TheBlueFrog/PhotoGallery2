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
        var locations = [
            <#list mapMarkers as marker>
                {   lat: ${String.format("%.6f", marker.lat)},
                    lng: ${String.format("%.6f", marker.lng)},
                    label: "${marker.label}",
                    color: "${marker.color}",
                    url: "${marker.url}"}
                <#if marker?has_next >,
                </#if>
            </#list>
        ];

        var flightPlanCoordinates = [
          {lat: 37.772, lng: -122.214},
          {lat: 21.291, lng: -157.821},
          {lat: -18.142, lng: 178.431},
          {lat: -27.467, lng: 153.027}
        ];

        var flightPath = new google.maps.Polyline({
          path: locations,
          geodesic: true,
          strokeColor: '#FF0000',
          strokeOpacity: 1.0,
          strokeWeight: 2
        });

        var map = new google.maps.Map(document.getElementById('map'), {
          zoom: ${zoom},
          center: { lat: ${centerLat}, lng: ${centerLng} }
        });

        <#if mapLines == true >
            flightPath.setMap(map);
        </#if>

        var i;
        for (i = 0; i < locations.length; i++) {
            markers[i] = new google.maps.Marker({
              position: locations[i],
              map: map,
              title: locations[i].label,

              icon: 'http://maps.gstatic.com/mapfiles/ridefinder-images/' + locations[i].color + '.png',
              //icon: 'http://maps.google.com/mapfiles/ms/icons/' + locations[i].color + '-dot.png',
              url: locations[i].url
            });

            google.maps.event.addListener(markers[i], 'click', function() {
                window.location.href = this.url;
            });
        }
      }
    </script>
<script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBxzR8TEdR9Ssp_-saKp5OPOd4caoVKqaE&callback=initMap">
</script>

<strong> A tool to play with splitting a set of CartOffers between two MilkRuns.</strong>
<table>
    <tr>
        <th width="500px"></th>
        <th width="15px"></th>
        <th width="500px"></th>
    </tr>
    <tr>
        <td width="500px" margin="20px">
            We focus on CartOffers because a single seeder supplies
            many eaters, hence it is not likely that a given large MilkRun can
            be split into two runs such that no seeder is visited by both runs and no
            eater is visited by both runs.
            So attacking the problem from the seeder or eater side is not likely to
            be useful.
            <p>
            This particular MilkRun (344b8437 from 3/16/17) has 119 CartOffers and 150
            individual items.
        </td>
        <td width="15px"></td>
        <td width="500px">
            Recognizing that there is going to be some duplication of stops at seeders and or eaters after
            splitting the run; we allow you to assign CartOffers to either run A or run B.
            <p>
                At the bottom on the page is the current length of the each run.
            </p>
        </td>
    </tr>
</table>
<p>
</p>
<table>
    <tr>
        <th width="300px"></th>
        <th width="400px">A MilkRun</th>
        <th width="400px">Unassigned</th>
        <th width="400px">B MilkRun</th>
    </tr>
    <tr>
        <td >
            <div id="map" style="width:300px; height:300px"></div></td>

        <td>
            <div style="width: 400px; height: 600px; overflow: auto">
                <#list aCartOffers as cartOffer >
                    ${cartOffer.seller.username} -> ${cartOffer.buyer.username}
                    <a href="/experimental-milkrun-map2/a/moveU/${cartOffer?index}">U</a>
                    <br>
                </#list>
            </div>
        </td>

        <td>
            <div style="width: 400px; height: 600px; overflow: auto">
                <#list unassigned as cartOffer >
                    <a href="/experimental-milkrun-map2/moveA/${cartOffer?index}">A</a>
                    ${cartOffer.seller.username} -> ${cartOffer.buyer.username}
                    <a href="/experimental-milkrun-map2/moveB/${cartOffer?index}">B</a>
                    <br>
                </#list>
            </div>
        </td>

        <td>
            <div style="width: 400px; height: 600px; overflow: auto">
                <#list bCartOffers as cartOffer >
                    <a href="/experimental-milkrun-map2/b/moveU/${cartOffer?index}">U</a>
                    ${cartOffer.seller.username} -> ${cartOffer.buyer.username}
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
        </td>
        <td>
            B length ${bMilkRun.route.lengthKm} km
        </td>
    </tr>
</table>
</body>
</html>