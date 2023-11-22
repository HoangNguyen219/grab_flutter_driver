import 'package:get/get.dart';
import 'package:grab_driver_app/controllers/auth_controller.dart';
import 'package:grab_driver_app/controllers/socket_controller.dart';
import 'package:grab_driver_app/models/ride.dart';
import 'package:grab_driver_app/services/ride_api_service.dart';

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

  Rx<RideState> rideState = RideState.isReadyForNextRide.obs;
  Rx<Ride> acceptedRide = Ride().obs;

  RideController(this._rideService);

  @override
  void onInit() {
    super.onInit();
    _loadCurrentRide();
  }

  Future<void> _loadCurrentRide() async {
    var currentRides = await getCurrentRides();
    acceptedRide.value = currentRides.isNotEmpty ? currentRides[0] : Ride();
    rideState.value = acceptedRide.value.status == "ACCEPTED"
        ? RideState.isAccepted
        : acceptedRide.value.status == "IN_PROGRESS"
            ? RideState.isArrived
            : RideState.isCompleted;
  }

  Future<void> createBookingNow(Map<String, dynamic> rideData) async {
    try {
      final result = await _rideService.createBookingNow(rideData);

      if (result['status'] == true) {
        // Handle successful ride creation
      } else {
        // Handle failed ride creation
      }
    } catch (e) {
      // Handle errors
      print('Error creating booking now: $e');
    }
  }

  Future<void> scheduleBookingLater(Map<String, dynamic> rideData) async {
    try {
      final result = await _rideService.scheduleBookingLater(rideData);

      if (result['status'] == true) {
        // Handle successful ride scheduling
      } else {
        // Handle failed ride scheduling
      }
    } catch (e) {
      // Handle errors
      print('Error scheduling booking later: $e');
    }
  }

  Future<void> cancelRide(String rideId) async {
    try {
      final result = await _rideService.cancelRide(rideId);

      if (result['status'] == true) {
        // Handle successful ride cancellation
      } else {
        // Handle failed ride cancellation
      }
    } catch (e) {
      // Handle errors
      print('Error canceling ride: $e');
    }
  }

  Future<void> acceptRide(Ride ride) async {
    try {
      final result = await _rideService.acceptRide(ride.id!, _authController.userId.value);

      if (result['status'] == true) {
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

      if (result['status'] == true) {
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

      if (result['status'] == true) {
        // Handle successful ride completion
        _socketController.completeRide(ride);
        rideState.value = RideState.isCompleted;
        acceptedRide = Ride().obs;
      } else {
        // Handle failed ride completion
      }
    } catch (e) {
      // Handle errors
      print('Error completing ride: $e');
    }
  }

  Future<List<Ride>> getCurrentRides() async {
    try {
      final result = await _rideService.getCurrentRides(_authController.userId.value);
      if (result['status'] == true) {
        final List<dynamic> rideData = result['data'];

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

  Future<List<Ride>> getRides() async {
    try {
      final result = await _rideService.getRides(_authController.userId.value);

      if (result['status'] == true) {
        final List<dynamic> rideData = result['data'];

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
      print('Error getting rides: $e');
      return [];
    }
  }
}
