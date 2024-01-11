import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pinpoint_app/api/users_controller.dart';
import 'package:pinpoint_app/models/user.dart';
import 'package:pinpoint_app/screens/contacts/edit_friend.dart';
import 'package:pinpoint_app/screens/pinpoint/custom_map.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

const List<String> list = <String>['24h', '48h', 'never'];

class _ContactsState extends State<Contacts> {
  late Future<List<User>> _userList;
  String? uniqueCode;
  bool showQr = false;
  bool showAll = true;

  String dropdownValue = list.first;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  Future<List<User>> _getUsers() async {
    _userList = fetchUserList();
    return _userList;
  }

  void _generateUniqueCode() {
    var uuid = const Uuid();
    uniqueCode = uuid.v4().substring(0, 6);
    postUniqueCode(uniqueCode!, dropdownValue);
  }

  void toggleShowQr() {
    setState(() {
      uniqueCode != null ? showQr = !showQr : showQr = showQr;
    });
  }

  void toggleShowAllOn() {
    setState(() {
      showAll = true;
    });
  }

  void toggleShowAllOff() {
    setState(() {
      showAll = false;
    });
  }

  Future<Map<String, String>> _getFriendInfo(String friendId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String friendName = prefs.getString('${friendId}_name') ?? '';
    String friendPicture = prefs.getString('${friendId}_picture') ?? '';

    return {'name': friendName, 'picture': friendPicture};
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
                                  Expanded(
                                    child: Text(
                                      uniqueCode != null
                                          ? uniqueCode!
                                          : "Generate new code",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: const Icon(Icons.arrow_downward),
                                    onChanged: (String? value) {
                                      // This is called when the user selects an item.
                                      setState(() {
                                        dropdownValue = value!;
                                      });
                                    },
                                    items: list.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.copy),
                                    onPressed: uniqueCode != null
                                        ? () async {
                                            await Clipboard.setData(
                                                ClipboardData(
                                                    text: uniqueCode!));
                                          }
                                        : () {},
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.qr_code),
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
                  flex: 3,
                  child: Container(
                      color: const Color.fromRGBO(222, 226, 226, 1.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                    onTap: () => toggleShowAllOn(),
                                    child: Text("All contacts",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: showAll
                                                ? Colors.black
                                                : Colors.grey))),
                                GestureDetector(
                                    onTap: () => toggleShowAllOff(),
                                    child: Text("Add contacts",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: !showAll
                                                ? Colors.black
                                                : Colors.grey)))
                              ],
                            ),
                          ),
                          showAll
                              ? Container(
                                  padding: const EdgeInsets.all(8.0),
                                  width: double.infinity,
                                  height: 70,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                      hintText: 'Enter text',
                                      // Add any other necessary styling or properties
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          Expanded(
                              child: showAll
                                  ? FutureBuilder(
                                      future: _userList,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.connectionState ==
                                                ConnectionState.done) {
                                          return ListView(
                                              children: snapshot.data!
                                                  .asMap()
                                                  .entries
                                                  .map((user) {
                                            return Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                width: double.infinity,
                                                height: 60,
                                                color: const Color.fromRGBO(
                                                    50, 50, 50, 1.0),
                                                child: Row(children: [
                                                  FutureBuilder<
                                                      Map<String, String>>(
                                                    future: _getFriendInfo(
                                                        user.value.id),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        String friendName =
                                                            snapshot.data?[
                                                                    'name'] ??
                                                                '';
                                                        String friendPicture =
                                                            snapshot.data?[
                                                                    'picture'] ??
                                                                '';

                                                        // Use a conditional expression to decide what to display
                                                        Widget displayWidget = friendName
                                                                    .isNotEmpty &&
                                                                friendPicture
                                                                    .isNotEmpty
                                                            ? Row(
                                                                children: [
                                                                  CircleAvatar(
                                                                    backgroundImage:
                                                                        NetworkImage(
                                                                            friendPicture), // Assuming friendPicture is the URL
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          8), // Adjust spacing as needed
                                                                  Text(
                                                                    friendName,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ],
                                                              )
                                                            : friendName.isNotEmpty &&
                                                                    friendPicture
                                                                        .isEmpty
                                                                ? Text(
                                                                    friendName,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  )
                                                                : Text(
                                                                    user.value
                                                                        .id,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  );

                                                        // Wrap the Text widget with Expanded
                                                        return Expanded(
                                                          child: displayWidget,
                                                        );
                                                      } else {
                                                        // You can return a loading indicator or an empty container while waiting
                                                        return CircularProgressIndicator();
                                                      }
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.location_on,
                                                        color: Color.fromRGBO(
                                                            255, 70, 70, 1)),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              CustomMap(
                                                            centerLat:
                                                                user.value.lat,
                                                            centerLon:
                                                                user.value.lon,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.edit,
                                                        color: Color.fromRGBO(
                                                            161,
                                                            255,
                                                            182,
                                                            100)),
                                                    onPressed: () async {
                                                      Map<String, String>
                                                          friendInfo =
                                                          await _getFriendInfo(
                                                              user.value.id);

                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            EditFriend(
                                                          name: friendInfo[
                                                                  'name'] ??
                                                              '',
                                                          profileImage: friendInfo[
                                                                  'picture'] ??
                                                              '',
                                                          friend: user.value,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.delete),
                                                    onPressed: () {},
                                                  ),
                                                ])
                                                // Display other properties accordingly
                                                );
                                          }).toList());
                                        } else {
                                          return const Center(
                                              child: CircularProgressIndicator(
                                                  color: Color.fromRGBO(
                                                      255, 70, 70, 1)));
                                        }
                                      })
                                  : Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          width: double.infinity,
                                          height: 70,
                                          child: TextField(
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                              ),
                                              hintText:
                                                  'Enter new contact code',
                                              // Add any other necessary styling or properties
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 5,
                                              child: QRView(
                                                key: qrKey,
                                                onQRViewCreated:
                                                    _onQRViewCreated,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Center(
                                                child: (result != null)
                                                    ? Text(
                                                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                                                    : Text('Scan a code'),
                                              ),
                                            )
                                          ],
                                        )),
                                      ],
                                    ))
                        ],
                      )),
                )
              ],
            ),
            Center(
              child: SizedBox(
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
                                "${uniqueCode!} - $dropdownValue",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w300),
                              ),
                              IconButton(
                                onPressed: () => toggleShowQr(),
                                icon: const Icon(Icons.close),
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
