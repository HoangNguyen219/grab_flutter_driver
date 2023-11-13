import 'base_api_service.dart';

class RideService extends BaseApiService {
  RideService(super.baseUrl);

  Future<Map<String, dynamic>> createBookingNow(Map<String, dynamic> rideData) async {
    return await postRequest('api/rides', rideData);
  }

  Future<Map<String, dynamic>> scheduleBookingLater(Map<String, dynamic> rideData) async {
    return await postRequest('api/rides', rideData);
  }

  Future<Map<String, dynamic>> cancelRide(String rideId) async {
    final Map<String, dynamic> body = {'rideId': rideId};
    return await postRequest('api/rides/cancel', body);
  }

  Future<Map<String, dynamic>> acceptRide(String rideId, String driverId) async {
    final Map<String, dynamic> body = {'rideId': rideId, 'driverId': driverId};
    return await postRequest('api/rides/accept', body);
  }

  Future<Map<String, dynamic>> completeRide(String rideId) async {
    final Map<String, dynamic> body = {'rideId': rideId};
    return await postRequest('api/rides/complete', body);
  }

  Future<Map<String, dynamic>> pickRide(String rideId) async {
    final Map<String, dynamic> body = {'rideId': rideId};
    return await postRequest('api/rides/pick', body);
  }

  Future<List<Map<String, dynamic>>> getRides(String userId, {bool isDriver = false}) async {
    final String queryParam = isDriver ? 'driverId' : 'customerId';
    final response = await getRequest('api/rides', parameters: {queryParam: userId});
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getCurrentRides(String driverId) async {
    final response = await getRequest('api/rides/current', parameters: {'driverId': driverId});
    return List<Map<String, dynamic>>.from(response);
  }
}
