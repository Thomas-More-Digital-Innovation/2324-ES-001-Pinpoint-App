import 'package:flutter/material.dart';
import 'package:pinpoint_app/screens/splash.dart';
import 'package:pinpoint_app/screens/location/location.dart';

void main() {
  runApp(MaterialApp(
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const Splash(),
        '/location': (context) => const Location(),
      },
    ));
}
