import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.text,
    required this.route,
  });

  final String text;
  final String route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {Navigator.pushNamed(context, route)},
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(222, 226, 226, 1.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
