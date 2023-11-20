import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grab_driver_app/common/internet/internet_controller.dart';
import 'package:grab_driver_app/controllers/driver_controller.dart';
import 'package:grab_driver_app/controllers/map_controller.dart';
import 'package:grab_driver_app/controllers/socket_controller.dart';
import 'package:grab_driver_app/views/home/widget/google_map_widget.dart';
import 'package:grab_driver_app/views/home/widget/is_online_widget.dart';
import 'package:grab_driver_app/views/home/widget/ride_req_bottomsheet_widget.dart';

class HomePage extends StatelessWidget {
  final InternetController internetController = Get.find<InternetController>();
  final DriverController driverController = Get.find();
  final MapController mapController = Get.find();
  final SocketController socketController = Get.find();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final state = internetController.internetState.value;
        if (state == InternetState.InternetLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state == InternetState.InternetConnected) {
          return _buildConnectedUI(context);
        } else if (state == InternetState.InternetDisconnected) {
          return const Center(child: Text('Check Your Internet Connection.'));
        }
        return const Center(child: Text('Something went wrong!! Please restart the app.'));
      }),
    );
  }

  Widget _buildConnectedUI(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(context), // Pass context here
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildMapWidget(),
          _buildTopBar(),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: 90,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 11,
            offset: Offset(3.0, 4.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () {
              rideRequestBottomSheet(context, socketController);
            },
            child: Container(
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(Icons.keyboard_arrow_up),
            ),
          ),
          Text(
            driverController.driverStatus.value == DriverStatus.Online ? "You're online" : "You're offline",
            style: const TextStyle(fontSize: 30, color: Colors.blueAccent),
          ),
          Container(
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.list),
          ),
        ],
      ),
    );
  }

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

  Widget _buildTopBar() {
    return Positioned(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 30),
          child: Obx(() {
            final isOnline = driverController.driverStatus.value == DriverStatus.Online;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IsOnlineWidget(
                  online: isOnline ? "Online" : "Offline",
                  onPressed: () {
                    isOnline ? driverController.setDriverOffline() : driverController.setDriverOnline();
                  },
                ),
                // Add more widgets here if needed
              ],
            );
          }),
        ),
      ),
    );
  }
}

