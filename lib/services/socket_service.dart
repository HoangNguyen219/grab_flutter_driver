import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  final String baseUrl;
  late io.Socket socket;

  SocketService(this.baseUrl);

  void connect({
    void Function(String, double, double)? onOnlineCustomer,
    Function(String)? onOfflineCustomer,
    Function(String)? onCancel,
  }) {
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
      print("==================================");
      var dataDecode = json.decode(data);
      print(dataDecode);
      // String customerId = dataDecode['customerId'].toString();
      // Map<String, dynamic> locationData = dataDecode['location'];
      // double latitude = locationData['lat'];
      // double longitude = locationData['long'];
      //
      // onOnlineCustomer?.call(customerId, latitude, longitude);
    });

    socket.on('offline-customer', (data) {
      var dataDecode = json.decode(data);
      String customerId = dataDecode['customerId'];
      onOfflineCustomer?.call(customerId);
    });

    socket.on('cancel', (data) {
      var dataDecode = json.decode(data);
      String customerId = dataDecode['customerId'];
      onCancel?.call(customerId);
    });

    socket.connect();
  }

  void disconnect() {
    socket.disconnect();
  }

  void sendMessage(String event, dynamic data) {
    socket.emit(event, json.encode(data));
  }

  void addDriver(String driverId, Position location) {
    sendMessage('add-driver', {
      'driverId': driverId,
      'location': {'lat': location.latitude, 'long': location.longitude}
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
