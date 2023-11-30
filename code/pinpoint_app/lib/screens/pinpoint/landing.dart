import 'package:flutter/material.dart';
import 'package:pinpoint_app/components/button.dart';

class PinpointLanding extends StatelessWidget {
  const PinpointLanding(
      {super.key,
      required this.onButtonLocationPressed,
      required this.onButtonMapPressed});
  final Function() onButtonLocationPressed;
  final Function() onButtonMapPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonWidget(text: "My Location", onTap: onButtonLocationPressed),
        const SizedBox(
          height: 25,
        ),
        ButtonWidget(text: "My Map", onTap: onButtonMapPressed),
      ],
    ));
  }
}
