import 'package:get/get.dart';
import 'package:grab_driver_app/controllers/auth_controller.dart';
import 'package:grab_driver_app/controllers/socket_controller.dart';
import 'package:grab_driver_app/utils/location_service.dart';

enum DriverStatus { Online, Offline }

class DriverController extends GetxController {
  var driverStatus = Rx<DriverStatus>(DriverStatus.Offline);
  final SocketController _socketController = Get.find();
  final AuthController _authController = Get.find();

  Future<void> setDriverOnline() async {
    driverStatus.value = DriverStatus.Online;
    final location = await LocationService.getLocation();
    if (location == null) {
      return;
    }
    _socketController.addDriver(_authController.userId.value, location);
  }

  void setDriverOffline() {
    driverStatus.value = DriverStatus.Offline;
    _socketController.removeDriver(_authController.userId.value);
  }
}
