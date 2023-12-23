import 'dart:io';
import 'dart:convert';
import 'package:pinpoint_app/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:pinpoint_app/globals.dart' as globals;

Future<List<Event>> fetchEventList() async {
  try {
    final response = await http.get(Uri.parse(globals.eventUrl));

    if (response.statusCode == 200) {
      // Fetch position
      Iterable events = jsonDecode(response.body);

      List<Event> eventList = events.map((model) {
        return Event.fromJson(model);
      }).toList();

      return Future.value(eventList);
    } else {
      print("Request failed with status: ${response.statusCode}");
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print("Request failed with exception: $e");
    throw Exception('Failed to load data');
  }
}

Future<void> postNewEvent(Event newEvent) async {
  try {
    late String image = globals.noImage;
    late String floorplanImage = globals.noImage;

    if (newEvent.image != null && newEvent.image!.isNotEmpty) {
      final imageResponse = await http.post(
          Uri.parse("${globals.imageUrl}${newEvent.image}"),
          headers: <String, String>{},
          body: File(newEvent.image!).readAsBytesSync());
      image = imageResponse.body;
    }

    if (newEvent.floorplan?.image != null &&
        newEvent.floorplan!.image!.isNotEmpty) {
      final floorplanResponse = await http.post(
          Uri.parse("${globals.imageUrl}${newEvent.floorplan?.image}"),
          headers: <String, String>{},
          body: File(newEvent.floorplan!.image!).readAsBytesSync());
      floorplanImage = floorplanResponse.body;
    }

    Map<String, dynamic> jsonData = {
      "title": newEvent.title,
      "description": newEvent.description,
      "startDate": newEvent.startDate,
      "endDate": newEvent.endDate,
      "image": image,
      "floorplan": {
        "location": {
          "topLeft": {
            "lat": newEvent.floorplan?.topLeftLat,
            "lon": newEvent.floorplan?.topLeftLon,
          },
          "bottomRight": {
            "lat": newEvent.floorplan?.bottomRightLat,
            "lon": newEvent.floorplan?.bottomRightLon,
          },
          "image": floorplanImage,
        },
      }
    };

    final response = await http.post(
      Uri.parse(globals.eventUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(jsonData),
    );

    if (response.statusCode == 200) {
      print('Image or JSON posted successfully');
    } else {
      print(
          'Failed to post Image or JSON. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error posting Image or JSON: $e');
  }
}
