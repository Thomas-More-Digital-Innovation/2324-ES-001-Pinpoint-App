import 'package:flutter/material.dart';
import 'package:pinpoint_app/api/event_controller.dart';
import 'package:pinpoint_app/models/event.dart';
import 'package:pinpoint_app/screens/search_events/event_add.dart';
import 'package:pinpoint_app/globals.dart' as globals;

class EventOverview extends StatefulWidget {
  const EventOverview({super.key});

  @override
  _EventOverviewState createState() => _EventOverviewState();
}

class _EventOverviewState extends State<EventOverview> {
  late Future<List<Event>> _futureEvents;

  @override
  void initState() {
    super.initState();
    _getFloorplans();
  }

  Future<List<Event>> _getFloorplans() async {
    _futureEvents = fetchEventList();
    return _futureEvents;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              width: double.infinity,
              height: 60,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(30, 30, 30, 1.0),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Map Overview",
                      style: TextStyle(color: Colors.white)),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.delete,
                          color: Color.fromRGBO(255, 70, 70, 1),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EventAdd(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Color.fromRGBO(161, 255, 182, 100),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: _futureEvents,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      return ListView(
                        children: snapshot.data!.asMap().entries.map((event) {
                          return Container(
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            width: double.infinity,
                            height: 150,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 209, 209, 209),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: Image.network(
                                      event.value.image ?? globals.noImage,
                                      fit: BoxFit.cover,
                                      width: 150,
                                      height: 150,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            event.value.title,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            width: double.infinity,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "Top Left: ${event.value.floorplan?.topLeftLat}, ${event.value.floorplan?.topLeftLon}"),
                                                Text(
                                                    "Bottom Right: ${event.value.floorplan?.bottomRightLat}, ${event.value.floorplan?.bottomRightLon}"),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          backgroundColor: const Color.fromRGBO(30, 30, 30, 1.0),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 35),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
