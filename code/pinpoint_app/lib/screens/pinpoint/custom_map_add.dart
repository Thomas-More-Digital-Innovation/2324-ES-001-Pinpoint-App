import 'package:flutter/material.dart';
import 'package:pinpoint_app/models/map_entry.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CustomMapAdd extends StatefulWidget {
  final Function(MapEntry) onMapEntryCreated;

  const CustomMapAdd({super.key, required this.onMapEntryCreated});

  @override
  _CustomMapAddState createState() => _CustomMapAddState();
}

class _CustomMapAddState extends State<CustomMapAdd> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _topLeftController = TextEditingController();
  final TextEditingController _bottomRightController = TextEditingController();

  late String _imagePath = "";

  // Function to handle image selection
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imagePath = pickedImage.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Stack(children: [
                _imagePath != ""
                    ? Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(File(_imagePath)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(color: Colors.grey[900]),
                        child: const Center(
                            child: Icon(Icons.image,
                                size: 350, color: Colors.red)),
                      ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.white, // Change button background color here
                    ),
                    onPressed: _pickImage,
                    child: const Text(
                      'Select Image',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ]),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextFormField(
                    controller: _topLeftController,
                    decoration:
                        const InputDecoration(labelText: 'Top Left Coordinate'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _bottomRightController,
                    decoration: const InputDecoration(labelText: 'Bottom Right Coordinate'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            )),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              final String title = _titleController.text;
              final double cotl = double.parse(_topLeftController.text);
              final double cobr = double.parse(_bottomRightController.text);

              final newMapEntry = MapEntry(
                imagePath: _imagePath,
                title: title,
                cotl: cotl,
                cobr: cobr,
              );

              widget.onMapEntryCreated(newMapEntry);
              Navigator.pop(context);
            },
            backgroundColor: const Color.fromRGBO(30, 30, 30, 1.0),
            child: const Icon(
              Icons.check,
              color: Color.fromRGBO(161, 255, 182, 100),
              size: 35,
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
