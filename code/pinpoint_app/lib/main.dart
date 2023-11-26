import 'package:flutter/material.dart';
import 'package:pinpoint_app/screens/splash.dart';
import 'package:pinpoint_app/screens/location/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Splash(),
      routes: {
        '/location': (context) => const Location(),
      },
    );
  }
}
