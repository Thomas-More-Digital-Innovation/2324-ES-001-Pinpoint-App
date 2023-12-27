import 'package:flutter/material.dart';
import 'package:pinpoint_app/screens/splash.dart';
import 'package:pinpoint_app/services/user_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Righteous'),
        home: const Splash(),
      ),
    );
  }
}
