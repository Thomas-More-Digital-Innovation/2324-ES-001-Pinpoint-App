import 'package:flutter/material.dart';
import 'package:pinpoint_app/screens/contacts/contacts.dart';
import 'package:pinpoint_app/screens/my_events/my_events.dart';
import 'package:pinpoint_app/screens/overview/overview.dart';
import 'package:pinpoint_app/screens/pinpoint/pinpoint.dart';
import 'package:pinpoint_app/screens/search_events/search_events.dart';

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
        bottomNavigationBar: BottomAppBar(
          height: 70,
          color: const Color.fromRGBO(161, 255, 182, 100),
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navbarIconbutton(() {
                _onItemTapped(0);
              }, Icons.search, _selectedIndex, 0),
              navbarIconbutton(() {
                _onItemTapped(1);
              }, Icons.event, _selectedIndex, 1),
              const SizedBox(width: 20),
              navbarIconbutton(() {
                _onItemTapped(3);
              }, Icons.dashboard, _selectedIndex, 3),
              navbarIconbutton(() {
                _onItemTapped(4);
              }, Icons.people, _selectedIndex, 4)
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "toPinPointMenu",
          backgroundColor: const Color.fromRGBO(50, 50, 50, 1.0),
          onPressed: () {
            _onItemTapped(2);
          },
          child: const Icon(Icons.explore_outlined,
              size: 50, color: Color.fromRGBO(255, 70, 70, 1)),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

IconButton navbarIconbutton(
    Function() onpressed, IconData icon, int index, int widgetIndex) {
  return IconButton(
    onPressed: onpressed,
    icon: Icon(
      icon,
      color: index == widgetIndex
          ? const Color.fromRGBO(30, 30, 30, 1.0)
          : const Color.fromRGBO(
              50, 50, 50, 0.5), // Change color based on selected index
    ),
  );
}