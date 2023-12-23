import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinpoint_app/api/event_controller.dart';
import 'package:pinpoint_app/models/event.dart';
import 'package:pinpoint_app/models/floorplan.dart';
import 'package:pinpoint_app/screens/pinpoint/floorplan_add.dart';

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
  Floorplan? _floorplan;

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
            final String startDate = _dateController.text;
            final String endDate = _dateController.text;

            final newEvent = Event(
                title: title,
                description: description,
                startDate: startDate,
                endDate: endDate,
                image: _imagePath,
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
