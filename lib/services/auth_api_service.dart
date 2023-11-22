import 'package:grab_driver_app/utils/constants/user_constants.dart';

import 'base_api_service.dart';

class AuthService extends BaseApiService {
  AuthService(super.baseUrl);

  Future<Map<String, dynamic>> checkUser(String phone) async {
    final Map<String, dynamic> body = {UserConstants.phone: phone};
    return await postRequest('api/auth/check-user', body);
  }

  Future<Map<String, dynamic>> onBoardUser(String phone, String name, String userType, int maxDistance) async {
    final Map<String, dynamic> body = {
      UserConstants.phone: phone,
      UserConstants.name: name,
      UserConstants.userType: userType,
      UserConstants.maxDistance: maxDistance,
    };
    return await postRequest('api/auth/on-board-user', body);
  }
}
