import 'package:flutter/material.dart';
import 'package:pinpoint_app/models/event.dart';
import 'package:pinpoint_app/screens/pinpoint/custom_map.dart';
import 'package:pinpoint_app/globals.dart' as globals;

class EventDetails extends StatelessWidget {
  final Event event;
  const EventDetails({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
          child: FloatingActionButton(
              child: const Icon(Icons.map),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomMap(
                      centerLat: event.floorplan?.centerLat,
                      centerLon: event.floorplan?.centerLon,
                    ),
                  ),
                );
              }),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Container(
                    alignment: Alignment.bottomLeft,
                    child: Text("Date: ${event.startDate} - ${event.endDate}")),
                Image.network(
                  event.image ?? globals.noImage,
                  fit: BoxFit.cover,
                ),
                Text(
                  event.description ?? "Ther is no Description for this event!",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
