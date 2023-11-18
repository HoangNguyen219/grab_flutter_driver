import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  final String baseUrl;
  late io.Socket socket;

  SocketService(this.baseUrl);

  void connect({Function(dynamic)? onMessage}) {
    socket = io.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.onConnect((_) {
      print('Socket connected');
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
    });

    socket.on('message', (data) {
      if (onMessage != null) {
        onMessage(data);
      }
    });

    socket.on('online-customer', (data) {
      // Handle online customer event
      print('Online Customer: $data');
    });

    socket.on('offline-customer', (data) {
      // Handle offline customer event
      print('Offline Customer: $data');
    });

    socket.on('cancel', (data) {
      // Handle cancel event
      print('Cancel: $data');
    });

    socket.connect();
  }

  void disconnect() {
    socket.disconnect();
  }

  void sendMessage(String event, dynamic data) {
    socket.emit(event, data);
  }

  void addDriver(String driverId, Position location) {
    sendMessage('add-driver', {
      'driverId': driverId,
      'location': {"lat": location.latitude, "long": location.latitude}
    });
  }

  void removeDriver(String driverId) {
    sendMessage('remove-driver', {'driverId': driverId});
  }

  void acceptRide(String driverId, String customerId) {
    sendMessage('accept', {'driverId': driverId, 'customerId': customerId});
  }

  void completeRide() {
    sendMessage('complete', {});
  }
}
