import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grab_driver_app/controllers/ride_controller.dart';

class RideDetailsPage extends StatelessWidget {
  final RideController rideController = Get.find();

  RideDetailsPage({super.key}); // Get the RideController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Details'),
      ),
      body: Center(
        child: Obx(() {
          // Use Obx to reactively update UI when ride details change
          final ride = rideController.selectedRide.value;

          if (ride != null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Customer ID: ${ride['customerId']}'),
                Text('Start Location: ${ride['startLocation']}'),
                Text('End Location: ${ride['endLocation']}'),
                Text('Start Address: ${ride['startAddress']}'),
                Text('End Address: ${ride['endAddress']}'),
                Text('Distance: ${ride['distance']}'),
                ElevatedButton(
                  onPressed: () {
                    // Call the completeRide method when the complete button is pressed
                    rideController.completeRide(ride['rideId']);
                  },
                  child: const Text('Complete Ride'),
                ),
              ],
            );
          } else {
            return const Text('No ride details available.');
          }
        }),
      ),
    );
  }
}
