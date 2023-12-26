import 'package:flutter/material.dart';
import 'package:pinpoint_app/api/users_controller.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  String? uniqueCode;
  bool showQr = false;

  void _generateUniqueCode() {
    var uuid = const Uuid();
    uniqueCode = uuid.v4().substring(0, 6);
    postUniqueCode(uniqueCode!);
  }

  void toggleShowQr() {
    setState(() {
      uniqueCode != null ? showQr = !showQr : showQr = showQr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Container(
                //   alignment: Alignment.topRight,
                //   child: GestureDetector(
                //       onTap: () {
                //         showDialog(
                //           context: context,
                //           builder: (BuildContext context) => const FindsFriends(),
                //         );
                //       },
                //       child: Icon(
                //         size: 50,
                //         color: Colors.green[800],
                //         Icons.person_add_alt_1_sharp,
                //       )),
                // ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.green,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    uniqueCode != null
                                        ? uniqueCode!
                                        : "Generate new code",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.copy),
                                    onPressed: () async {
                                      await Clipboard.setData(
                                          ClipboardData(text: uniqueCode!));
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.qr_code),
                                    onPressed: () => toggleShowQr(),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () {
                              _generateUniqueCode();
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.red,
                  ),
                  flex: 3,
                )
              ],
            ),
            Center(
              child: Container(
                width: 300,
                height: 300,
                child: (showQr && uniqueCode != null)
                    ? AlertDialog(
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              QrImageView(
                                data: uniqueCode!,
                                version: QrVersions.auto,
                                size: 100.0,
                              ),
                              Text(
                                uniqueCode!,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w300),
                              ),
                              IconButton(
                                onPressed: () => toggleShowQr(),
                                icon: Icon(Icons.close),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
