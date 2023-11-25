import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grab_driver_app/common/internet/internet_controller.dart';
import 'package:grab_driver_app/common/widget/loading_widget.dart';
import 'package:grab_driver_app/controllers/auth_controller.dart';
import 'package:grab_driver_app/controllers/driver_controller.dart';
import 'package:grab_driver_app/controllers/map_controller.dart';
import 'package:grab_driver_app/controllers/ride_controller.dart';
import 'package:grab_driver_app/controllers/socket_controller.dart';
import 'package:grab_driver_app/views/history/page/ride_history_page.dart';
import 'package:grab_driver_app/views/home/widget/google_map_widget.dart';
import 'package:grab_driver_app/views/home/widget/is_online_widget.dart';
import 'package:grab_driver_app/views/home/widget/ride_req_bottomsheet_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final InternetController internetController;
  late final AuthController authController;
  late final MapController mapController;
  late final SocketController socketController;
  late final RideController rideController;
  late final DriverController driverController;

  @override
  void initState() {
    super.initState();
    internetController = Get.find();
    authController = Get.find();
    mapController = Get.find();
    socketController = Get.find();
    rideController = Get.find();
    driverController = Get.find();
    if (driverController.driverStatus.value == DriverStatus.online) {
      driverController.setDriverOnline();
    }
  }

  @override
  void dispose() {
    internetController.dispose();
    authController.dispose();
    mapController.dispose();
    socketController.dispose();
    rideController.dispose();
    driverController.dispose();
    super.dispose();
  }

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
        return const Center(child: Text('Something went wrong! Please restart the app.'));
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
              rideController.loadCurrentRide();
              rideRequestBottomSheet(context, socketController, rideController, mapController);
            },
            child: Container(
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(Icons.keyboard_arrow_up),
            ),
          ),
          Text(
            driverController.driverStatus.value == DriverStatus.online ? "You're online" : "You're offline",
            style: const TextStyle(fontSize: 30, color: Colors.blueAccent),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const RideHistoryPage());
            },
            child: Container(
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.history),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapWidget() {
    return Obx(() {
      final mapState = mapController.mapState.value;
      if (mapState == MapState.mapInitial) {
        return const GoogleMapWidget({}, {});
      } else if (mapState == MapState.mapLoading) {
        return const LoadingWidget();
      } else if (mapState == MapState.mapLoaded) {
        return GoogleMapWidget(
          mapController.markers,
          mapController.polylines,
        );
      }
      return const GoogleMapWidget({}, {});
    });
  }

  Widget _buildTopBar() {
    return Positioned(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 30),
          child: Obx(() {
            final isOnline = driverController.driverStatus.value == DriverStatus.online;

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
              ],
            );
          }),
        ),
      ),
    );
  }
}
