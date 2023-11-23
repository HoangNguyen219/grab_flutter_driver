import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:grab_driver_app/models/ride.dart';
import 'package:grab_driver_app/utils/constants/ride_constants.dart';
import 'package:grab_driver_app/utils/location_service.dart';

enum MapState {
  mapInitial,
  mapLoading,
  mapLoaded,
}

class MapController extends GetxController {
  var markers = <MarkerId, Marker>{}.obs;
  var polylines = <PolylineId, Polyline>{}.obs;
  var polylineCoordinates = <LatLng>[].obs;
  var isPolyLineDrawn = false.obs;
  var mapState = MapState.mapInitial.obs;

  late double _sourceLat;
  late double _sourceLong;
  late double _currentLat;
  late double _currentLong;
  late double _destinationLat;
  late double _destinationLong;

  final Completer<GoogleMapController> googleMapController = Completer();

  void drawRoute(Ride ride, context) async {
    if (isPolyLineDrawn.value == false) {
      mapState.value = MapState.mapLoading;

      _sourceLat = ride.startLocation![RideConstants.lat];
      _sourceLong = ride.startLocation![RideConstants.long];
      _destinationLat = ride.endLocation![RideConstants.lat];
      _destinationLong = ride.endLocation![RideConstants.long];

      // For waypoint
      String pickupPoint = ride.startAddress.toString();

      // Source location/pickup point marker
      MarkerId markerId = const MarkerId("pickupPoint");
      Marker sourceMarker = Marker(
        markerId: markerId,
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(_sourceLat, _sourceLong),
        infoWindow: const InfoWindow(title: "Pickup Point"),
      );
      markers[markerId] = sourceMarker;

      // Destination marker
      MarkerId markerDestId = const MarkerId("destPoint");
      Marker destMarker = Marker(
        markerId: markerDestId,
        icon: BitmapDescriptor.defaultMarkerWithHue(90),
        position: LatLng(_destinationLat, _destinationLong),
        infoWindow: const InfoWindow(title: "Destination"),
      );
      markers[markerDestId] = destMarker;

      // Get current location for drawing route
      final position = await LocationService.getLocation();
      if (position == null) {
        // Handle the case where the location permission is denied or null
        return;
      }
      _currentLat = position.latitude;
      _currentLong = position.longitude;

      await _getPolyline(_currentLat, _currentLong, _destinationLat, _destinationLong, pickupPoint);
    } else {
      print("Route is already drawn.");
    }
  }

  Future<void> _getPolyline(double sourceLat, double sourceLong, double destLat, double destLong,
      String pickupPoint) async {

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      dotenv.env['API_KEY'] ?? "AIzaSyCkWlGDvftO896OXUQN_g485-a39PET8e8",
      PointLatLng(sourceLat, sourceLong),
      PointLatLng(destLat, destLong),
      travelMode: TravelMode.driving,
      wayPoints: [PolylineWayPoint(location: pickupPoint)],
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      _addPolyline();
    }
  }

  void _addPolyline() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.black,
      points: polylineCoordinates.toList(),
      width: 5,
    );
    polylines[id] = polyline;
    isPolyLineDrawn.value = true;
    mapState.value = MapState.mapLoaded;
  }

  void resetMapForNewRide(BuildContext context) async {
    if (isPolyLineDrawn.value == true) {
      isPolyLineDrawn.value = false;
      polylineCoordinates.clear();
      mapState.value = MapState.mapInitial;
    }
  }

  void getCurrentLocation() async {
    final position = await LocationService.getLocation();

    if (position == null) {
      // Handle the case where the location permission is denied or null
      return;
    }

    try {
      final controller = await googleMapController.future;

      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 18.0,
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
