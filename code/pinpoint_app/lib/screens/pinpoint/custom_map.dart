import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pinpoint_app/screens/pinpoint/floorplan_overview.dart';
import 'package:pinpoint_app/models/floorplan.dart';

class MapTryout extends StatelessWidget {
  final double centerLat;
  final double centerLon;

  const MapTryout({
    Key? key,
    required this.centerLat,
    required this.centerLon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: MapController(),
        options: MapOptions(
          initialCenter: LatLng(centerLat, centerLon),
          initialZoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          OverlayImageLayer(
            overlayImages: hardcodedFloorplans.map((floorplan) {
              return OverlayImage(
                bounds: LatLngBounds(
                  LatLng(floorplan.location['topLeft']['lat'],
                      floorplan.location['topLeft']['lon']),
                  LatLng(floorplan.location['bottomRight']['lat'],
                      floorplan.location['bottomRight']['lon']),
                ),
                imageProvider: AssetImage(floorplan.image),
              );
            }).toList(),
          ),
          Padding(
            padding: EdgeInsets.all(6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: "toMapMenu",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FloorplanOverview(),
                      ),
                    );
                  },
                  backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
                  child: const Icon(
                    Icons.map,
                    size: 40,
                    color: Color.fromRGBO(30, 30, 30, 1.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
