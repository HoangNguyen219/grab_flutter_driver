import 'package:get/get.dart';
import 'package:grab_driver_app/controllers/auth_controller.dart';
import 'package:grab_driver_app/controllers/socket_controller.dart';
import 'package:grab_driver_app/models/ride.dart';
import 'package:grab_driver_app/services/ride_api_service.dart';
import 'package:grab_driver_app/utils/constants/app_constants.dart';

enum RideState {
  isReadyForNextRide,
  isCompleted,
  isAccepted,
  isArrived,
}

class RideController extends GetxController {
  final RideService _rideService;
  final SocketController _socketController = Get.find();
  final AuthController _authController = Get.find();

  final rideState = RideState.isReadyForNextRide.obs;
  final acceptedRide = Ride().obs;
  final isLoading = true.obs;
  final rideHistoryList = <Ride>[].obs;

  RideController(this._rideService);

  Future<void> loadCurrentRide() async {
    var currentRides = await _getCurrentRides();
    acceptedRide.value = currentRides.isNotEmpty ? currentRides[0] : Ride();
    rideState.value = acceptedRide.value.status == ACCEPTED
        ? RideState.isAccepted
        : acceptedRide.value.status == IN_PROGRESS
            ? RideState.isArrived
            : RideState.isCompleted;
  }

  Future<void> acceptRide(Ride ride) async {
    try {
      final result = await _rideService.acceptRide(ride.id!, _authController.driverId.value);

      if (result[STATUS] == true) {
        _socketController.acceptRide(ride);
        rideState.value = RideState.isAccepted;
        acceptedRide.value = ride;
      } else {
        // Handle failed ride acceptance
      }
    } catch (e) {
      // Handle errors
      print('Error accepting ride: $e');
    }
  }

  Future<void> pickRide(Ride ride) async {
    try {
      final result = await _rideService.pickRide(ride.id!);

      if (result[STATUS] == true) {
        // Handle successful ride picking
        _socketController.pickRide(ride);
        rideState.value = RideState.isArrived;
      } else {
        // Handle failed ride picking
      }
    } catch (e) {
      // Handle errors
      print('Error picking ride: $e');
    }
  }

  Future<void> completeRide(Ride ride) async {
    try {
      final result = await _rideService.completeRide(ride.id!);

      if (result[STATUS] == true) {
        // Handle successful ride completion
        _socketController.completeRide(ride);
        rideState.value = RideState.isCompleted;
        acceptedRide.value = Ride();
      } else {
        // Handle failed ride completion
      }
    } catch (e) {
      // Handle errors
      print('Error completing ride: $e');
    }
  }

  Future<List<Ride>> _getCurrentRides() async {
    try {
      final result = await _rideService.getCurrentRides(_authController.driverId.value);
      if (result[STATUS] == true) {
        final List<dynamic> rideData = result[DATA];

        // Map the list of dynamic data to a list of Ride objects
        final List<Ride> rides = rideData.map((data) => Ride.fromJson(data)).toList();

        // Return the list of Ride objects
        return rides;
      } else {
        // If status is not true, return an empty list
        return [];
      }
    } catch (e) {
      // Handle errors
      print('Error getting current rides: $e');
      return []; // Return an empty list in case of an error
    }
  }

  Future<void> getRides() async {
    try {
      isLoading.value = true;
      final result = await _rideService.getRides(_authController.driverId.value);
      if (result[STATUS] == true) {
        final List<dynamic> rideData = result[DATA];

        // Map the list of dynamic data to a list of Ride objects
        final List<Ride> rides = rideData.map((data) => Ride.fromJson(data)).toList();

        // Return the list of Ride objects
        isLoading.value = false;
        rides.sort((a, b) => (b.startTime ?? DateTime.now()).compareTo(a.startTime ?? DateTime.now()));
        rideHistoryList.value = rides;
        return;
      } else {
        // If status is not true, return an empty list
        isLoading.value = false;
        return;
      }
    } catch (e) {
      // Handle errors
      print('Error getting rides: $e');
      isLoading.value = false;
      return;
    }
  }
}
