import 'package:flutter/material.dart';
import 'package:pinpoint_app/models/map_entry.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MapEntryForm extends StatefulWidget {
  final Function(MapEntry) onMapEntryCreated;

  MapEntryForm({required this.onMapEntryCreated});

  @override
  _MapEntryFormState createState() => _MapEntryFormState();
}

class _MapEntryFormState extends State<MapEntryForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _topLeftController = TextEditingController();
  final TextEditingController _bottomRightController = TextEditingController();

  late String _imagePath = "";

  // Function to handle image selection
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

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
                        child: Center(
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
                    child: Text(
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
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextFormField(
                    controller: _topLeftController,
                    decoration:
                        InputDecoration(labelText: 'Top Left Coordinate'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _bottomRightController,
                    decoration: InputDecoration(labelText: 'Bottom Right Coordinate'),
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
            child: Icon(
              Icons.check,
              color: const Color.fromRGBO(161, 255, 182, 100),
              size: 35,
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
