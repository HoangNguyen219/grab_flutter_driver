import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:grab_driver_app/services/socket_service.dart';

class SocketController extends GetxController {
  final SocketService _socketService;

  RxList<Map<String, dynamic>> onlineCustomers = <Map<String, dynamic>>[].obs;
  RxList<String> cancelledRequestIds = <String>[].obs;

  SocketController(this._socketService) {
    initSocket();
  }

  void initSocket() {
    _socketService.connect(
      onOnlineCustomer: (customerId, double latitude, double longitude) {
        Map<String, dynamic> customerData = {
          'customerId': customerId,
          'latitude': latitude,
          'longitude': longitude,
        };
        onlineCustomers.add(customerData);
      },
      onOfflineCustomer: (customerId) {
        onlineCustomers.removeWhere((customer) => customer['customerId'] == customerId);
      },
      onCancel: (customerId) {
        cancelledRequestIds.add(customerId);
      },
    );
  }

  void closeSocket() {
    _socketService.disconnect();
  }

  void addDriver(String driverId, Position location) {
    _socketService.addDriver(driverId, location);
  }

  void removeDriver(String driverId) {
    _socketService.removeDriver(driverId);
  }

  void acceptRide(String driverId, String customerId) {
    _socketService.sendMessage('accept', {'driverId': driverId, 'customerId': customerId});
  }

  void completeRide() {
    _socketService.sendMessage('complete', {});
  }
}
