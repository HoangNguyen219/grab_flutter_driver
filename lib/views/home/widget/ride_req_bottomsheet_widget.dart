import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:grab_driver_app/common/widget/no_internet_widget.dart';
import 'package:grab_driver_app/controllers/map_controller.dart';
import 'package:grab_driver_app/controllers/ride_controller.dart';
import 'package:grab_driver_app/controllers/socket_controller.dart';
import 'package:grab_driver_app/utils/constants/app_constants.dart';
import 'package:grab_driver_app/views/home/widget/custom_elevated_button.dart';

void rideRequestBottomSheet(
  BuildContext context,
  SocketController socketController,
  RideController rideController,
  MapController mapController,
) {
  showModalBottomSheet(
    isScrollControlled: true,
    barrierColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    context: context,
    builder: (builder) {
      return Obx(() {
        if (rideController.acceptedRide.value.customerId != null) {
          Future.delayed(Duration.zero, () {
            mapController.drawRoute(rideController.acceptedRide.value, context);
          });
          return _buildDisplayOneRequest(context, rideController, mapController);
        } else if (socketController.rideRequests.isNotEmpty) {
          return _buildLoadedUserRequestsList(context, socketController, rideController);
        } else {
          return const NoInternetWidget(message: "No requests available");
        }
      });
    },
  );
}

Widget _buildLoadedUserRequestsList(
    BuildContext context, SocketController socketController, RideController rideController) {
  return Container(
    height: MediaQuery.of(context).size.height / 2,
    margin: const EdgeInsets.only(top: 16),
    child: ListView.builder(
      itemCount: socketController.rideRequests.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return _buildRequestListItem(context, index, socketController, rideController);
      },
    ),
  );
}

Widget _buildRequestListItem(
    BuildContext context, int index, SocketController socketController, RideController rideController) {
  final rideRequest = socketController.rideRequests[index];
  return ListTile(
    title: Text(
      "${rideRequest.distance} km",
      overflow: TextOverflow.ellipsis,
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'source: ${rideRequest.startAddress}',
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          'destination: ${rideRequest.endAddress}',
          overflow: TextOverflow.ellipsis,
        )
      ],
    ),
    leading: Text(
      ' ${rideRequest.price} $VND_SIGN',
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    trailing: CustomElevatedButton(
      onPressed: () async {
        await rideController.acceptRide(rideRequest);
      },
      text: 'ACCEPT',
    ),
  );
}

Widget _buildDisplayOneRequest(BuildContext context, RideController rideController, MapController mapController) {
  final acceptedRide = rideController.acceptedRide.value;
  return Container(
    height: MediaQuery.of(context).size.height / 4,
    margin: const EdgeInsets.only(top: 16),
    child: ListTile(
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.my_location),
              Text(' ${acceptedRide.startAddress}'),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.location_on_sharp),
              Text(' ${acceptedRide.endAddress}'),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.watch_later_outlined),
              Text(' ${acceptedRide.distance} km'),
            ],
          ),
          CustomElevatedButton(
            onPressed: () {
              if (rideController.rideState.value == RideState.isAccepted) {
                rideController.pickRide(acceptedRide);
              } else {
                rideController.completeRide(acceptedRide);
                rideController.rideState.value = RideState.isReadyForNextRide;
                mapController.resetMapForNewRide(context);
              }
            },
            text: rideController.rideState.value == RideState.isAccepted ? 'ARRIVED' : 'COMPLETED',
          ),
        ],
      ),
      leading: Text(
        '${acceptedRide.price} $VND_SIGN',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      trailing: GestureDetector(
        onTap: () async {
          String? number = acceptedRide.customerId.toString();
          await FlutterPhoneDirectCaller.callNumber(number);
        },
        child: const CircleAvatar(
          radius: 25,
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          child: Icon(Icons.call),
        ),
      ),
    ),
  );
}
