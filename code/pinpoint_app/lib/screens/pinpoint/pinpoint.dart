import 'package:flutter/material.dart';
import 'package:pinpoint_app/screens/pinpoint/landing.dart';
import 'package:pinpoint_app/screens/pinpoint/location.dart';
import 'package:pinpoint_app/screens/pinpoint/custom_map.dart';

class PinPoint extends StatefulWidget {
  const PinPoint({super.key});
  @override
  State<PinPoint> createState() => _PinPointState();
}

class _PinPointState extends State<PinPoint> {
  bool showLocationPage = false;
  bool showMapPage = false;

  @override
  void initState() {
    super.initState();
    // Set both variables to false when the widget is initialized
    showLocationPage = false;
    showMapPage = false;
  }

  void toggleLocationPage() {
    setState(() {
      showLocationPage = !showLocationPage;
    });
  }

  void toggleMapPage() {
    setState(() {
      showMapPage = !showMapPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showLocationPage
          ? const Location()
          : showMapPage
              ? CustomMap(
                  centerLat: 50.967322,
                  centerLon: 4.685438,
                )
              : PinpointLanding(
                  onButtonLocationPressed: toggleLocationPage,
                  onButtonMapPressed: toggleMapPage),
    );
  }
}
