import 'package:flutter/material.dart';

class FindsFriends extends StatefulWidget {
  const FindsFriends({super.key});

  @override
  State<FindsFriends> createState() => _FindsFriendsState();
}

class _FindsFriendsState extends State<FindsFriends> {
  final TextEditingController _friendCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Find My Friends"),
      content: TextField(
        controller: _friendCodeController,
      ),
      actions: <Widget>[
        FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
