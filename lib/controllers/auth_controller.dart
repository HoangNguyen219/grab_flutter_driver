import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grab_driver_app/controllers/firebase_controller.dart';
import 'package:grab_driver_app/services/auth_api_service.dart';
import 'package:grab_driver_app/utils/constants.dart';
import 'package:grab_driver_app/views/auth/page/register_page.dart';
import 'package:grab_driver_app/views/home/page/home_page.dart';

class AuthController extends GetxController {
  final AuthService _authService;
  final FirebaseController _firebaseController = FirebaseController();

  AuthController(this._authService);

  final RxBool isLoggedIn = false.obs;
  final RxString userId = ''.obs;
  final RxString phone = ''.obs;
  var profileImgUrl =
      "https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png"
          .obs;

  // Check if the user exists
  Future<void> checkUser(String phoneNumber) async {
    try {
      final result = await _authService.checkUser(phoneNumber);

      if (result['status'] == true) {
        isLoggedIn.value = true;
        userId.value = result['data']['id'].toString();
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
  Future<void> onBoardUser(String name, int maxDistance, BuildContext context) async {
    try {
      final result = await _authService.onBoardUser(phone.value, name, AppConstants.DRIVER, maxDistance);

      if (result['status'] == true) {
        isLoggedIn.value = true;
        userId.value = result['data']['id'];
        Get.snackbar("Welcome.", "registration successful!",
            snackPosition: SnackPosition.BOTTOM);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        );
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
      await _firebaseController.verifyOTP(smsCode);

      await checkUser(phone.value);
      print(phone.value);

      if (userId.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        );
      } else {
        Get.offAll(() =>  RegisterPage());
      }
    } catch (e) {
      print('Lỗi khi xác minh OTP: $e');
      if (e.toString().contains('invalid')) {
        Get.snackbar("Error", "The verification code from SMS/TOTP is invalid");
      } else {
        Get.snackbar("Error", "Cannot verify OTP");
      }
    }
  }

// Future<void> logOut() async {
//   // You may need to add logic to clear authentication tokens, etc.
//   isLoggedIn.value = false;
//   userId.value = '';
// }
}
