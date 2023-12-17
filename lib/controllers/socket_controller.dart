import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:grab_driver_app/controllers/auth_controller.dart';
import 'package:grab_driver_app/controllers/map_controller.dart';
import 'package:grab_driver_app/models/ride.dart';
import 'package:grab_driver_app/services/socket_service.dart';
import 'package:grab_driver_app/utils/constants/ride_constants.dart';
import 'package:grab_driver_app/utils/location_service.dart';

class SocketController extends GetxController {
  final SocketService _socketService;
  final AuthController _authController = Get.find();
  final MapController _mapController = Get.find();

  RxList<Ride> rideRequests = <Ride>[].obs;

  SocketController(this._socketService) {
    initSocket();
  }

  void initSocket() {
    _socketService.connect(
      onBook: (Ride ride) async {
        final currentPosition = await LocationService.getLocation();
        final pickupPosition = ride.startLocation;
        final distance = await _mapController.getDistance(currentPosition!.latitude, currentPosition.longitude,
            pickupPosition![RideConstants.lat], pickupPosition[RideConstants.long]);
        final maxDistance = int.parse(dotenv.env['MAX_DISTANCE'].toString());
        if (distance! <= maxDistance) {
          rideRequests.add(ride);
        }
      },
      onCancel: (customerId) {
        rideRequests.removeWhere((rideRequest) => rideRequest.customerId == customerId);
        _mapController.resetMapForNewRide();
      },
    );
  }

  void closeSocket() {
    _socketService.disconnect();
  }

  void addDriver(Position location) {
    _socketService.addDriver(_authController.driverId.value, location);
  }

  void removeDriver() {
    _socketService.removeDriver(_authController.driverId.value);
  }

  void acceptRide(Ride ride, Position location) {
    _socketService.acceptRide(_authController.driverId.value, ride.customerId!, location);
    rideRequests.removeWhere((rideRequest) => rideRequest.customerId == ride.customerId);
    LocationService.trackCurrentLocation(changeLocationDriver, ride);
  }

  void pickRide(Ride ride) {
    _socketService.pickRide(_authController.driverId.value, ride.customerId!);
  }

  void completeRide(Ride ride) {
    _socketService.completeRide(_authController.driverId.value, ride.customerId!);
  }

  void changeLocationDriver(Ride ride, Position location) {
    _socketService.changeLocationDriver(_authController.driverId.value, ride.customerId!, location);
  }
}
