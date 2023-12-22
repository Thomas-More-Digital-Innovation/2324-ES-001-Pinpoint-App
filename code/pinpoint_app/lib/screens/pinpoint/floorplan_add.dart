import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinpoint_app/models/floorplan.dart';
import 'package:pinpoint_app/api/floorplan_calls.dart';

class FloorplanAdd extends StatefulWidget {
  const FloorplanAdd({Key? key}) : super(key: key);

  @override
  FloorplanAddState createState() => FloorplanAddState();
}

class FloorplanAddState extends State<FloorplanAdd> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _topLeftLatController = TextEditingController();
  final TextEditingController _topLeftLonController = TextEditingController();
  final TextEditingController _bottomRightLatController =
      TextEditingController();
  final TextEditingController _bottomRightLonController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

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
                    TextFormField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                    TextField(
                        controller: _dateController,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            labelText: "Enter Date"),
                        readOnly: true, // when true user cannot edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101));
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              _dateController.text =
                                  formattedDate; //set foratted date to TextField value.
                            });
                          } else {
                            _dateController.text = "";
                          }
                        }),
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
              name: title,
              topLeftLat: topLeftLat,
              topLeftLon: topLeftLon,
              bottomRightLat: bottomRightLat,
              bottomRightLon: bottomRightLon,
              image: _imagePath,
            );
            postCustomMap(newFloorplan);
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
