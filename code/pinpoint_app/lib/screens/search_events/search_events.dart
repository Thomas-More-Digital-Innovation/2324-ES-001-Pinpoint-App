import 'package:flutter/material.dart';
import 'package:pinpoint_app/models/floorplan.dart';
import 'package:pinpoint_app/screens/pinpoint/custom_map.dart';

class SearchEvents extends StatelessWidget {
  const SearchEvents({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: hardcodedFloorplans.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Floorplan floorplan = hardcodedFloorplans[index];
                double centerLat =
                    (floorplan.topLeft['lat']! + floorplan.bottomRight['lat']!) / 2;
                double centerLon =
                    (floorplan.topLeft['lon']! + floorplan.bottomRight['lon']!) / 2;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapTryout(
                      centerLat: centerLat,
                      centerLon: centerLon,
                    ),
                  ),
                );
              },
              child: Container(
                  padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  margin: EdgeInsets.only(bottom: 8.0),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
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
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors
                                .white, // Set the desired background color
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              hardcodedFloorplans[index].image,
                              fit: BoxFit
                                  .cover, // Adjust the fit based on your requirement
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(hardcodedFloorplans[index].name)
                      ],
                    ),
                  )),
            );
          },
        ),
      ),
    );
  }
}
