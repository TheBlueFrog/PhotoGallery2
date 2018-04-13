<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <title>Manual MilkRun Carving</title>
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
<script
        src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js">
</script>
<script>

      var markers = [];
      var aStops = [
            <#list aStops as marker>
                {   lat: ${String.format("%.6f", marker.latitude)},
                    lng: ${String.format("%.6f", marker.longitude)}}
                <#if marker?has_next >,
                </#if>
            </#list>
      ];
      var bStops = [
            <#list bStops as marker>
                {   lat: ${String.format("%.6f", marker.latitude)},
                    lng: ${String.format("%.6f", marker.longitude)}}
                <#if marker?has_next >,
                </#if>
            </#list>
      ];

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

        var aFlightPath = new google.maps.Polyline({
          path: aStops,
          geodesic: true,
          strokeColor: '#FF0000',
          strokeOpacity: 1.0,
          strokeWeight: 1
        });

        var bFlightPath = new google.maps.Polyline({
          path: bStops,
          geodesic: true,
          strokeColor: '#0000FF',
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

            map.addListener('zoom_changed', function() {
                var zoom = map.getZoom();
                var url = "/milkrun-api2/milkrun-split/set?op=zoom&value=" + zoom;
                $.get(url, function(data, status) {
                    if (status == "success") {
                    }
                });
            });

            map.addListener('center_changed', function() {
                var center = map.getCenter();
                var url = "/milkrun-api2/milkrun-split/set?op=center&lat=" + center.lat() + "&lng=" + center.lng();
                $.get(url, function(data, status) {
                    if (status == "success") {
                    }
                });
            });
        }
      }
    </script>
<script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBxzR8TEdR9Ssp_-saKp5OPOd4caoVKqaE&callback=initMap">
</script>

<table width="100%">
    <tr>
        <td width = 20%">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="/admin"><strong>Admin</strong></a>
        </td>
        <td width="50%">
            <h2>Manually split a MilkRun</h2>
            MilkRun <strong>${controller.getState().getRealMilkRun().getId()}</strong>
        </td>
    </tr>
</table>
<br>
Leaving this page without Commiting or Abandoning the split will retain your work
<br> (unless the brownser session ends).  To return view the MilkRun being split
<br> in the Admin Closed MilkRuns.
<p>
<table width="100%">
    <tr>
        <td width="30%">
            Commit the split of the MilkRun as it now is.
            <br>
            It is possible to unsplit a Split parent.
            <br>
            <a href="/milkrun-split-manual-by-eater3/finish"><strong>Commit</strong></a>
        </td>
        <td width="30%">
            Abandon this editing.  No changes will be made to the database.
            <br>
            <a href="/milkrun-split-manual-by-eater3/abandon"><strong>Abandon</strong></a>
        </td>
        <td width="30%">
        </td>
    </tr>
    <tr>
        <td></td>
        <td></td>
        <td>
            <button onclick="moveEm(this)">Move Selected</button>
        </td>
    </tr>
</table>

<table>
    <tr>
        <th width="600px"></th>
        <th width="250px">
            Red MilkRun
        </th>
        <th width="250px">
            Blue MilkRun
        </th>
    </tr>
    <tr>
        <td >
            <div id="map" style="width:600px; height:600px"></div></td>
        <td>
            <div style="overflow: auto">
                Start ${aMilkRun.getStart().getName()}
                <#--
                <select id="startSelectA" onchange="startAChanged()">
                    <#assign startUser = aMilkRun.getStart().getUsername() >
                        <#list system.getUsersByRoles("Admin") as u >
                            <option value="${u.getUsername()}"
                            <#if startUser == u.getUsername() >
                                selected
                            </#if>
                            >${u.getName()}</option>
                        </#list>
                </select>
                <p></p>
                -->
                <br>
                End ${aMilkRun.getEnd().getName()}
                <#--
                <select id="endSelectA" onchange="endAChanged()">
                    <#assign endUser = aMilkRun.getEnd().getUsername() >
                        <#list system.getUsersByRoles("Admin") as u >
                            <option value="${u.getUsername()}"
                            <#if endUser == u.getUsername() >
                                selected
                            </#if>
                            >${u.getName()}</option>
                        </#list>
                </select>
                -->
                <p></p>
                <table>
                    <#list aMilkRun.getRouteData().getStops() as stop >
                        <#assign stopUser = User.findById(stop.getAddress().getUserId()) >
                        <#if stop.isDelivery() >
                            <tr>
                                <td width="20px">
                                    <input type="checkbox" id="${stopUser.getId()}"
                                           value="${stopUser.getId()}"
                                           onchange="checkedStopA(this)"/>
                                </td>
                                <td width="280px">
                                    ${stop.getNamesDots()}
                                </td>
                            </tr>
                        <#else>
                            <#if stop.isPickup() >
                                <tr>
                                    <td width="20px">
                                        &nbsp;
                                    </td>
                                    <td width="280px">
                                        <i>
                                            ${stop.getCompanyNamesDots()}
                                        </i>
                                    </td>
                                </tr>
                            <#else>
                                <!-- a plain stop -->
                                <tr>
                                    <td width="20px">
                                        <input type="checkbox" id="${stopUser.getId()}"
                                               value="${stopUser.getId()}"
                                               onchange="checkedStopA(this)"/>
                                    </td>
                                    <td width="280px">
                                        ${stop.getNamesDots()}
                                    </td>
                                </tr>
                            </#if>
                        </#if>
                    </#list>
                </table>
            </div>
        </td>
        <td>
            <div style="overflow: auto">
                Start ${bMilkRun.getStart().getName()}
                <#--
                <select id="startSelectB" onchange="startBChanged()">
                    <#assign startUser = bMilkRun.getStart().getUsername() >
                        <#list system.getUsersByRoles("Admin") as u >
                            <option value="${u.getUsername()}"
                            <#if startUser == u.getUsername() >
                                selected
                            </#if>
                            >${u.getName()}</option>
                        </#list>
                </select>
                <p></p>
                -->
                <br>
                End ${bMilkRun.getEnd().getName()}
                <#--
                <select id="endSelectB" onchange="endBChanged()">
                    <#assign endUser = bMilkRun.getEnd().getUsername() >
                        <#list system.getUsersByRoles("Admin") as u >
                            <option value="${u.getUsername()}"
                            <#if endUser == u.getUsername() >
                                selected
                            </#if>
                            >${u.getName()}</option>
                        </#list>
                </select>
                -->
                <p></p>
                <table>
                    <#list bMilkRun.getRouteData().getStops() as stop >
                        <#assign stopUser = User.findById(stop.getAddress().getUserId()) >
                        <#if stop.isDelivery() >
                            <tr>
                                <td width="20px">
                                    <input type="checkbox" id="${stopUser.getId()}"
                                           value="${stopUser.getId()}"
                                           onchange="checkedStopB(this)"/>
                                </td>
                                <td width="280px">
                                    ${stop.getNamesDots()}
                                </td>
                            </tr>
                        <#else>
                            <#if stop.isPickup() >
                                <tr>
                                    <td width="20px">
                                        &nbsp;
                                    </td>
                                    <td width="280px">
                                        <i>
                                            ${stop.getCompanyNamesDots()}
                                        </i>
                                    </td>
                                </tr>
                            <#else>
                                <!-- a plain stop -->
                                <tr>
                                    <td width="20px">
                                        <input type="checkbox" id="${stopUser.getId()}"
                                               value="${stopUser.getId()}"
                                               onchange="checkedStopB(this)"/>
                                    </td>
                                    <td width="280px">
                                        ${stop.getNamesDots()}
                                    </td>
                                </tr>
                            </#if>
                        </#if>
                    </#list>
                </table>
            </div>
        </td>
        <td>
        </td>
    </tr>
    <tr>
        <td>
        </td>
        <td>
            Length ${aMilkRun.getRouteData().getMetrics().getKmString()}
        </td>
        <td>
            Length ${bMilkRun.getRouteData().getMetrics().getKmString()}
        </td>
    </tr>
</table>
<table>
    <tr>
        <th width="500px"></th>
        <th width="15px"></th>
        <th width="500px"></th>
    </tr>
    <tr>
        <td width="500px" margin="20px">
            <p>
                The original MilkRun, ${controller.getState().getRealMilkRun().getShortId()}, is the left column.
                Clicking a Red run eater marker will re-assign the eater to
                the Blue run.  Similarly clicking a Blue run eater will
                re-assign the eater to the Red run.
            </p>
            <p>
                At the bottom on the page is the current length of the each run.
            </p>
            <p>
                Clicking Commit will complete the process and two new MilkRuns will be created.
                They will be listed on the MilkRuns page as child of ${controller.getState().getRealMilkRun().getShortId()}
                and marked as "Unrouted".
                The original MilkRun will be marked "Split".
            </p>
        </td>
        <td width="200px"></td>
        <td width="500px">
            <p>Picks are in italics and can not be moved, they are automatically computed from the set of
                drops in the run.</p>
            <p>Drops are in plain typeface and can be moved between runs.</p>
            <p>Extra stops are in <b>bold</b> and can be moved between runs.</p>
            <table>
                <th>
                <td>Marker Color</td>
                <td>Meaning</td>
                </th>
                <tr>
                    <td>Red</td>
                    <td>Original Eaters</td>
                </tr>
                <tr>
                    <td>Blue</td>
                    <td>Child Eaters</td>
                </tr>

                <tr>
                    <td>Green</td>
                    <td>Seeders in both runs</td>
                </tr>
                <tr>
                    <td>Purple</td>
                    <td>Seeders only in original run</td>
                </tr>
                <tr>
                    <td>Orange</td>
                    <td>Seeders only in child run</td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<script>
    function startAChanged() {
        var x = document.getElementById('startSelectA').value;
        location.assign("/milkrun-split-manual-by-eater3/set/starta/" + x);
    }
    function endAChanged() {
        var x = document.getElementById('endSelectA').value;
        location.assign("/milkrun-split-manual-by-eater3/set/enda/" + x);
    }
    function startBChanged() {
        var x = document.getElementById('startSelectB').value;
        location.assign("/milkrun-split-manual-by-eater3/set/startb/" + x);
    }
    function endBChanged() {
        var x = document.getElementById('endSelectB').value;
        location.assign("/milkrun-split-manual-by-eater3/set/endb/" + x);
    }

    var checkedA = [];
    function checkedStopA(checker) {
        var x = checker.checked;
        if (x) {
            var i = checkedA.indexOf(checker.value);
            if (i < 0) {
                checkedA.push(checker.value);
            }
        }
        else {
            var i = checkedA.indexOf(checker.value);
            if (i > -1) {
                checkedA.splice(i, 1);
            }
        }
    }
    var checkedB = [];
    function checkedStopB(checker) {
        var x = checker.checked;
        if (x) {
            var i = checkedB.indexOf(checker.value);
            if (i < 0) {
                checkedB.push(checker.value);
            }
        }
        else {
            var i = checkedB.indexOf(checker.value);
            if (i > -1) {
                checkedB.splice(i, 1);
            }
        }
    }
    function moveEm() {
        var aList = checkedA.toString();
        var bList = checkedB.toString();
        location.assign("/milkrun-split-manual-by-eater3/move?aList=" + aList + "&bList=" + bList);
    }
</script>
</body>
</html>