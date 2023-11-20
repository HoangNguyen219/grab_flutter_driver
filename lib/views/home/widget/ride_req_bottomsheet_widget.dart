import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grab_driver_app/common/widget/no_internet_widget.dart';
import 'package:grab_driver_app/controllers/socket_controller.dart';
import 'package:grab_driver_app/views/home/widget/custom_elevated_button.dart';

void rideRequestBottomSheet(BuildContext context, SocketController socketController) {
  showModalBottomSheet(
    isScrollControlled: true,
    barrierColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    context: context,
    builder: (builder) {
      return GetBuilder<SocketController>(
        init: socketController,
        builder: (socketController) {
          if (socketController.onlineCustomers.isEmpty) {
            return const NoInternetWidget(message: "No requests available");
          } else {
            return _buildLoadedUserRequestsList(context, socketController.onlineCustomers);
          }
        },
      );
    },
  );
}

Widget _buildLoadedUserRequestsList(BuildContext context, RxList<Map<String, dynamic>> onlineCustomers) {
  return Container(
    height: MediaQuery.of(context).size.height / 2,
    margin: const EdgeInsets.only(top: 16),
    child: ListView.builder(
      itemCount: onlineCustomers.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return _buildRequestListItem(context, index, onlineCustomers);
      },
    ),
  );
}

Widget _buildRequestListItem(BuildContext context, int index, RxList<Map<String, dynamic>> onlineCustomers) {
  return ListTile(
    title: Text(
      onlineCustomers[index]['customerId'],
      overflow: TextOverflow.ellipsis,
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'source: ${onlineCustomers[index]['latitude']}',
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          'destination: ',
          overflow: TextOverflow.ellipsis,
        )
      ],
    ),
    // leading: Text(
    //   '${tripHistory.tripHistoryModel.tripAmount} \u{20B9}',
    //   style: const TextStyle(fontWeight: FontWeight.bold),
    // ),
    trailing: CustomElevatedButton(
      onPressed: () async {
        // await BlocProvider.of<UserReqCubit>(context).isAccept(tripHistory, true, false);
      },
      text: 'ACCEPT',
    ),
  );
}
//
// Widget _buildDisplayOneRequest(BuildContext context, UserReqDisplayOne state) {
//   BlocProvider.of<GrabMapCubit>(context).drawRoute(state, context);
//
//   return Container(
//     height: MediaQuery.of(context).size.height / 4,
//     margin: const EdgeInsets.only(top: 16),
//     child: ListTile(
//       title: Row(
//         children: [
//           const Icon(Icons.person_pin),
//           Text(' ${state.tripDriver.customerModel.name}'),
//         ],
//       ),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.my_location),
//               Text(' ${state.tripDriver.tripHistoryModel.source}'),
//             ],
//           ),
//           Row(
//             children: [
//               const Icon(Icons.location_on_sharp),
//               Text(' ${state.tripDriver.tripHistoryModel.destination}'),
//             ],
//           ),
//           Row(
//             children: [
//               const Icon(Icons.watch_later_outlined),
//               Text(' ${state.tripDriver.tripHistoryModel.travellingTime}'),
//             ],
//           ),
//           CustomElevatedButton(
//             onPressed: () {
//               if (!state.tripDriver.tripHistoryModel.isCompleted) {
//                 BlocProvider.of<UserReqCubit>(context).isAccept(state.tripDriver, false, false);
//               } else if (state.tripDriver.tripHistoryModel.isCompleted &&
//                   state.tripDriver.tripHistoryModel.isArrived) {
//                 BlocProvider.of<GrabMapCubit>(context).resetMapForNewRide(context);
//                 BlocProvider.of<UserReqCubit>(context).readyForNextRide(false);
//               } else {
//                 BlocProvider.of<UserReqCubit>(context).isAccept(state.tripDriver, false, false);
//               }
//             },
//             text: state.tripDriver.tripHistoryModel.isArrived == false
//                 ? 'ARRIVED'
//                 : state.tripDriver.tripHistoryModel.isCompleted
//                 ? 'ACCEPT PAYMENT'
//                 : 'COMPLETED',
//           ),
//         ],
//       ),
//       leading: Text(
//         '${state.tripDriver.tripHistoryModel.tripAmount} \u{20B9}',
//         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//       ),
//       trailing: GestureDetector(
//         onTap: () async {
//           String? number = state.tripDriver.customerModel.mobile;
//           await FlutterPhoneDirectCaller.callNumber(number!);
//         },
//         child: const CircleAvatar(
//           radius: 25,
//           backgroundColor: Colors.green,
//           foregroundColor: Colors.white,
//           child: Icon(Icons.call),
//         ),
//       ),
//     ),
//   );
// }
