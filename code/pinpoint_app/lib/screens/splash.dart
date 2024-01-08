import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pinpoint_app/screens/home.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _rotationAnimation = Tween<double>(
      begin: -90,
      end: 0,
    ).animate(_controller);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.25,
    ).animate(_controller);

    _controller.forward();

    Timer(const Duration(seconds: 2), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const Home(index: 3)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color.fromRGBO(161, 255, 182, 100),
                  Color.fromRGBO(255, 255, 255, 1.0),
                ],
                transform: GradientRotation(0.78),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              return Transform.rotate(
                angle: _rotationAnimation.value * (3.1415927 / 180),
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: const Center(
                    child: Image(
                      image: AssetImage('assets/app_icon.png'),
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}