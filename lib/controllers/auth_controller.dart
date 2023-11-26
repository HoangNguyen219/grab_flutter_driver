import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grab_driver_app/controllers/firebase_controller.dart';
import 'package:grab_driver_app/services/auth_api_service.dart';
import 'package:grab_driver_app/utils/constants/app_constants.dart';
import 'package:grab_driver_app/utils/constants/ride_constants.dart';
import 'package:grab_driver_app/views/auth/page/phone_verification_page.dart';
import 'package:grab_driver_app/views/auth/page/register_page.dart';
import 'package:grab_driver_app/views/home/page/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final AuthService _authService;
  final FirebaseController _firebaseController = FirebaseController();

  AuthController(this._authService);

  late SharedPreferences _prefs;

  final RxInt driverId = 0.obs;
  final RxString phone = EMPTY_STRING.obs;
  var profileImgUrl = "https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png".obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  // Load userId from SharedPreferences
  Future<void> _loadUser() async {
    _prefs = await SharedPreferences.getInstance();
    driverId.value = _prefs.getInt(RideConstants.driverId) ?? 0;
  }

  // Save userId to SharedPreferences
  Future<void> _saveUser() async {
    await _prefs.setInt(RideConstants.driverId, driverId.value);
  }

  // Remove userId from SharedPreferences
  Future<void> removeUser() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.remove(RideConstants.driverId);
    await _prefs.remove(DRIVER_STATUS);
  }

  // Check if the user exists
  Future<void> checkUser(String phoneNumber) async {
    try {
      final result = await _authService.checkUser(phoneNumber);

      if (result[STATUS] == true) {
        driverId.value = result[DATA][ID];
        _saveUser();
      } else {
        driverId.value = 0;
      }
    } catch (e) {
      // Handle errors during user check
      print('Error checking user: $e');
    }
  }

  // On-board the user with additional details
  Future<void> onBoardUser(String name, int maxDistance, BuildContext context) async {
    try {
      final result = await _authService.onBoardUser(phone.value, name, DRIVER, maxDistance);

      if (result[STATUS] == true) {
        driverId.value = result[DATA][ID];
        Get.snackbar("Welcome.", "registration successful!", snackPosition: SnackPosition.BOTTOM);
        Get.offAll(() => HomePage());
      } else {
        driverId.value = 0;
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

      if (driverId.value != 0) {
        Get.offAll(() => HomePage());
      } else {
        Get.offAll(() => const RegisterPage());
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

  Future<void> logOut() async {
    driverId.value = 0;
    removeUser();
    Get.offAll(() => const PhoneVerificationPage());
  }
}
