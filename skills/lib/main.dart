import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skills/core/dbManager.dart';
import 'package:skills/features/skills/presentation/bloc/new_session/bloc.dart';
import 'package:skills/features/skills/presentation/pages/homeScreen.dart';
import 'package:skills/service_locator.dart' as locatorPrefix;
import 'package:skills/service_locator.dart';

void main() {
  locatorPrefix.init();
  runApp( SkillsApp(),
  );
} 

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
