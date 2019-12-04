import 'package:flutter/material.dart';
import 'package:skills/core/dbManager.dart';
import 'package:skills/service_locator.dart' as locator;

void main() {
  locator.init();
  runApp(SkillsApp());
} 

class SkillsApp extends StatefulWidget {
  @override
  _SkillsAppState createState() => _SkillsAppState();
}

class _SkillsAppState extends State<SkillsApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DbManager(),
      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: Colors.lightGreenAccent,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
