import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    return Scaffold(
        body: Padding(
            padding:
                const EdgeInsets.only(top: 60, bottom: 60, left: 30, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: ButtonWidget(
                        text: "My Location",
                        onTap: () {
                          context.go('/map');
                        })),
                const SizedBox(
                  height: 25,
                ),
                Expanded(
                    child: ButtonWidget(
                        text: "My Map", onTap: onButtonMapPressed)),
              ],
            )));
  }
}
