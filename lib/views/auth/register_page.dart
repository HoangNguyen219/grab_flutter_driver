import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grab_driver_app/controllers/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  final AuthController authController = Get.find(); // Get the AuthController

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userTypeController = TextEditingController();
  final TextEditingController maxDistanceController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: userTypeController,
              decoration: InputDecoration(labelText: 'User Type (DRIVER or CUSTOMER)'),
            ),
            TextField(
              controller: maxDistanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Max Distance'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call the onBoardUser method when the register button is pressed
                authController.onBoardUser(
                  phoneController.text,
                  nameController.text,
                  userTypeController.text,
                  int.parse(maxDistanceController.text),
                );
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
