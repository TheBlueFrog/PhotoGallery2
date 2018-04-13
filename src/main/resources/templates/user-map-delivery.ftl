<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <title>${system.site.Company} Users</title>
    <style>
      /* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
      #map {
        height: 100%;
      }
      /* Optional: 100% Makes the sample page fill the window. */
      html, body {
        height: 600px;
        width: 600px;
        margin: 0;
        padding: 0;
      }
    </style>
</head>
<body>
<div id="map"></div>
<script>

      var markers = [];
      var infowindows = [];

      function initMap() {
        var locations = [
            <#list mapMarkers as marker>
                {   lat: ${String.format("%.6f", marker.lat)},
                    lng: ${String.format("%.6f", marker.lng)},
                    title: "${marker.title}",
                    color: "${marker.color}",
                    content: '${marker.content}'
                    }
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

        var map = new google.maps.Map(document.getElementById('map'), {
          zoom: 11,
          center: locations[${centerIndex}]
        });

        var i;
        for (i = 0; i < locations.length; i++) {

            infowindows[i] = new google.maps.InfoWindow({
              content: locations[i].content,
              maxWidth: 300
            });

            var marker = new google.maps.Marker({
              index: i,
              position: locations[i],
              map: map,
              title: locations[i].label,
              icon: 'http://maps.gstatic.com/mapfiles/ridefinder-images/' + locations[i].color + '.png',
//              icon: 'http://maps.google.com/mapfiles/ms/icons/' + locations[i].color + '-dot.png',
//              url: locations[i].url
            });

            markers[i] = marker;

            marker.addListener('click', function () {
                infowindows[this.index].open(map, this);
            });
        }
      }
    </script>
<script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBxzR8TEdR9Ssp_-saKp5OPOd4caoVKqaE&callback=initMap">
</script>
<p>Click on a marker to launch Google Maps with a route from
the current stop (Red marker) to the target marker.</p>
<table>
    <tr>
        <th>Color</th>
        <th>Meaning</th>
    </tr>
    <tr>
        <td>Red</td>
        <td>Current Stop</td>
    </tr>
    <tr>
        <td>Green</td>
        <td>Picks</td>
    </tr>
    <tr>
        <td>Blue</td>
        <td>Drops</td>
    </tr>
</table>
</body>
</html>