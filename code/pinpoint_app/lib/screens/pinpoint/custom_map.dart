import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pinpoint_app/screens/pinpoint/floorplan_overview.dart';
import 'package:pinpoint_app/models/floorplan.dart';
import 'package:pinpoint_app/api/floorplan_calls.dart';
import 'package:pinpoint_app/globals.dart' as globals;
import 'package:geolocator/geolocator.dart';

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
  MapController mapController = MapController();
  late StreamSubscription<Position> locationStreamSubscription;
  Position? currentPosition;
  LocationSettings settings = const LocationSettings(
      accuracy: LocationAccuracy.best, distanceFilter: 0);

  @override
  void initState() {
    super.initState();
    _startContinuousLocationTracking();
    _getFloorplans();
  }

  Future<List<Floorplan>> _getFloorplans() async {
    _futureFloorplans = fetchFloorplanList();
    return _futureFloorplans;
  }

  Future<bool> _askPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return true;
  }

  void _startContinuousLocationTracking() async {
    try {
      if (await _askPermission()) {
        locationStreamSubscription = Geolocator.getPositionStream(
          locationSettings: settings,
        ).listen((Position position) {
          setState(() {
            currentPosition = position;
          });
        });
      }
    } catch (e) {
      print("There was an excetion in _startContinuousLocationTracking(): $e");
    }
  }

  @override
  void dispose() {
    locationStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: mapController,
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
                      imageProvider: NetworkImage(
                          floorplan.value.image ?? globals.noImage),
                    );
                  }).toList());
                } else {
                  return const CircularProgressIndicator();
                }
              }),
          Padding(
            padding: const EdgeInsets.all(6),
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
                  backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
                  child: const Icon(
                    Icons.map,
                    size: 40,
                    color: Color.fromRGBO(30, 30, 30, 1.0),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: "toMyLocation",
                  onPressed: () {
                    mapController.move(
                        LatLng(
                            currentPosition?.latitude ?? widget.centerLat ?? 51,
                            currentPosition?.longitude ??
                                widget.centerLon ??
                                4),
                        18.0);
                  },
                  backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
                  child: const Icon(
                    Icons.my_location,
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
