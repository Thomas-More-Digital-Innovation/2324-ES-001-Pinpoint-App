import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(222, 226, 226, 1.0),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w500, fontSize: 22),
            ),
          )),
    );
  }
}
