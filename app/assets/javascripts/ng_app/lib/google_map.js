"use strict";

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var GoogleMap = function () {
  function GoogleMap(options) {
    _classCallCheck(this, GoogleMap);

    this.elementId = options.elementId;
    this.initialCoordinates = { lat: -1.29, lng: 36.817 };
    this.initialZoom = 8;
    this.markersLimit = 2;
    this.markers = [];
    this.onCoordinatesChanged = options.onCoordinatesChanged;
  }

  _createClass(GoogleMap, [{
    key: "init",
    value: function init() {
      var _this = this;

      this.map = new google.maps.Map(document.getElementById(this.elementId), {
        center: this.initialCoordinates,
        zoom: this.initialZoom
      });
      this.map.addListener('click', function (e) {
        _this.placeMarker(e.latLng);
      });
    }
  }, {
    key: "requestDirections",
    value: function requestDirections() {
      var request = {
        origin: this.markers[0].position,
        destination: this.markers[1].position,
        travelMode: "DRIVING"
      };
      var directions = new google.maps.DirectionsService();
      directions.route(request, this.drawDirections.bind(this));
    }
  }, {
    key: "drawDirections",
    value: function drawDirections(args) {
      var directionsDisplay = new google.maps.DirectionsRenderer({ suppressMarkers: true });
      directionsDisplay.setMap(this.map);
      directionsDisplay.setDirections(args);
    }
  }, {
    key: "placeMarker",
    value: function placeMarker(position) {
      var _this2 = this;

      // console.log({ lat: position.lat(), lng: position.lng() })
      if (this.markersLimit-- > 0) {
        var marker = new google.maps.Marker({ position: position, map: this.map, draggable: true });
        this.map.panTo(position);
        var index = this.markers.push(marker);

        this.onCoordinatesChanged(index, position);
        marker.addListener("dragend", function (e) {
          console.log({ lat: e.latLng.lat(), lng: e.latLng.lng() });
          _this2.onCoordinatesChanged(index, e.latLng);
          if (_this2.markersLimit < 1) {
            _this2.requestDirections();
          }
        });
      }

      if (this.markersLimit < 1) {
        this.requestDirections();
      }
    }
  }]);

  return GoogleMap;
}();



// class GoogleMap {
//   constructor(options) {
//     this.elementId = options.elementId;
//     this.initialCoordinates = {lat: -1.29, lng: 36.817};
//     this.initialZoom = 8;
//     this.markersLimit = 2;
//     this.markers = [];
//     this.onCoordinatesChanged = options.onCoordinatesChanged;
//   }
//
//   init() {
//     this.map = new google.maps.Map(document.getElementById(this.elementId), {
//       center: this.initialCoordinates,
//       zoom: this.initialZoom
//     });
//     this.map.addListener('click', e => {
//         this.placeMarker(e.latLng);
//     });
//   }
//
//   requestDirections() {
//     let request = {
//       origin: this.markers[0].position,
//       destination: this.markers[1].position,
//       travelMode: "DRIVING",
//     };
//     let directions = new google.maps.DirectionsService();
//     directions.route(request, this.drawDirections.bind(this));
//   }
//
//   drawDirections(args) {
//     var directionsDisplay = new google.maps.DirectionsRenderer({ suppressMarkers: true });
//     directionsDisplay.setMap(this.map);
//     directionsDisplay.setDirections(args);
//   }
//
//   placeMarker(position) {
//     // console.log({ lat: position.lat(), lng: position.lng() })
//     if (this.markersLimit-- > 0) {
//       let marker = new google.maps.Marker({ position: position, map: this.map, draggable: true });
//       this.map.panTo(position);
//       let index = this.markers.push(marker);
//
//       this.onCoordinatesChanged(index, position);
//       marker.addListener("dragend", e => {
//         console.log({ lat: e.latLng.lat(), lng: e.latLng.lng() });
//         this.onCoordinatesChanged(index, e.latLng);
//         if (this.markersLimit < 1) {
//           this.requestDirections();
//         }
//       });
//     }
//
//     if (this.markersLimit < 1) {
//       this.requestDirections();
//     }
//   }
// }
