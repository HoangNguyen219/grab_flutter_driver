import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grab_driver_app/controllers/firebase_controller.dart';
import 'package:grab_driver_app/services/auth_api_service.dart';
import 'package:grab_driver_app/views/auth/page/register_page.dart';
import 'package:grab_driver_app/views/home/home_page.dart';

class AuthController extends GetxController {
  final AuthService _authService;
  final FirebaseController _firebaseController = FirebaseController();

  AuthController(this._authService);

  final RxBool isLoggedIn = false.obs;
  final RxString userId = ''.obs;
  final RxString phone = ''.obs;

  // Check if the user exists
  Future<void> checkUser(String phoneNumber) async {
    try {
      final result = await _authService.checkUser(phoneNumber);

      if (result['success'] == true) {
        isLoggedIn.value = true;
        userId.value = result['userId'];
      } else {
        isLoggedIn.value = false;
        userId.value = '';
      }
    } catch (e) {
      // Handle errors during user check
      print('Error checking user: $e');
    }
  }

  // On-board the user with additional details
  Future<void> onBoardUser(String phoneNumber, String name, String userType, int maxDistance) async {
    try {
      final result = await _authService.onBoardUser(phoneNumber, name, userType, maxDistance);

      if (result['success'] == true) {
        isLoggedIn.value = true;
        userId.value = result['userId'];
      } else {
        isLoggedIn.value = false;
        userId.value = '';
      }
    } catch (e) {
      // Handle errors during on-boarding
      print('Error on-boarding user: $e');
    }
  }

  // Verify the phone number using Firebase authentication
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    Get.snackbar("Verifying Number", "Please wait ..");
    await _firebaseController.verifyPhoneNumber(phoneNumber);
    phone.value = phoneNumber;
  }

  // Verify the OTP entered by the user
  Future<void> verifyOtp(String smsCode, BuildContext context) async {
    Get.snackbar("Validating Otp", "Please wait ..");
    try {
      await _firebaseController.verifyOTP(smsCode).whenComplete(() async {
        await checkUser(phone.value);

        if (userId.isNotEmpty) {
          // Navigate to the home page on successful verification
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext context) =>  HomePage()),
          );
        } else {
          // Navigate to the registration page if user not found
          Get.offAll(() => RegisterPage());
        }
      });
    } catch (e) {
      // Handle errors during OTP verification
      print('Error verifying OTP: $e');
      Get.snackbar("Error", "Failed to verify OTP");
    }
  }

// Future<void> logOut() async {
//   // You may need to add logic to clear authentication tokens, etc.
//   isLoggedIn.value = false;
//   userId.value = '';
// }
}
