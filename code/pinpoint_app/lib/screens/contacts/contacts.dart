import 'package:flutter/material.dart';
import 'package:pinpoint_app/components/button.dart';
import 'package:uuid/uuid.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  String? uniqueCode;

  void _generateUniqueCode() {
    var uuid = const Uuid();
    uniqueCode =
        uuid.v4().substring(0, 6); // Use a portion of the UUID as the code
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 60, bottom: 60, left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonWidget(
                  text: "Generate friend code",
                  onTap: () {
                    _generateUniqueCode();
                    setState(() {});
                  },
                ),
                Text(
                  uniqueCode ?? "No code generated",
                  style: const TextStyle(fontWeight: FontWeight.w300),
                ),
              ],
            ),
            const Text("Contacts"),
          ],
        ),
      ),
    );
  }
}
