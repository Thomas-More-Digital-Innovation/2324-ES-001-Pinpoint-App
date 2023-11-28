import 'package:flutter/material.dart';
import 'package:pinpoint_app/screens/pinpoint/landing.dart';
import 'package:pinpoint_app/screens/pinpoint/location.dart';

class PinPoint extends StatefulWidget {
  const PinPoint({super.key});

  @override
  State<PinPoint> createState() => _PinPointState();
}

class _PinPointState extends State<PinPoint> {
  bool showPage1 = true;

  void togglePages() {
    setState(() {
      showPage1 = !showPage1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showPage1 ? PinpointLanding(onButtonPressed: togglePages) : const Location(),
    );
  }
}
