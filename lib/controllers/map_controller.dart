import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:grab_driver_app/utils/location_service.dart';

enum MapState {
  MapInitial,
  MapLoading,
  MapLoaded,
}

class MapController extends GetxController {
  var markers = <MarkerId, Marker>{}.obs;
  var polylines = <PolylineId, Polyline>{}.obs;
  var polylineCoordinates = <LatLng>[].obs;
  var isPolyLineDrawn = false.obs;
  var mapState = MapState.MapInitial.obs;

  late double _sourceLat;
  late double _sourceLong;
  late double _currentLat;
  late double _currentLong;
  late double _destinationLat;
  late double _destinationLong;

  late GoogleMapController controller;

  // void drawRoute(UserReqDisplayOne state, context) async {
  //   if (isPolyLineDrawn.value == false) {
  //     // emit(GrabMapLoading());
  //
  //     _sourceLat = state.tripDriver.tripHistoryModel.sourceLocation!.latitude;
  //     _sourceLong = state.tripDriver.tripHistoryModel.sourceLocation!.longitude;
  //     _destinationLat = state.tripDriver.tripHistoryModel.destinationLocation!.latitude;
  //     _destinationLong = state.tripDriver.tripHistoryModel.destinationLocation!.longitude;
  //
  //     // For waypoint
  //     String pickupPoint = state.tripDriver.tripHistoryModel.source.toString();
  //
  //     // Source location/pickup point marker
  //     MarkerId markerId = const MarkerId("pickupPoint");
  //     Marker sourceMarker = Marker(
  //       markerId: markerId,
  //       icon: BitmapDescriptor.defaultMarker,
  //       position: LatLng(_sourceLat, _sourceLong),
  //       infoWindow: const InfoWindow(title: "Pickup Point"),
  //     );
  //     markers[markerId] = sourceMarker;
  //
  //     // Destination marker
  //     MarkerId markerDestId = const MarkerId("destPoint");
  //     Marker destMarker = Marker(
  //       markerId: markerDestId,
  //       icon: BitmapDescriptor.defaultMarkerWithHue(90),
  //       position: LatLng(_destinationLat, _destinationLong),
  //       infoWindow: const InfoWindow(title: "Destination"),
  //     );
  //     markers[markerDestId] = destMarker;
  //
  //     // Get current location for drawing route
  //     await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //         .then((Position position) async {
  //       _currentLat = position.latitude;
  //       _currentLong = position.longitude;
  //     }).catchError((e) {
  //       print(e);
  //     });
  //
  //     await _getPolyline(_currentLat, _currentLong, _destinationLat, _destinationLong, pickupPoint);
  //   } else {
  //     print("Route is already drawn.");
  //   }
  // }

  Future<void> _getPolyline(double sourceLat, double sourceLong, double destLat, double destLong, String pickupPoint) async {
    // emit(GrabMapLoading());
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      dotenv.env['API_KEY'] ?? "",
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
    // emit(GrabMapLoaded(markers: markers, polylines: polylines));
  }

  void resetMapForNewRide(BuildContext context) async {
    if (isPolyLineDrawn.value == true) {
      isPolyLineDrawn.value = false;
      polylineCoordinates.clear();
      // emit(GrabMapInitial());
    }
  }

  void getCurrentLocation(BuildContext context, {required Completer<GoogleMapController> mapController}) async {
    final position = await LocationService.getLocation();

    if (position == null) {
      // Handle the case where the location permission is denied or null
      return;
    }

    try {
      final controller = await mapController.future;

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
