import 'package:flutter/material.dart';
import 'package:pinpoint_app/api/event_controller.dart';
import 'package:pinpoint_app/globals.dart' as globals;
import 'package:pinpoint_app/models/event.dart';
import 'package:pinpoint_app/screens/search_events/event_details.dart';
import 'package:pinpoint_app/screens/search_events/event_overview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchEvents extends StatefulWidget {
  const SearchEvents({Key? key}) : super(key: key);

  @override
  State<SearchEvents> createState() => _SearchEventsState();
}

class _SearchEventsState extends State<SearchEvents> {
  late Future<List<Event>> _futureEvents;
  late List<String> _eventList;
  TextEditingController searchBarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getEvents();
    _getSavedEvents();
  }

  Future<List<Event>> _getEvents() async {
    _futureEvents = fetchEventList();
    return _futureEvents;
  }

  Future<void> _getSavedEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _eventList = prefs.getStringList("savedEvents") ?? [];
  }

  Future<void> _saveEvent(String eventId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var eventList = prefs.getStringList("savedEvents");
    eventList?.add(eventId);
    prefs.setStringList("savedEvents", eventList ?? [eventId]);
    setState(() {
      _getSavedEvents();
    });
  }

  Future<void> _removeSavedEvent(String eventId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var eventList = prefs.getStringList("savedEvents");
    eventList?.remove(eventId);
    prefs.setStringList("savedEvents", eventList ?? []);
    setState(() {
      _getSavedEvents();
    });
  }

  Future<void> _searchForEvent(String startsWith) async {
    setState(() {
      _futureEvents = searchEvent(startsWith);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            FloatingActionButton(
              heroTag: "toAddEvent",
              backgroundColor: const Color.fromRGBO(50, 50, 50, 1.0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EventOverview(),
                  ),
                );
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchBar(
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0)),
                  leading: const Icon(Icons.search),
                  onSubmitted: (value) {
                    _searchForEvent(value);
                  },
                )),
            FutureBuilder(
              future: _futureEvents,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: snapshot.data!.asMap().entries.map((event) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetails(
                                event: event.value,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            left: 8.0,
                            right: 8.0,
                          ),
                          margin: const EdgeInsets.only(bottom: 8.0),
                          width: double.infinity,
                          height: 200,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      event.value.image ?? globals.noImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(event.value.title),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: !_eventList
                                              .contains(event.value.id)
                                          ? GestureDetector(
                                              child: const Icon(
                                                Icons.add,
                                                size: 35,
                                                color: Colors.green,
                                              ),
                                              onTap: () {
                                                _saveEvent(
                                                    event.value.id.toString());
                                              },
                                            )
                                          : GestureDetector(
                                              child: const Icon(
                                                Icons.cancel,
                                                size: 35,
                                                color: Colors.black,
                                              ),
                                              onTap: () {
                                                _removeSavedEvent(
                                                    event.value.id.toString());
                                              },
                                            ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: const Color.fromRGBO(161, 255, 182, 100)));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
