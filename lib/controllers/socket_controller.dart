import 'package:get/get.dart';
import 'package:grab_driver_app/services/socket_service.dart';

class SocketController extends GetxController {
  final SocketService _socketService;

  SocketController(this._socketService);

  void initSocket(String userId) {
    _socketService.connect(
      userId: userId,
      onMessage: (data) {
        // Handle generic socket messages if needed
      },
    );

    _socketService.socket.on('online-customer', (data) {
      // Handle online customer event
      print('Online Customer: $data');
    });

    _socketService.socket.on('offline-customer', (data) {
      // Handle offline customer event
      print('Offline Customer: $data');
    });

    _socketService.socket.on('cancel', (data) {
      // Handle cancel event
      print('Cancel: $data');
    });
  }

  void closeSocket() {
    _socketService.disconnect();
  }

  void addDriver(String driverId, Map<String, dynamic> location) {
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
