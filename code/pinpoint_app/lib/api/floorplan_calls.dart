import 'dart:io';
import 'dart:convert';
import 'package:pinpoint_app/models/floorplan.dart';
import 'package:http/http.dart' as http;
import 'package:pinpoint_app/globals.dart' as globals;

Future<List<Floorplan>> fetchFloorplanList() async {
  try {
    final response = await http.get(Uri.parse(globals.floorplanUrl));

    if (response.statusCode == 200) {
      // Fetch position
      Iterable floorplans = jsonDecode(response.body);

      List<Floorplan> floorplanList =
          floorplans.map((model) => Floorplan.fromJson(model)).toList();

      return Future.value(floorplanList);
    } else {
      print("Request failed with status: ${response.statusCode}");
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print("Request failed with exception: $e");
    throw Exception('Failed to load data');
  }
}

Future<void> postCustomMap(Floorplan newFloorPlan) async {
  try {
    final imageResponse = await http.post(
        Uri.parse("${globals.imageUrl}${newFloorPlan.image}"),
        headers: <String, String>{},
        body: File(newFloorPlan.image!).readAsBytesSync());

    Map<String, dynamic> jsonData = {
      "name": newFloorPlan.name,
      "location": {
        "topLeft": {
          "lat": newFloorPlan.topLeftLat,
          "lon": newFloorPlan.topLeftLon,
        },
        "bottomRight": {
          "lat": newFloorPlan.bottomRightLat,
          "lon": newFloorPlan.bottomRightLon,
        }
      },
      "image": imageResponse.body
    };

    final response = await http.post(
      Uri.parse(globals.floorplanUrl),
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
