import 'package:flutter/material.dart';
import 'SkillsMasterScreen.dart';
import 'schedulerScreen.dart';
// import 'dataTester.dart';
// import 'dataManager.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // TextStyle textStyle = TextStyle(
    //     color: Theme.of(context).colorScheme.onPrimary,
    //     fontSize: Theme.of(context).textTheme.subtitle2.fontSize);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text("Stats"),
        leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            }),
      ),
      body: Container(
        child: Text("Test!"),
        // color: Colors.red,
      ),
    );
  }
}
