import 'package:flutter/material.dart';
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
    
  ];

  void _itemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Your Skills')),
      ),
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
      ], currentIndex: _selectedIndex, onTap: _itemTapped),
    );
  }
}