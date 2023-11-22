import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grab_driver_app/common/widget/loading_widget.dart';
import 'package:grab_driver_app/controllers/ride_controller.dart';
import 'package:grab_driver_app/models/ride.dart';
import 'package:grab_driver_app/views/history/widget/ride_history_tile_widget.dart';

class RideHistoryPage extends StatelessWidget {
  final RideController rideController = Get.find();

  RideHistoryPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Your Rides"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(() {
          if (rideController.isLoading.value) {
            return const LoadingWidget();
          } else if (rideController.rideHistoryList.isEmpty) {
            return const Center(child: Text("No Ride History Found."));
          } else {
            return _buildListWidget(rideController.rideHistoryList);
          }
        }),
      ),
    );
  }

  Widget _buildListWidget(List<Ride> rideHistoryList) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        itemCount: rideHistoryList.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return RideHistoryTile(ride: rideHistoryList[index]);
        },
      ),
    );
  }
}
