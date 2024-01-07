import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pinpoint_app/globals.dart' as globals;
import 'package:pinpoint_app/models/user.dart';
import 'package:geolocator/geolocator.dart';

Future<List<User>> fetchUserList() async {
  try {
    final response = await http.get(Uri.parse(globals.userUrl));

    if (response.statusCode == 200) {
      // Fetch position
      Iterable positions = jsonDecode(response.body);

      List<User> positionsList = positions.map((model) {
        return User.fromJson(model);
      }).toList();
      return Future.value(positionsList);
    } else {
      print("Request failed with status: ${response.statusCode}");
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print("Request failed with exception: $e");
    throw Exception('Failed to load data');
  }
}

Future<void> postUniqueCode(String uniqueCode, String timeValid) async {
  Map<String, dynamic> jsonData = {
    "id": globals.userId,
    "code": {"value": uniqueCode, "timeValide": timeValid}
  };

  try {
    final response = await http.put(
      Uri.parse(globals.userUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(jsonData),
    );

    if (response.statusCode == 200) {
      print('JSON posted successfully');
    } else {
      print('Failed to post JSON. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error posting JSON: $e');
  }
}

Future<void> postLocation(Position pos) async {
  Map<String, dynamic> jsonData = {
    "id": globals.userId,
    "lat": pos.latitude,
    "lon": pos.longitude,
  };

  try {
    final response = await http.put(
      Uri.parse(globals.userUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(jsonData),
    );

    if (response.statusCode == 200) {
      print('JSON posted successfully');
    } else {
      print('Failed to post JSON. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error posting JSON: $e');
  }
}
