import 'package:get/get.dart';

enum UserReqState {
  initial,
  loading,
  loaded,
  failure,
  displayOne,
}

class UserRequestController extends GetxController {
  var userReqState = UserReqState.initial.obs;

  void getUserReq() async {
    // Call the API or any logic to get user requests
    // Update state based on the result
    userReqState.value = UserReqState.loading;
    // Perform the API call here
    // Update the state based on the API response
    // For example:
    // userReqState.value = UserReqState.loaded; // after successful API call
  }

// Other methods to handle state updates and API calls
}
