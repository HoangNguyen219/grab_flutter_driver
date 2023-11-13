import 'package:get/get.dart';
import 'package:grab_driver_app/services/ride_api_service.dart';

class RideController extends GetxController {
  final RideService _rideService;
  Rx<Map<String, dynamic>?> selectedRide = Rx<Map<String, dynamic>?>(null);

  RideController(this._rideService);

  void setSelectedRide(Map<String, dynamic>? ride) {
    selectedRide.value = ride;
  }

  Future<void> createBookingNow(Map<String, dynamic> rideData) async {
    try {
      final result = await _rideService.createBookingNow(rideData);

      if (result['success'] == true) {
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

      if (result['success'] == true) {
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

      if (result['success'] == true) {
        // Handle successful ride cancellation
      } else {
        // Handle failed ride cancellation
      }
    } catch (e) {
      // Handle errors
      print('Error canceling ride: $e');
    }
  }

  Future<void> acceptRide(String rideId, String driverId) async {
    try {
      final result = await _rideService.acceptRide(rideId, driverId);

      if (result['success'] == true) {
        // Handle successful ride acceptance
      } else {
        // Handle failed ride acceptance
      }
    } catch (e) {
      // Handle errors
      print('Error accepting ride: $e');
    }
  }

  Future<void> completeRide(String rideId) async {
    try {
      final result = await _rideService.completeRide(rideId);

      if (result['success'] == true) {
        // Handle successful ride completion
      } else {
        // Handle failed ride completion
      }
    } catch (e) {
      // Handle errors
      print('Error completing ride: $e');
    }
  }

  Future<void> pickRide(String rideId) async {
    try {
      final result = await _rideService.pickRide(rideId);

      if (result['success'] == true) {
        // Handle successful ride picking
      } else {
        // Handle failed ride picking
      }
    } catch (e) {
      // Handle errors
      print('Error picking ride: $e');
    }
  }

  // Future<List<Map<String, dynamic>>> getRides(String userId, {bool isDriver = false}) async {
  //   try {
  //     final result = await _rideService.getRides(userId, isDriver: isDriver);
  //
  //     if (result['success'] == true) {
  //       // Handle successful ride retrieval
  //       return List<Map<String, dynamic>>.from(result['rides']);
  //     } else {
  //       // Handle failed ride retrieval
  //       return [];
  //     }
  //   } catch (e) {
  //     // Handle errors
  //     print('Error getting rides: $e');
  //     return [];
  //   }
  // }
  //
  // Future<List<Map<String, dynamic>>> getCurrentRides(String driverId) async {
  //   try {
  //     final result = await _rideService.getCurrentRides(driverId);
  //
  //     if (result['success'] == true) {
  //       // Handle successful current ride retrieval
  //       return List<Map<String, dynamic>>.from(result['currentRides']);
  //     } else {
  //       // Handle failed current ride retrieval
  //       return [];
  //     }
  //   } catch (e) {
  //     // Handle errors
  //     print('Error getting current rides: $e');
  //     return [];
  //   }
  // }
}
