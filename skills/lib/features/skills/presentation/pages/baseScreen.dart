import 'package:flutter/material.dart';
import 'skillsScreen.dart';
import 'schedulerScreen.dart';
import 'homeScreen.dart';


class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  static List<Widget> _routes = <Widget>[
    HomeScreen(),
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
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(child: _routes[_selectedIndex]),
      bottomNavigationBar:
          BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Skills',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          label: 'Sched',
        ),
      ], currentIndex: _selectedIndex, onTap: _itemTapped),
    );
  }
}