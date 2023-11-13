import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grab_driver_app/controllers/ride_controller.dart';

class CreateRidePage extends StatelessWidget {
  final RideController rideController = Get.find(); // Get the RideController

  final TextEditingController customerIdController = TextEditingController();
  final TextEditingController startLocationController = TextEditingController();
  final TextEditingController endLocationController = TextEditingController();
  final TextEditingController startAddressController = TextEditingController();
  final TextEditingController endAddressController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Ride'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: customerIdController,
              decoration: InputDecoration(labelText: 'Customer ID'),
            ),
            TextField(
              controller: startLocationController,
              decoration: InputDecoration(labelText: 'Start Location'),
            ),
            TextField(
              controller: endLocationController,
              decoration: InputDecoration(labelText: 'End Location'),
            ),
            TextField(
              controller: startAddressController,
              decoration: InputDecoration(labelText: 'Start Address'),
            ),
            TextField(
              controller: endAddressController,
              decoration: InputDecoration(labelText: 'End Address'),
            ),
            TextField(
              controller: distanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Distance'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call the createBookingNow method when the create ride button is pressed
                rideController.createBookingNow({
                  'customerId': customerIdController.text,
                  'startLocation': startLocationController.text,
                  'endLocation': endLocationController.text,
                  'startAddress': startAddressController.text,
                  'endAddress': endAddressController.text,
                  'distance': double.parse(distanceController.text),
                });
              },
              child: Text('Create Ride'),
            ),
          ],
        ),
      ),
    );
  }
}
