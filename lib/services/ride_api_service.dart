import 'package:grab_driver_app/utils/constants/ride_constants.dart';

import 'base_api_service.dart';

class RideService extends BaseApiService {
  RideService(super.baseUrl);

  Future<Map<String, dynamic>> acceptRide(int rideId, int driverId) async {
    final Map<String, dynamic> body = {RideConstants.rideId: rideId, RideConstants.driverId: driverId};
    return await postRequest('api/rides/accept', body);
  }

  Future<Map<String, dynamic>> completeRide(int rideId) async {
    final Map<String, dynamic> body = {RideConstants.rideId: rideId};
    return await postRequest('api/rides/complete', body);
  }

  Future<Map<String, dynamic>> pickRide(int rideId) async {
    final Map<String, dynamic> body = {RideConstants.rideId: rideId};
    return await postRequest('api/rides/pick', body);
  }

  Future<Map<String, dynamic>> getRides(int driverId) async {
    return await getRequest('api/rides', parameters: {RideConstants.driverId: driverId.toString()});
  }

  Future<Map<String, dynamic>> getCurrentRides(int driverId) async {
    return await getRequest('api/rides/current', parameters: {RideConstants.driverId: driverId.toString()});
  }
}
