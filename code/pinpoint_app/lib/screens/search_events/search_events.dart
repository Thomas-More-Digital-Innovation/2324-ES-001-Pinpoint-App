import 'package:flutter/material.dart';
import 'package:pinpoint_app/globals.dart';
import 'package:pinpoint_app/models/floorplan.dart';
import 'package:pinpoint_app/screens/pinpoint/custom_map.dart';
import 'package:pinpoint_app/api/floorplan_calls.dart';

class SearchEvents extends StatefulWidget {
  const SearchEvents({super.key});

  @override
  State<SearchEvents> createState() => _SearchEventsState();
}

class _SearchEventsState extends State<SearchEvents> {
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
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
          future: _futureFloorplans,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return ListView(
                  children: snapshot.data!.asMap().entries.map((floorplan) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomMap(
                            centerLat: floorplan.value.centerLat,
                            centerLon: floorplan.value.centerLon),
                      ),
                    );
                  },
                  child: Container(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 8.0, right: 8.0),
                      margin: const EdgeInsets.only(bottom: 8.0),
                      width: double.infinity,
                      height: 200,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100, // Set width and height as needed
                              height: 100,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors
                                    .white, // Set the desired background color
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  floorplan.value.image ?? noImage,
                                  fit: BoxFit
                                      .cover, // Adjust the fit based on your requirement
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(floorplan.value.name)
                          ],
                        ),
                      )),
                );
              }).toList());
            } else {
              return const CircularProgressIndicator();
            }
          }),
    ));
  }
}
