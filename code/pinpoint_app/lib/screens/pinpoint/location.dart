import 'package:flutter/material.dart';
import 'package:pinpoint_app/api/all_locations.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  late Future<List<Position>> futurePositionList;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    futurePositionList = fetchPositionList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List>(
          future: futurePositionList,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              List? positions = snapshot.data;
              return ListView.builder(
                itemCount: positions?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      "${positions![index].name}: ",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(positions[index].lat.toString()),
                        Text(positions[index].lon.toString()),
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
    );
  }
}
