import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pinpoint_app/screens/pinpoint/custom_map_add.dart';
import 'package:pinpoint_app/models/map_entry.dart';

class MapOverview extends StatefulWidget {
  @override
  _MapOverviewState createState() => _MapOverviewState();
}

class _MapOverviewState extends State<MapOverview> {
  List<MapEntry> _mapEntries = [];

  void _addMapEntry(MapEntry mapEntry) {
    setState(() {
      _mapEntries.add(mapEntry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(30, 30, 30, 1.0),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Map Overview", style: TextStyle(color: Colors.white)),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => {},
                          icon: Icon(
                            Icons.delete,
                            color: Color.fromRGBO(255, 70, 70, 1),
                          )),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapEntryForm(
                                  onMapEntryCreated: _addMapEntry,
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.add,
                            color: const Color.fromRGBO(161, 255, 182, 100),
                          )),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _mapEntries.length,
                itemBuilder: (BuildContext context, int index) {
                  final entry = _mapEntries[index];
                  return Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 209, 209, 209),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: Image.file(
                                  File(entry.imagePath),
                                  fit: BoxFit.cover,
                                  width: 150,
                                  height: 150,
                                )),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Text(entry.title,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700))),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    width: double.infinity,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("CO-TL: ${entry.cotl}"),
                                          Text("CO-BR: ${entry.cobr}")
                                        ]),
                                  ),
                                )
                              ],
                            )),
                          ],
                        ),
                      ));
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
          child: Icon(Icons.arrow_back, color: Colors.white, size: 35),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
