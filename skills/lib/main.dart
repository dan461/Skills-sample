import 'package:flutter/material.dart';
import 'package:skills/features/skills/presentation/pages/homeScreen.dart';

void main() => runApp(SkillsApp());

class SkillsApp extends StatefulWidget {
  @override
  _SkillsAppState createState() => _SkillsAppState();
}

class _SkillsAppState extends State<SkillsApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: Colors.lightGreenAccent,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
