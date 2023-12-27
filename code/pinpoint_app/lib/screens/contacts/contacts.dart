import 'package:flutter/material.dart';
import 'package:pinpoint_app/api/users_controller.dart';
import 'package:pinpoint_app/models/user.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pinpoint_app/services/user_provider.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  String? uniqueCode;
  bool showQr = false;
  bool showAll = true;

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

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<UserProvider>(context);

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
                  flex: 3,
                  child: Container(
                      color: Colors.red,
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
                                        style: TextStyle(fontSize: 20))),
                                GestureDetector(
                                    onTap: () => toggleShowAllOff(),
                                    child: Text("Add contacts",
                                        style: TextStyle(fontSize: 20)))
                              ],
                            ),
                          ),
                          Expanded(
                              child: showAll
                                  ? FutureBuilder(
                                      future: dataProvider.fetchData(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  'Error: ${snapshot.error}'));
                                        } else {
                                          return YourDataListView(
                                              data: dataProvider.userList);
                                        }
                                      },
                                    )
                                  : Center(child: Text("add users")))
                        ],
                      )),
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

class YourDataListView extends StatelessWidget {
  final List<User> data;

  const YourDataListView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Use the fetched data to display in your UI
    print(data.length);
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(data[index].name),
          // Display other properties accordingly
        );
      },
    );
  }
}
