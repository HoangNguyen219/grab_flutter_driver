import 'package:grab_driver_app/utils/constants/app_constants.dart';
import 'package:grab_driver_app/utils/constants/ride_constants.dart';

class Ride {
  final int? id;
  final int? driverId;
  final int? customerId;
  final Map<String, dynamic>? startLocation;
  final Map<String, dynamic>? endLocation;
  final String? startAddress;
  final String? endAddress;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? status;
  final double? distance;
  final double? price;

  Ride({
    this.id,
    this.driverId,
    this.customerId,
    this.startLocation,
    this.endLocation,
    this.startAddress,
    this.endAddress,
    this.startTime,
    this.endTime,
    this.status,
    this.distance,
    this.price,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? startLoc;
    Map<String, dynamic>? endLoc;

    if (json[RideConstants.startLocation] is String) {
    List<String> startLocationValues =
        (json[RideConstants.startLocation] as String).split(RideConstants.splitCharacter);
    double startLat = double.parse(startLocationValues[0]);
    double startLong = double.parse(startLocationValues[1]);
    startLoc = {RideConstants.lat: startLat, RideConstants.long: startLong};
    } else if (json[RideConstants.startLocation] is Map<String, dynamic>) {
      startLoc = Map<String, dynamic>.from(json[RideConstants.startLocation]);
    }

    if (json[RideConstants.endLocation] is String) {
      List<String> endLocationValues = (json[RideConstants.endLocation] as String).split(RideConstants.splitCharacter);
      double endLat = double.parse(endLocationValues[0]);
      double endLong = double.parse(endLocationValues[1]);
      endLoc = {RideConstants.lat: endLat, RideConstants.long: endLong};
    }
    else if (json[RideConstants.endLocation] is Map<String, dynamic>) {
      endLoc = Map<String, dynamic>.from(json[RideConstants.endLocation]);
    }

    return Ride(
      id: json[ID],
      driverId: json[RideConstants.driverId],
      customerId: json[RideConstants.customerId],
      startLocation: startLoc,
      endLocation: endLoc,
      startAddress: json[RideConstants.startAddress],
      endAddress: json[RideConstants.endAddress],
      startTime: json[RideConstants.startTime] != null ? DateTime.parse(json[RideConstants.startTime]) : null,
      endTime: json[RideConstants.endTime] != null ? DateTime.parse(json[RideConstants.endTime]) : null,
      status: json[RideConstants.status],
      distance: json[RideConstants.distance]?.toDouble(),
      price: json[RideConstants.price]?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverId': driverId,
      'customerId': customerId,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'startAddress': startAddress,
      'endAddress': endAddress,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'status': status,
      'distance': distance,
      'price': price,
    };
  }
}
