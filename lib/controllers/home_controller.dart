import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grab_driver_app/common/internet/internet_controller.dart';
import 'package:grab_driver_app/controllers/driver_location_controller.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Geolocator.requestPermission();
    try {
      Get.find<InternetController>().monitorInternetConnection();
      // Lấy thông tin vị trí tài xế
      // Get.find<DriverLocationController>().getDriverLocation();
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void onClose() {
    try {
      // Hủy đăng ký các sự kiện theo dõi vị trí tài xế
      // Get.find<DriverLocationController>().cancelTimer();
      // Get.find<InternetController>().close();
    } catch (e) {
      print(e);
    }
    super.onClose();
  }
}
