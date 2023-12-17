import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pinpoint_app/screens/home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const Home()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
            decoration: const BoxDecoration(
          gradient: SweepGradient(
              startAngle: 0,
              center: FractionalOffset(0.53, 0.45),
              colors: <Color>[
                Color.fromRGBO(161, 255, 182, 100),
                Color.fromRGBO(255, 255, 255, 1.0),
              ],
              transform: GradientRotation(2.25)),
        )),
        const Center(
            child: Image(
          image: AssetImage('assets/logotext.png'),
          width: 200,
        ))
      ],
    ));
  }
}
