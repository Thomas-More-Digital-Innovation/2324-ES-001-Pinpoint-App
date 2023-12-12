import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pinpoint_app/globals.dart' as globals;

import 'package:pinpoint_app/models/floorplan.dart';

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

