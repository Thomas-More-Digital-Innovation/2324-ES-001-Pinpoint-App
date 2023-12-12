import 'package:flutter/material.dart';
import 'package:pinpoint_app/api/floorplan_calls.dart';
import 'package:pinpoint_app/screens/pinpoint/floorplan_add.dart';
import 'package:pinpoint_app/models/floorplan.dart'; // Import your Floorplan model
import 'package:pinpoint_app/globals.dart' as globals;

class FloorplanOverview extends StatefulWidget {
  @override
  _FloorplanOverviewState createState() => _FloorplanOverviewState();
}

class _FloorplanOverviewState extends State<FloorplanOverview> {
  late Future<List<Floorplan>> _futureFloorplans;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getFloorplans();
  }

  Future<List<Floorplan>> _getFloorplans() async {
    _futureFloorplans = fetchFloorplanList();
    return _futureFloorplans;
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
                              builder: (context) => const FloorplanAdd(),
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
                  future: _futureFloorplans,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      return ListView(
                        children:
                            snapshot.data!.asMap().entries.map((floorplan) {
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
                                      floorplan.value.image ?? globals.noImage,
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
                                            floorplan.value.name,
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
                                                    "Top Left: ${floorplan.value.topLeftLat}, ${floorplan.value.topLeftLon}"),
                                                Text(
                                                    "Bottom Right: ${floorplan.value.bottomRightLat}, ${floorplan.value.bottomRightLon}"),
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
