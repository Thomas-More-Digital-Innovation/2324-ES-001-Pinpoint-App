import 'package:flutter/material.dart';
import 'package:pinpoint_app/screens/contacts/contacts.dart';
import 'package:pinpoint_app/screens/my_events/my_events.dart';
import 'package:pinpoint_app/screens/overview/overview.dart';
import 'package:pinpoint_app/screens/pinpoint/pinpoint.dart';
import 'package:pinpoint_app/screens/search_events/search_events.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    SearchEvents(),
    MyEvents(),
    PinPoint(),
    Overview(),
    Contacts(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromRGBO(222, 226, 226, 1.0),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 20),
              label: "Search",
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event, size: 20),
              label: 'My Events',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined, size: 50),
              label: "",
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard, size: 20),
              label: 'Overview',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people, size: 20),
              label: 'People',
              backgroundColor: Colors.black,
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color.fromRGBO(0, 0, 0, 1.0),
          unselectedItemColor: const Color.fromRGBO(0, 0, 0, 0.3),
          onTap: _onItemTapped,
        ),
      ),
    ));
  }
}
