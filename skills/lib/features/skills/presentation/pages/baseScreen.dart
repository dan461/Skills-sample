import 'package:flutter/material.dart';
import 'package:skills/features/skills/presentation/pages/skillsMasterScreen.dart';
// import 'SkillsMasterScreen.dart';
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
    SkillsMasterScreen(),
    SchedulerScreen(),
  ];

// ******* rework *************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _menuDrawer(),
      backgroundColor: Theme.of(context).colorScheme.primaryVariant,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (builder, constraints) {
            return _routes[_selectedIndex];
          },
        ),
      ),
    );
  }

  void _menuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop();
  }

  Container _menuDrawer() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      child: Drawer(
        elevation: 8,
        child: Container(
          color: Colors.grey[700],
          width: 60,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Container(
                  child: Center(
                    child: Text("Header"),
                  ),
                ),
              ),
              _menuButton(0, Icons.table_chart),
              _menuButton(1, Icons.list),
              _menuButton(2, Icons.schedule),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuButton(int index, IconData icon) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            _menuItemSelected(index);
          },
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          iconSize: 48,
        ),
      ],
    );
  }
}
