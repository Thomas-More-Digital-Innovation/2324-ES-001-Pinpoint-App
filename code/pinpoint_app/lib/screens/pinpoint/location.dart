import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pinpoint_app/api/all_locations.dart';

class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  late Future<List<User>> futureUserList;
  late Timer _timer;
  late StreamSubscription<Position> locationStreamSubscription;
  Position? currentPosition;
  LocationSettings settings = const LocationSettings(
      accuracy: LocationAccuracy.best, distanceFilter: 0);

  final String apiUrl =
      'https://pinpoint-api-poc.syand.workers.dev/'; // API URL

  @override
  void initState() {
    super.initState();
    _initializeData();
    _startContinuousLocationTracking();
    _getPositions();
  }

  Future<void> _initializeData() async {
    futureUserList = fetchUserList();
  }

  void _startContinuousLocationTracking() {
    locationStreamSubscription = Geolocator.getPositionStream(
      locationSettings: settings,
    ).listen((Position position) {
      setState(() {
        currentPosition = position;
        String name = "WERKPLZ";
        postJsonData(name, currentPosition!);
      });
    });
  }

  Future<void> postJsonData(String name, Position pos) async {
    Map<String, dynamic> jsonData = {
      "name": name,
      "lat": pos.latitude,
      "lon": pos.longitude,
    };

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
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

  void _getPositions() {
    // Start the periodic timer
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      futureUserList = fetchUserList();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    // Cancel the location stream subscription when the widget is disposed
    locationStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your location: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (currentPosition != null)
                  Text(currentPosition!.latitude.toString()),
                if (currentPosition != null)
                  Text(currentPosition!.longitude.toString()),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder<List>(
                future: futureUserList,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    List? users = snapshot.data;
                    return ListView.builder(
                      itemCount: users?.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            "${users![index].name}: ",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(users[index].lat.toString()),
                              Text(users[index].lon.toString()),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
