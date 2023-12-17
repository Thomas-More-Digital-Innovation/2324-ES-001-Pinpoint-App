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
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
        bottomNavigationBar: Container(
          color: const Color.fromRGBO(161, 255, 182, 1.0),
          child: TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: [
                const Tab(icon: Icon(Icons.dashboard)),
                const Tab(icon: Icon(Icons.event)),
                Tab(
                    height: 60,
                    icon: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color.fromRGBO(50, 50, 50, 1.0),
                      ),
                      child: const Icon(Icons.explore_outlined,
                          size: 50, color: Color.fromRGBO(255, 70, 70, 1)),
                    )),
                const Tab(icon: Icon(Icons.search)),
                const Tab(icon: Icon(Icons.people)),
              ]),
        ),
        body: const TabBarView(
          children: [
            Overview(),
            MyEvents(),
            PinPoint(),
            SearchEvents(),
            Contacts(),
          ],
        ),
      ),
    );
  }
}
