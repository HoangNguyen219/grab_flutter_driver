import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:grab_driver_app/models/ride.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  final String baseUrl;
  late io.Socket socket;

  SocketService(this.baseUrl);

  void connect({Function(Ride ride)? onOnlineCustomer, Function(int)? onCancel, Function(int)? onOfflineCustomer}) {
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

    socket.on('online-customer', (data) {
      var dataDecode = json.decode(data);
      if (dataDecode != null && dataDecode is Map<String, dynamic>) {
        int? rideId = dataDecode['rideId'] as int?;
        int? customerId = dataDecode['customerId'] as int?;
        Map<String, dynamic>? startLocation = dataDecode['startLocation'];
        Map<String, dynamic>? endLocation = dataDecode['endLocation'];
        String? startAddress = dataDecode['startAddress'] as String?;
        String? endAddress = dataDecode['endAddress'] as String?;
        double? distance = dataDecode['distance'] as double?;
        int? price = dataDecode['price'] as int?;

        if (rideId != null &&
            customerId != null &&
            startLocation != null &&
            endLocation != null &&
            startAddress != null &&
            endAddress != null &&
            distance != null &&
            price != null) {
          onOnlineCustomer?.call(Ride(
              id: rideId,
              customerId: customerId,
              startLocation: startLocation,
              endLocation: endLocation,
              startAddress: startAddress,
              endAddress: endAddress,
              distance: distance,
              price: price));
        }
      }
    });

    socket.on('cancel', (data) {
      var dataDecode = json.decode(data);
      int customerId = dataDecode['customerId'];
      onCancel?.call(customerId);
    });

    socket.on('offline-customer', (data) {
      var dataDecode = json.decode(data);
      int customerId = dataDecode['customerId'];
      onOfflineCustomer?.call(customerId);
    });

    socket.connect();
  }

  void disconnect() {
    socket.disconnect();
  }

  void _sendMessage(String event, dynamic data) {
    socket.emit(event, json.encode(data));
  }

  void addDriver(int driverId, Position location) {
    _sendMessage('add-driver', {
      'driverId': driverId,
      'location': {'lat': location.latitude, 'long': location.longitude}
    });
  }

  void removeDriver(int driverId) {
    _sendMessage('remove-driver', {'driverId': driverId});
  }

  void acceptRide(int driverId, int customerId) {
    _sendMessage('accept', {'driverId': driverId, 'customerId': customerId});
  }

  void pickRide(int driverId, int customerId) {
    _sendMessage('pick', {'driverId': driverId, 'customerId': customerId});
  }

  void completeRide(int driverId, int customerId) {
    _sendMessage('complete', {'driverId': driverId, 'customerId': customerId});
  }
}
