class Ride {
  final String rideId;
  final String customerId;
  final String driverId;
  final Map<String, dynamic> startLocation;
  final Map<String, dynamic> endLocation;
  final String startAddress;
  final String endAddress;
  final double distance;
  final DateTime scheduleTime;

  Ride({
    required this.rideId,
    required this.customerId,
    required this.driverId,
    required this.startLocation,
    required this.endLocation,
    required this.startAddress,
    required this.endAddress,
    required this.distance,
    required this.scheduleTime,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      rideId: json['rideId'],
      customerId: json['customerId'],
      driverId: json['driverId'],
      startLocation: Map<String, dynamic>.from(json['startLocation']),
      endLocation: Map<String, dynamic>.from(json['endLocation']),
      startAddress: json['startAddress'],
      endAddress: json['endAddress'],
      distance: json['distance'].toDouble(),
      scheduleTime: DateTime.parse(json['scheduleTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rideId': rideId,
      'customerId': customerId,
      'driverId': driverId,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'startAddress': startAddress,
      'endAddress': endAddress,
      'distance': distance,
      'scheduleTime': scheduleTime.toIso8601String(),
    };
  }
}
