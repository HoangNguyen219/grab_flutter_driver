import 'package:get/get.dart';
import 'package:grab_driver_app/controllers/socket_controller.dart';
import 'package:grab_driver_app/utils/constants/app_constants.dart';
import 'package:grab_driver_app/utils/location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DriverStatus { online, offline }

class DriverController extends GetxController {
  final Rx<DriverStatus> driverStatus = DriverStatus.offline.obs;
  final SocketController _socketController = Get.find();

  late SharedPreferences _prefs;

  @override
  void onInit() {
    super.onInit();
    _loadDriverStatus();
  }

  Future<void> _loadDriverStatus() async {
    _prefs = await SharedPreferences.getInstance();
    driverStatus.value = _prefs.getInt(DRIVER_STATUS) == 1 ? DriverStatus.online : DriverStatus.offline;
    if (driverStatus.value == DriverStatus.online) {
      setDriverOnline();
    }
  }

  Future<void> setDriverOnline() async {
    driverStatus.value = DriverStatus.online;
    final location = await LocationService.getLocation();
    if (location == null) {
      return;
    }
    _socketController.addDriver(location);
    await _prefs.setInt(DRIVER_STATUS, 1);
  }

  Future<void> setDriverOffline() async {
    driverStatus.value = DriverStatus.offline;
    _socketController.removeDriver();
    await _prefs.setInt(DRIVER_STATUS, 0);
  }
}
