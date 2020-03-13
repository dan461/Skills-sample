import 'package:flutter/material.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/dbManager.dart';
import 'package:skills/features/skills/presentation/pages/sessionDataScreen.dart';
import 'package:skills/service_locator.dart' as locatorPrefix;
import 'package:skills/service_locator.dart';

import 'features/skills/domain/entities/session.dart';
import 'features/skills/presentation/bloc/sessionDataScreen/sessiondata_bloc.dart';

void main() {
  locatorPrefix.init();
  runApp(
    SkillsApp(),
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
      home: DbManager(),
      theme: ThemeData(
          // brightness: Brightness.dark,
          backgroundColor: Colors.white,
          primaryColor: Colors.blue[800],
          accentColor: Colors.lightGreenAccent,
          // scaffoldBackgroundColor: Colors.blue[800],
          textTheme: Theme.of(context)
              .textTheme
              .copyWith(subhead: new TextStyle(fontWeight: FontWeight.w600))),
      // initialRoute: '/',
      onGenerateRoute: (settings){
        if(settings.name == SESSION_DATA_ROUTE){
          final Session newSession = settings.arguments;
          SessionDataScreen dataScreen = locator<SessionDataScreen>();
          dataScreen.bloc.add(GetActivitiesForSessionEvent(newSession));
          return MaterialPageRoute(builder: (context){
            return dataScreen;
          });
        } else return null;
      },
      
    );
  }
}
