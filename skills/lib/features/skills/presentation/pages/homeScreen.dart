import 'package:flutter/material.dart';
import 'package:skills/features/skills/presentation/widgets/hamburger.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          "Stats",
        ),
        leading: Hamburger(
          parentContext: context,
        ),
      ),
      body: Container(
        child: Center(
            child: Text(
          "Stats",
          style: Theme.of(context).textTheme.headline5,
        )),
        // color: Colors.red,
      ),
    );
  }
}
