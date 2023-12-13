import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pinpoint_app/screens/pinpoint/custom_map_add.dart';
import 'package:pinpoint_app/models/floorplan.dart'; // Import your Floorplan model

class CustomMapOverview extends StatefulWidget {
  @override
  _CustomMapOverviewState createState() => _CustomMapOverviewState();
}

class _CustomMapOverviewState extends State<CustomMapOverview> {
  List<Floorplan> _floorplans = [];

  void _addFloorplan(Floorplan floorplan) {
    setState(() {
      _floorplans.add(floorplan);
    });
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
                        onPressed: () {
                          setState(() {
                            _floorplans.clear();
                          });
                        },
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
                              builder: (context) => CustomMapAdd(
                                onFloorplanCreated: _addFloorplan,
                              ),
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
              child: ListView.builder(
                itemCount: _floorplans.length,
                itemBuilder: (BuildContext context, int index) {
                  final floorplan = _floorplans[index];
                  return Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    width: double.infinity,
                    height: 150,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 209, 209, 209),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: Image.file(
                              File(floorplan.image),
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    floorplan.name,
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
                                            "Top Left: ${floorplan.topLeft['lat']}, ${floorplan.topLeft['lon']}"),
                                        Text(
                                            "Bottom Right: ${floorplan.bottomRight['lat']}, ${floorplan.bottomRight['lon']}"),
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
                },
              ),
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
