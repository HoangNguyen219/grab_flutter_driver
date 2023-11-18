import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grab_driver_app/common/widget/loading_widget.dart';
import 'package:grab_driver_app/common/widget/no_internet_widget.dart';
import 'package:grab_driver_app/controllers/user_request_controller.dart';

void rideRequestBottomSheet(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    barrierColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    context: context,
    builder: (builder) {
      return GetBuilder<UserRequestController>(
        init: UserRequestController(),
        builder: (userReqController) {
          switch (userReqController.userReqState.value) {
            case UserReqState.initial:
              return const NoInternetWidget(message: "No requests available");
            case UserReqState.loading:
              return const LoadingWidget();
            // case UserReqState.loaded:
            // // If loaded, show your UI for loaded state
            //   return _buildLoadedUserRequestsList(context, ); // Replace with your loaded UI
            // case UserReqState.failure:
            //   return NoInternetWidget(message: userReqController.failureMessage);
            // case UserReqState.displayOne:
            // // If displaying one, show your UI for displaying one
            //   return _buildDisplayOneRequest(); // Replace with your display one UI
            default:
              return const NoInternetWidget(message: 'No requests yet.');
          }
        },
      );
    },
  );
}

// Widget _buildLoadedUserRequestsList(BuildContext context) {
//   return Container(
//     height: MediaQuery.of(context).size.height / 2,
//     margin: const EdgeInsets.only(top: 16),
//     child: state.tripHistoryList.isEmpty
//         ? const NoInternetWidget(message: 'No request available')
//         : ListView.builder(
//       itemCount: state.tripHistoryList.length,
//       shrinkWrap: true,
//       scrollDirection: Axis.vertical,
//       itemBuilder: (context, index) {
//         return _buildRequestListItem(context, state.tripHistoryList[index]);
//       },
//     ),
//   );
// }
//
// Widget _buildRequestListItem(BuildContext context, TripHistory tripHistory) {
//   return ListTile(
//     title: Text(
//       tripHistory.customerModel.name.toString(),
//       overflow: TextOverflow.ellipsis,
//     ),
//     subtitle: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'source: ${tripHistory.tripHistoryModel.source}',
//           overflow: TextOverflow.ellipsis,
//         ),
//         Text(
//           'destination: ${tripHistory.tripHistoryModel.destination}',
//           overflow: TextOverflow.ellipsis,
//         ),
//         Text(
//           'travelling time: ${tripHistory.tripHistoryModel.travellingTime}',
//           overflow: TextOverflow.ellipsis,
//         ),
//       ],
//     ),
//     leading: Text(
//       '${tripHistory.tripHistoryModel.tripAmount} \u{20B9}',
//       style: const TextStyle(fontWeight: FontWeight.bold),
//     ),
//     trailing: CustomElevatedButton(
//       onPressed: () async {
//         await BlocProvider.of<UserReqCubit>(context).isAccept(tripHistory, true, false);
//       },
//       text: 'ACCEPT',
//     ),
//   );
// }
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
