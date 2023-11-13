import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grab_driver_app/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final AuthController authController = Get.find(); // Get the AuthController

  final TextEditingController phoneController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call the checkUser method when the login button is pressed
                authController.checkUser(phoneController.text);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
