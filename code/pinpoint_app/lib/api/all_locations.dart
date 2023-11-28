import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<User>> fetchUserList() async {
  const String apiUrl =
      'https://pinpoint-api-poc.syand.workers.dev/'; // API URL

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Fetch position
      Iterable positions = jsonDecode(response.body);

      List<User> positionsList =
          positions.map((model) => User.fromJson(model)).toList();

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

class User {
  final String name;
  final double lat;
  final double lon;
  final String timeCreated;

  const User({
    required this.name,
    required this.lat,
    required this.lon,
    required this.timeCreated,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      lat: json['lat'],
      lon: json['lon'],
      timeCreated: json['timeCreated'],
    );
  }
}
