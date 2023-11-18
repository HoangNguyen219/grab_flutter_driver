import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:grab_driver_app/controllers/auth_controller.dart';
import 'package:grab_driver_app/controllers/socket_controller.dart';
import 'package:grab_driver_app/services/socket_service.dart';
import 'package:grab_driver_app/utils/location_service.dart';

enum DriverStatus { Online, Offline }

class DriverController extends GetxController {
  var driverStatus = Rx<DriverStatus>(DriverStatus.Offline);
  final SocketController _socketController = SocketController(SocketService(dotenv.env['SOCKET_URL'] ?? "ws://10.0.2.2:6666"));
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
  }
}
