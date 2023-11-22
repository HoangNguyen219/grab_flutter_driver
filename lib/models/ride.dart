class Ride {
  final int? id;
  final String? phone;
  final int? driverId;
  final int? customerId;
  final Map<String, dynamic>? startLocation;
  final Map<String, dynamic>? endLocation;
  final String? startAddress;
  final String? endAddress;
  final DateTime? startTime;
  final DateTime? endTime;
  final String status;
  final double? distance;
  final int? price;

  Ride({
    this.id,
    this.phone,
    this.driverId,
    this.customerId,
    this.startLocation,
    this.endLocation,
    this.startAddress,
    this.endAddress,
    this.startTime,
    this.endTime,
    this.status = "PENDING",
    this.distance,
    this.price,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? startLoc;
    Map<String, dynamic>? endLoc;

    List<String> startLocationValues = (json['startLocation'] as String).split("-");
    double startLat = double.parse(startLocationValues[0]);
    double startLong = double.parse(startLocationValues[1]);
    startLoc = {'lat': startLat, 'long': startLong};

    List<String> endLocationValues = (json['endLocation'] as String).split("-");
    double endLat = double.parse(endLocationValues[0]);
    double endLong = double.parse(endLocationValues[1]);
    endLoc = {'lat': endLat, 'long': endLong};

    return Ride(
      id: json['id'],
      phone: json['phone'],
      driverId: json['driverId'],
      customerId: json['customerId'],
      startLocation: startLoc,
      endLocation: endLoc,
      startAddress: json['startAddress'],
      endAddress: json['endAddress'],
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      status: json['status'],
      distance: json['distance'] != null ? json['distance'].toDouble() : null,
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
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
