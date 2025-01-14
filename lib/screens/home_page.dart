import 'package:flutter/material.dart';
import 'package:lg_task2/components/connection_flag.dart';
import 'package:lg_task2/screens/screen_1.dart';
import 'package:lg_task2/screens/screen_2.dart';

bool ConnectionStatus = false;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: AppBar(
            backgroundColor: const Color.fromARGB(255, 3, 8, 103),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Home', icon: Icon(Icons.home)),
                Tab(text: 'Settings', icon: Icon(Icons.settings)),
              ],
              labelColor: Colors.white, // Color for the selected tab
              unselectedLabelColor:
                  Colors.white70, // Color for the unselected tab
              indicatorColor: Colors.white, // Color of the indicator line
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            Screen1(),
            SettingPage(),
          ],
        ),
      ),
    );
  }
}
