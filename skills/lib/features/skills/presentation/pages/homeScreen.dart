import 'package:flutter/material.dart';
import 'package:skills/features/skills/presentation/pages/liveSessionScreen.dart';
import 'skillsScreen.dart';
import 'schedulerScreen.dart';
// import 'dataTester.dart';
// import 'dataManager.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _routes = <Widget>[
    SkillsScreen(),
    SchedulerScreen(),
    LiveSessionScreen()
  ];

  void _itemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(child: _routes[_selectedIndex]),
      bottomNavigationBar:
          BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          title: Text('Sched'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.av_timer),
          title: Text('Live Session'),
        ),

      ], currentIndex: _selectedIndex, onTap: _itemTapped),
    );
  }
}
