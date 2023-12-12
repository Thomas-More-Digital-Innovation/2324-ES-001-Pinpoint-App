import 'package:flutter/material.dart';
import 'package:pinpoint_app/api/users_controller.dart';
import 'package:pinpoint_app/components/button.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  String? uniqueCode;

  void _generateUniqueCode() {
    var uuid = const Uuid();
    uniqueCode = uuid.v4().substring(0, 6);
    postUniqueCode(uniqueCode!);
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
                uniqueCode != null
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          QrImageView(
                            data: uniqueCode!,
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                          Text(
                            uniqueCode!,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w300),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            const Text("Contacts"),
          ],
        ),
      ),
    );
  }
}
