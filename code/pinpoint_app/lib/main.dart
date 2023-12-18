import 'package:flutter/material.dart';
import 'package:pinpoint_app/screens/home.dart';
import 'package:pinpoint_app/screens/pinpoint/custom_map.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const Home(),
      routes: [
        GoRoute(
          path: 'map',
          builder: (_, __) => CustomMap(),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Righteous'),
      // home: const Splash(),
    );
  }
}
