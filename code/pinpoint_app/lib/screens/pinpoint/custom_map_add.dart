import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:pinpoint_app/models/floorplan.dart'; // Import your Floorplan model

class CustomMapAdd extends StatefulWidget {
  final Function(Floorplan) onFloorplanCreated;

  const CustomMapAdd({Key? key, required this.onFloorplanCreated})
      : super(key: key);

  @override
  _CustomMapAddState createState() => _CustomMapAddState();
}

class _CustomMapAddState extends State<CustomMapAdd> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _topLeftLatController = TextEditingController();
  final TextEditingController _topLeftLonController = TextEditingController();
  final TextEditingController _bottomRightLatController =
      TextEditingController();
  final TextEditingController _bottomRightLonController =
      TextEditingController();

  late String _imagePath = "";

  // Function to handle image selection
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

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
              child: Stack(
                children: [
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            await _pickImage(ImageSource.gallery);
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
                            await _pickImage(ImageSource.camera);
                          },
                          child: const Text(
                            'Image with camera',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _topLeftLatController,
                            decoration: const InputDecoration(
                                labelText: 'Top Left Latitude'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _topLeftLonController,
                            decoration: const InputDecoration(
                                labelText: 'Top Left Longitude'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _bottomRightLatController,
                            decoration: const InputDecoration(
                                labelText: 'Bottom Right Latitude'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _bottomRightLonController,
                            decoration: const InputDecoration(
                                labelText: 'Bottom Right Longitude'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final String title = _titleController.text;
            final double topLeftLat = double.parse(_topLeftLatController.text);
            final double topLeftLon = double.parse(_topLeftLonController.text);
            final double bottomRightLat =
                double.parse(_bottomRightLatController.text);
            final double bottomRightLon =
                double.parse(_bottomRightLonController.text);

            final newFloorplan = Floorplan(
              id: '', // Add auto-id generator
              name: title,
              location: {
                'topLeft': {'lat': topLeftLat, 'lon': topLeftLon},
                'bottomRight': {'lat': bottomRightLat, 'lon': bottomRightLon},
              },
              image: _imagePath,
            );

            widget.onFloorplanCreated(newFloorplan);
            Navigator.pop(context);
          },
          backgroundColor: const Color.fromRGBO(30, 30, 30, 1.0),
          child: const Icon(
            Icons.check,
            color: Color.fromRGBO(161, 255, 182, 100),
            size: 35,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
