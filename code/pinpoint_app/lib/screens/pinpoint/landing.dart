import 'package:flutter/material.dart';
import 'package:pinpoint_app/components/button.dart';

class PinpointLanding extends StatelessWidget {
  const PinpointLanding(
      {super.key,
      required this.onButtonPressed});
  final Function() onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonWidget(text: "My Location", onTap: onButtonPressed),
        const SizedBox(
          height: 25,
        ),
        const Text("PinPoint"),
      ],
    ));
  }
}
