import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grab_driver_app/controllers/auth_controller.dart';

class HomePage extends StatelessWidget {
  final AuthController authController = Get.find(); // Get the AuthController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              // Display user information using Obx for reactive updates
              return Text('User ID: ${authController.userId.value}');
            }),
            ElevatedButton(
              onPressed: () {
                // Call the logOut method when the logout button is pressed
                // authController.logOut();
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
