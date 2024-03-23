import { Loader } from "@googlemaps/js-api-loader"

export default {
  mounted() {

    console.log("hey girl")

    const hook = this;
    // the element hooked
    elt = hook.el;
    hook.map = null;
    const loader = new Loader({
      
      version: "weekly"
    });
    loader
      .importLibrary('maps')
      .then(({ Map }) => {

        console.log("hey hey girl")

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

        // let's add a function to update markers from input
        hook.updateMarkers = function () {
          const targets = JSON.parse(hook.el.dataset.targets)
          // const targets = hook.targets;
          console.log("updating markers", targets);
          targets.forEach(({ id, name, lat, lng }) => {
            const marker = new google.maps.Marker({
              position: { lat: lat, lng: lng },
              map: hook.map,
              title: name,
              label: {
                text: "X", fontSize: "0.8rem", color: 'white'
              }
            });

            /// Right up in here, I should make a connection to the events database. I should get the id and match on it (and the current date).
            const contentString = name


            const infowindow = new google.maps.InfoWindow({
              content: contentString,
              ariaLabel: name,
            });

            const map = hook.map

            marker.addListener("click", () => {
              infowindow.open({
                anchor: marker,
                map,
              });
            });


          });

        }






        // let's update the map with data provided in dom object
        hook.updateMarkers();

      });
  }
}