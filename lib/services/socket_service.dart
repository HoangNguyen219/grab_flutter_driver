import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:grab_driver_app/models/ride.dart';
import 'package:grab_driver_app/utils/constants/ride_constants.dart';
import 'package:grab_driver_app/utils/constants/socket_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  final String baseUrl;
  late io.Socket socket;

  SocketService(this.baseUrl);

  void connect({Function(Ride ride)? onBook, Function(int)? onCancel, Function(int)? onOfflineCustomer}) {
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

    socket.on(SocketConstants.book, (data) {
      var dataDecode = json.decode(data);
      onBook?.call(Ride.fromJson(dataDecode));
    });

    socket.on(SocketConstants.cancel, (data) {
      var dataDecode = json.decode(data);
      int customerId = dataDecode[RideConstants.customerId];
      onCancel?.call(customerId);
    });

    socket.on(SocketConstants.offlineCustomer, (data) {
      var dataDecode = json.decode(data);
      int customerId = dataDecode[RideConstants.customerId];
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
    _sendMessage(SocketConstants.addDriver, {
      RideConstants.driverId: driverId,
      RideConstants.location: {RideConstants.lat: location.latitude, RideConstants.long: location.longitude}
    });
  }

  void removeDriver(int driverId) {
    _sendMessage(SocketConstants.removerDriver, {RideConstants.driverId: driverId});
  }

  void acceptRide(int driverId, int customerId, Position location) {
    _sendMessage(SocketConstants.accept, {
      RideConstants.driverId: driverId,
      RideConstants.customerId: customerId,
      RideConstants.location: {RideConstants.lat: location.latitude, RideConstants.long: location.longitude}
    });
  }

  void pickRide(int driverId, int customerId) {
    _sendMessage(SocketConstants.pick, {RideConstants.driverId: driverId, RideConstants.customerId: customerId});
  }

  void completeRide(int driverId, int customerId) {
    _sendMessage(SocketConstants.complete, {RideConstants.driverId: driverId, RideConstants.customerId: customerId});
  }

  void changeLocationDriver(int driverId, int customerId, Position location) {
    _sendMessage(SocketConstants.changeLocationDriver, {
      RideConstants.driverId: driverId,
      RideConstants.customerId: customerId,
      RideConstants.location: {RideConstants.lat: location.latitude, RideConstants.long: location.longitude}
    });
  }
}
