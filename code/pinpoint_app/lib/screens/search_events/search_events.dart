import 'package:flutter/material.dart';
import 'package:pinpoint_app/api/event_controller.dart';
import 'package:pinpoint_app/globals.dart' as globals;
import 'package:pinpoint_app/models/event.dart';
import 'package:pinpoint_app/screens/pinpoint/event_overview.dart';
import 'package:pinpoint_app/screens/pinpoint/custom_map.dart';

class SearchEvents extends StatefulWidget {
  const SearchEvents({Key? key}) : super(key: key);

  @override
  State<SearchEvents> createState() => _SearchEventsState();
}

class _SearchEventsState extends State<SearchEvents> {
  late Future<List<Event>> _futureEvents;

  @override
  void initState() {
    super.initState();
    _getEvents();
  }

  Future<List<Event>> _getEvents() async {
    _futureEvents = fetchEventList();
    return _futureEvents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            FloatingActionButton(
              heroTag: "toMapMenu",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EventOverview(),
                  ),
                );
              },
              backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
              child: const Text("Add Event"),
            ),
            const SizedBox(
              height: 10.0,
            ),
            FutureBuilder(
              future: _futureEvents,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: snapshot.data!.asMap().entries.map((event) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomMap(
                                centerLat: event.value.floorplan?.centerLat,
                                centerLon: event.value.floorplan?.centerLon,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            left: 8.0,
                            right: 8.0,
                          ),
                          margin: const EdgeInsets.only(bottom: 8.0),
                          width: double.infinity,
                          height: 200,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      event.value.image ?? globals.noImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(event.value.title),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
