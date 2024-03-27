import { Loader } from "@googlemaps/js-api-loader"

export default {
  mounted() {

    const hook = this;
    // the element hooked
    elt = hook.el;
    hook.map = null;
    const loader = new Loader({
    
      version: "weekly",
      libraries: ['places']
    });
    loader
      .importLibrary('maps')
      .then(({ Map }) => {

        hook.map = new Map(elt, {
          center: { lat: 29.954137, lng: -90.1184713 },
          // center: { lat: 1.29847, lng: 103.844421 },
          zoom: 12,
          // additional map configuration attributes
          zoomControl: true,
          mapTypeControl: false,
          scaleControl: false,
          streetViewControl: false,
          rotateControl: false,
          fullscreenControl: true,
          styles: [
            {
              "featureType": "all",
              "stylers": [
                { "saturation": -100 }
              ]
            },
            {
              "featureType": "water",
              "stylers": [
                {
                  "saturation": 0,
                  "color": "#30A4DC"
                  // "color": "#79b0cb"
                }
              ]
            }
          ]
        });

        // Create the search box and link it to the UI element.
        const input = document.getElementById("pac-input");
        const searchBox = new google.maps.places.SearchBox(input);

        hook.map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);
        // Bias the SearchBox results towards current map's viewport.
        hook.map.addListener("bounds_changed", () => {
          searchBox.setBounds(hook.map.getBounds());
        });


        let markers = [];
        const map = hook.map


        //////////////////// SEARCH BOX //////////////////// 
        // Listen for the event fired when the user selects a prediction and retrieve
        // more details for that place.
        searchBox.addListener("places_changed", () => {
          const places = searchBox.getPlaces();

          if (places.length == 0) {
            return;
          }

          // Clear out the old markers.
          markers.forEach((marker) => {
            marker.setMap(null);
          });
          markers = [];

          // For each place, get the icon, name and location.
          const bounds = new google.maps.LatLngBounds();

          places.forEach((place) => {
            if (!place.geometry || !place.geometry.location) {
              console.log("Returned place contains no geometry");
              return;
            }

            var svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="blue" fill-opacity="0.6" class="w-6 h-6">' +
            '<path fill-rule="evenodd" d="m11.54 22.351.07.04.028.016a.76.76 0 0 0 .723 0l.028-.015.071-.041a16.975 16.975 0 0 0 1.144-.742 19.58 19.58 0 0 0 2.683-2.282c1.944-1.99 3.963-4.98 3.963-8.827a8.25 8.25 0 0 0-16.5 0c0 3.846 2.02 6.837 3.963 8.827a19.58 19.58 0 0 0 2.682 2.282 16.975 16.975 0 0 0 1.145.742ZM12 13.5a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z" clip-rule="evenodd" />' +
            '</svg>';

            // Create a marker for each place.
            markers.push(
              new google.maps.Marker({
                map,
                icon: {
                  url: 'data:image/svg+xml;charset=utf-8,' + encodeURIComponent(svg), 
                  scale: 2,
                  anchor: new google.maps.Point(0, 20),
                  size: new google.maps.Size(71, 71),
                  scaledSize: new google.maps.Size(40, 40),
                  fillColor: "blue",
                  fillOpacity: 0.6
                },
                title: place.name,
                position: place.geometry.location,
              }),
            );

            if (place.geometry.viewport) {
              // Only geocodes have viewport.
              bounds.union(place.geometry.viewport);
            } else {
              bounds.extend(place.geometry.location);
            }


            markers.map(function (marker) {

              let infowindow
              infowindow = new google.maps.InfoWindow();

              google.maps.event.addListener(marker, "click", () => {
                map.panTo(marker.getPosition());
                map.setZoom(15)
                infowindow.setContent(place.name);
                infowindow.open({
                  anchor: marker,
                  map,
                });
              });

            })

          });
          map.fitBounds(bounds);

        });


        //////////////////// DEFAULT PLACES //////////////////// 
        hook.updateDefaultLocations = function () {
          var request = {
            query: '517 Passera Ct',
            fields: ['name', 'geometry'],
          };

          var service = new google.maps.places.PlacesService(map);

          service.findPlaceFromQuery(request, function (results, status) {
            if (status === google.maps.places.PlacesServiceStatus.OK) {
              for (var i = 0; i < results.length; i++) {
                createMarker(results[i], map);
              }
              map.setCenter(results[0].geometry.location);
            }
          });

          function createMarker(place, map) {
            if (!place.geometry || !place.geometry.location) return;

            const svgMarker = {
              path: "M11.48 3.499a.562.562 0 0 1 1.04 0l2.125 5.111a.563.563 0 0 0 .475.345l5.518.442c.499.04.701.663.321.988l-4.204 3.602a.563.563 0 0 0-.182.557l1.285 5.385a.562.562 0 0 1-.84.61l-4.725-2.885a.562.562 0 0 0-.586 0L6.982 20.54a.562.562 0 0 1-.84-.61l1.285-5.386a.562.562 0 0 0-.182-.557l-4.204-3.602a.562.562 0 0 1 .321-.988l5.518-.442a.563.563 0 0 0 .475-.345L11.48 3.5Z",
              fillColor: "blue",
              fillOpacity: 0.6,
              strokeWeight: 0,
              rotation: 0,
              scale: 1,
              anchor: new google.maps.Point(0, 20),
            };

            const marker = new google.maps.Marker({
              map,
              position: place.geometry.location,
              icon: svgMarker
            });

            let infowindow
            infowindow = new google.maps.InfoWindow();

            google.maps.event.addListener(marker, "click", () => {
              map.panTo(marker.getPosition());
              map.setZoom(15)
              infowindow.setContent(place.name);
              infowindow.open({
                anchor: marker,
                map,
              });
            });
          }
        }

        //////////////////// VENUE MARKERS //////////////////// 
        hook.updateVenueMarkers = function () {

          var svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="red" fill-opacity="0.6" class="w-6 h-6">' +
          '<path fill-rule="evenodd" d="m11.54 22.351.07.04.028.016a.76.76 0 0 0 .723 0l.028-.015.071-.041a16.975 16.975 0 0 0 1.144-.742 19.58 19.58 0 0 0 2.683-2.282c1.944-1.99 3.963-4.98 3.963-8.827a8.25 8.25 0 0 0-16.5 0c0 3.846 2.02 6.837 3.963 8.827a19.58 19.58 0 0 0 2.682 2.282 16.975 16.975 0 0 0 1.145.742ZM12 13.5a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z" clip-rule="evenodd" />' +
          '</svg>';

          const targets = JSON.parse(hook.el.dataset.targets)
          targets.forEach(({ id, name, lat, lng }) => {
            const marker = new google.maps.Marker({
              position: { lat: lat, lng: lng },
              map: map,
              title: name, 
              icon: {
                url: 'data:image/svg+xml;charset=utf-8,' + encodeURIComponent(svg), 
                scale: 2,
                anchor: new google.maps.Point(0, 20),
                size: new google.maps.Size(71, 71),
                scaledSize: new google.maps.Size(40, 40),
              },
            });

            const contentString = name
            const venueInfoWindow = new google.maps.InfoWindow({
              content: contentString,
              ariaLabel: name,
            });

            marker.addListener("click", () => {
              venueInfoWindow.open({
                anchor: marker,
                map,
              });
            });
          });
        }

        hook.updateDefaultLocations();
        hook.updateVenueMarkers();

      })
  }
}
