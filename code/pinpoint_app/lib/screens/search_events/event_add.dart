import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinpoint_app/api/event_controller.dart';
import 'package:pinpoint_app/models/event.dart';
import 'package:pinpoint_app/models/floorplan.dart';
import 'package:pinpoint_app/screens/search_events/floorplan_add.dart';

class EventAdd extends StatefulWidget {
  const EventAdd({Key? key}) : super(key: key);

  @override
  EventAddState createState() => EventAddState();
}

class EventAddState extends State<EventAdd> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  late String _imagePath = "";
  late String _bannerImage = "";
  Floorplan? _floorplan;
  late String? _startDate = null;
  late String? _endDate = null;

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
          children: [
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Banner Image",
                              style: TextStyle(fontSize: 16),
                            ),
                            _bannerImage != ""
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 30,
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                final pickedImage = await picker.pickImage(
                                    source: ImageSource.gallery);

                                if (pickedImage != null) {
                                  setState(() {
                                    _bannerImage = pickedImage.path;
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
                                final pickedImage = await picker.pickImage(
                                    source: ImageSource.camera);

                                if (pickedImage != null) {
                                  setState(() {
                                    _bannerImage = pickedImage.path;
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
                        final picked = await showDateRangePicker(
                          context: context,
                          lastDate: DateTime(2101),
                          firstDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _startDate =
                                DateFormat('yyyy/MM/dd').format(picked.start);
                            _endDate =
                                DateFormat('yyyy/MM/dd').format(picked.end);
                            _dateController.text = "$_startDate - $_endDate";
                          });
                        } else {
                          _dateController.text = "";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FloatingActionButton(
                      heroTag: "toMapMenu",
                      onPressed: () async {
                        Floorplan? newFloorplan = await showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              const FloorplanAdd(),
                        );
                        setState(() {
                          _floorplan = newFloorplan;
                        });
                      },
                      backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
                      child: const Icon(
                        Icons.map,
                        size: 40,
                        color: Color.fromRGBO(30, 30, 30, 1.0),
                      ),
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
            final String description = _descriptionController.text;

            final newEvent = Event(
                title: title,
                description: description,
                startDate: _startDate,
                endDate: _endDate,
                image: _imagePath,
                imageBanner: _bannerImage,
                floorplan: _floorplan);
            postNewEvent(newEvent);
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
