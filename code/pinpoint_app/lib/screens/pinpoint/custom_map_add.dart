import 'package:flutter/material.dart';
import 'package:pinpoint_app/models/map_entry.dart';
import 'package:image_picker/image_picker.dart';

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

  late String _imagePath;

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Select Image'),
            ),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: _topLeftController,
              decoration: InputDecoration(labelText: 'Top Left Coordinate'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _bottomRightController,
              decoration: InputDecoration(labelText: 'Bottom Right'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                final String title = _titleController.text;
                final double cotl = double.parse(_topLeftController.text);
                final double cobr =
                    double.parse(_bottomRightController.text);

                final newMapEntry = MapEntry(
                  imagePath: _imagePath,
                  title: title,
                  cotl: cotl,
                  cobr: cobr,
                );

                widget.onMapEntryCreated(newMapEntry);
                Navigator.pop(context);
              },
              child: Text('Add Map Entry'),
            ),
          ],
        ),
      ),
    );
  }
}
