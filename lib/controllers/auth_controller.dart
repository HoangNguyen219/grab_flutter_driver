import 'package:get/get.dart';
import 'package:grab_driver_app/services/auth_api_service.dart';

class AuthController extends GetxController {
  final AuthService _authService;

  AuthController(this._authService);

  final RxBool isLoggedIn = false.obs;
  final RxString userId = ''.obs;

  Future<void> checkUser(String phone) async {
    try {
      final result = await _authService.checkUser(phone);

      if (result['success'] == true) {
        isLoggedIn.value = true;
        userId.value = result['userId'];
      } else {
        isLoggedIn.value = false;
        userId.value = '';
      }
    } catch (e) {
      // Handle errors
      print('Error checking user: $e');
    }
  }

  Future<void> onBoardUser(String phone, String name, String userType, int maxDistance) async {
    try {
      final result = await _authService.onBoardUser(phone, name, userType, maxDistance);

      if (result['success'] == true) {
        isLoggedIn.value = true;
        userId.value = result['userId'];
      } else {
        isLoggedIn.value = false;
        userId.value = '';
      }
    } catch (e) {
      // Handle errors
      print('Error on-boarding user: $e');
    }
  }

  // Future<void> logOut() async {
  //   // You may need to add logic to clear authentication tokens, etc.
  //   isLoggedIn.value = false;
  //   userId.value = '';
  // }
}
