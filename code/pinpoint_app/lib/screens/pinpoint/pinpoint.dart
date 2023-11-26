import 'package:flutter/material.dart';
import 'package:pinpoint_app/components/button.dart';

class PinPoint extends StatelessWidget {
  const PinPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonWidget(text: "My Location", page: "/location"),
          SizedBox(
            height: 25,
          ),
          Text("PinPoint"),
        ],
      )),
    );
  }
}
