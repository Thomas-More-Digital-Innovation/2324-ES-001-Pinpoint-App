import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Position>> fetchPositionList() async {
  const String apiUrl =
      'https://pinpoint-api-poc.syand.workers.dev/'; // API URL

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Fetch position
      Iterable positions = jsonDecode(response.body);

      List<Position> positionsList =
          positions.map((model) => Position.fromJson(model)).toList();

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

class Position {
  final String name;
  final double lat;
  final double lon;
  final String timeCreated;

  const Position({
    required this.name,
    required this.lat,
    required this.lon,
    required this.timeCreated,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      name: json['name'],
      lat: json['lat'],
      lon: json['lon'],
      timeCreated: json['timeCreated'],
    );
  }
}
