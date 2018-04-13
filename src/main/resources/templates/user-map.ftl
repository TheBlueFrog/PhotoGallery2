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
          <#if centerIndex?? >
              center: locations[${centerIndex}]
          <#else>
              center: { lat: ${centerLat}, lng: ${centerLng} }
          </#if>
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
//              icon: 'http://maps.google.com/mapfiles/ms/icons/' + locations[i].color + '-dot.png',
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
</body>
</html>