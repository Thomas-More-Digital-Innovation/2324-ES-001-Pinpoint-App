import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pinpoint_app/screens/pinpoint/floorplan_overview.dart';
import 'package:pinpoint_app/models/floorplan.dart';
import 'package:pinpoint_app/api/fetch_floorplans.dart';
import 'package:pinpoint_app/globals.dart' as globals;

class CustomMap extends StatefulWidget {
  final double? centerLat;
  final double? centerLon;

  CustomMap({
    Key? key,
    this.centerLat,
    this.centerLon,
  }) : super(key: key);

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  late Future<List<Floorplan>> _futureFloorplans;
  final String noImage = "assets/no-image.jpg";

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
      body: FlutterMap(
        mapController: MapController(),
        options: MapOptions(
          initialCenter: LatLng(widget.centerLat ?? 51, widget.centerLon ?? 4),
          initialZoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          FutureBuilder(
              future: _futureFloorplans,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return OverlayImageLayer(
                      overlayImages:
                          snapshot.data!.asMap().entries.map((floorplan) {
                    return OverlayImage(
                      bounds: LatLngBounds(
                        LatLng(floorplan.value.topLeftLat,
                            floorplan.value.topLeftLon),
                        LatLng(floorplan.value.bottomRightLat,
                            floorplan.value.bottomRightLon),
                      ),
                      imageProvider: NetworkImage(floorplan.value.image ?? globals.noImage),
                    );
                  }).toList());
                } else {
                  return const CircularProgressIndicator();
                }
              }),
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
