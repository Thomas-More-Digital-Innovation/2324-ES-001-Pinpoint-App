import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pinpoint_app/globals.dart' as globals;
import 'package:pinpoint_app/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class EditFriend extends StatefulWidget {
  final User friend;
  late String? name;
  late String? profileImage;
  EditFriend({super.key, required this.friend, this.name, this.profileImage});

  @override
  State<EditFriend> createState() => _EditFriendState();
}

class _EditFriendState extends State<EditFriend> {
  final TextEditingController _nameController = TextEditingController();

  Future<void> _saveFriend(String? name, String? picture) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (name != null) {
      prefs.setString('${widget.friend.id}_name', name);
    }

    if (picture != null && picture.isNotEmpty) {
      late String image;
      final imageResponse = await http.post(
          Uri.parse("${globals.imageUrl}$picture"),
          headers: <String, String>{},
          body: File(picture).readAsBytesSync());
      image = imageResponse.body;
      prefs.setString('${widget.friend.id}_picture', image);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.name != null) {
      _nameController.text = widget.name!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Friend: ${widget.name ?? widget.friend.id}"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "Name: ",
                  style: TextStyle(fontSize: 18),
                ),
                Expanded(
                  child: TextField(
                    controller: _nameController,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Profile Picture",
                      style: TextStyle(fontSize: 16),
                    ),
                    widget.profileImage != ""
                        ? const Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 30,
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final pickedImage =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (pickedImage != null) {
                      setState(() {
                        widget.profileImage = pickedImage.path;
                      });
                    }
                  },
                  child: const Text(
                    'Image from gallery',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final pickedImage =
                        await picker.pickImage(source: ImageSource.camera);

                    if (pickedImage != null) {
                      setState(() {
                        widget.profileImage = pickedImage.path;
                      });
                    }
                  },
                  child: const Text(
                    'Image with camera',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FloatingActionButton(
          heroTag: "saveContactNameAndPicture",
          backgroundColor: const Color.fromRGBO(50, 50, 50, 1.0),
          onPressed: () {
            widget.name = _nameController.text;
            _saveFriend(widget.name, widget.profileImage);
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.save, color: Colors.white),
        ),
        FloatingActionButton(
          heroTag: "exitToOverviewWithoutSaving",
          backgroundColor: const Color.fromRGBO(50, 50, 50, 1.0),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.close, color: Colors.white),
        ),
      ],
    );
  }
}
