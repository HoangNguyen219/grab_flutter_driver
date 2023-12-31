import 'package:flutter/material.dart';
import 'package:grab_driver_app/models/ride.dart';
import 'package:grab_driver_app/utils/constants/app_constants.dart';
import 'package:intl/intl.dart';

class RideHistoryTile extends StatefulWidget {
  final Ride ride;

  const RideHistoryTile({required this.ride, super.key});

  @override
  State<RideHistoryTile> createState() => _RideHistoryTileState();
}

class _RideHistoryTileState extends State<RideHistoryTile> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: Card(
        elevation: 2.0,
        margin: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        debugPrint('Received click');
                      },
                      style: ButtonStyle(
                        backgroundColor: widget.ride.status == COMPLETED
                            ? MaterialStateProperty.all(Colors.green)
                            : widget.ride.status == IN_PROGRESS
                            ? MaterialStateProperty.all(Colors.orange)
                            : widget.ride.status == CANCELLED
                            ? MaterialStateProperty.all(Colors.red)
                            : MaterialStateProperty.all(Colors.blue),
                      ),
                      child: widget.ride.status == COMPLETED
                          ? const Text(COMPLETED)
                          : widget.ride.status == IN_PROGRESS
                          ? const Text('ONGOING')
                          : widget.ride.status == CANCELLED
                          ? const Text("CANCELLED")
                          : const Text("WAITING"),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Text(DateFormat('dd-MM-yy hh:mm').format(widget.ride.startTime!)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text(
                  widget.ride.startAddress.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                leading: const Icon(Icons.my_location),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text(
                  widget.ride.endAddress.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                leading: const Icon(Icons.location_on_sharp),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _iconWithTitle('${widget.ride.distance} km', Icons.watch_later_outlined),
                  Text("${widget.ride.price} $VND_SIGN"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconWithTitle(String data, IconData iconData) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Icon(
            iconData,
            size: 24,
          ),
        ),
        Text(
          data,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
