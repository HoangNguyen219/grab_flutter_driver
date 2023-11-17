import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grab_driver_app/common/internet/internet_controller.dart';
import 'package:grab_driver_app/controllers/driver_location_controller.dart';
import 'package:grab_driver_app/controllers/map_controller.dart';
import 'package:grab_driver_app/views/home/widget/google_map_widget.dart';

class HomePage extends StatelessWidget {
  final InternetController internetController = Get.find<InternetController>();
  final DriverLocationController driverLocationController = Get.find<DriverLocationController>();
  final MapController mapController = Get.find<MapController>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final state = internetController.internetState.value;
        if (state == InternetState.InternetLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state == InternetState.InternetConnected) {
          return _buildConnectedUI();
        } else if (state == InternetState.InternetDisconnected) {
          return const Center(child: Text('Check Your Internet Connection.'));
        }
        return const Center(child: Text('Something went wrong!! Please restart the app.'));
      }),
    );
  }

  Widget _buildConnectedUI() {
    return Scaffold(
      // bottomNavigationBar: _buildBottomNavigationBar(),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildMapWidget(),
          // _buildTopBar(),
        ],
      ),
    );
  }

  // Widget _buildBottomNavigationBar() {
  //   return Obx(() {
  //     final driverState = driverLocationController.driverLocationState.value;
  //     if (driverState is DriverLocationInitial ||
  //         driverState is DriverLocationLoading) {
  //       driverLocationController.getDriverLocation();
  //     }
  //     if (driverState is DriverLocationLoaded) {
  //       // Implement your bottom navigation bar UI here
  //       // Use driverState.driverModel for data related to the driver
  //       // Example: return a BottomNavigationBar widget
  //     }
  //     return const SizedBox.shrink();
  //   });
  // }

  Widget _buildMapWidget() {
    return Obx(() {
      final mapState = mapController.mapState.value;
      if (mapState == MapState.MapInitial) {
        return GoogleMapWidget(const {}, const {});
      } else if (mapState == MapState.MapLoading) {
        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 5,
            color: Colors.black45,
          ),
        );
      } else if (mapState == MapState.MapLoaded) {
        return GoogleMapWidget(
          mapController.markers,
          mapController.polylines,
        );
      }
      return GoogleMapWidget(const {}, const {});
    });
  }

// Widget _buildTopBar() {
//   return Positioned(
//     child: Align(
//       alignment: Alignment.topCenter,
//       child: Container(
//         margin: const EdgeInsets.only(top: 30),
//         child: Obx(() {
//           final driverState = driverLocationController.driverLocationState.value;
//           if (driverState is DriverLocationInitial ||
//               driverState is DriverLocationLoading) {
//             driverLocationController.getDriverLocation();
//           }
//           if (driverState is DriverLocationLoaded) {
//             // Implement your top bar UI here using driverState.driverModel
//             // Example: return a row of buttons/icons and driver information
//           }
//           return const CircularProgressIndicator();
//         }),
//       ),
//     ),
//   );
// }
}
