import 'package:flutter/material.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/dbManager.dart';
import 'package:skills/features/skills/presentation/pages/sessionDataScreen.dart';
import 'package:skills/service_locator.dart' as locatorPrefix;
import 'package:skills/service_locator.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

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
  ThemeMode themeMode = ThemeMode.light;
  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = ColorScheme(
    //     primary: Colors.blue,
    //     primaryVariant: Colors.blue[500],
    //     onPrimary: Colors.white,
    //     secondary: Colors.green,
    //     secondaryVariant: Colors.green[500],
    //     onSecondary: Colors.black,
    //     background: Colors.white60,
    //     onBackground: Colors.black,
    //     error: Colors.red,
    //     onError: Colors.white,
    //     surface: Colors.white70,
    //     onSurface: Colors.black,
    //     brightness: Brightness.light);

    // const FlexSchemeData customFlexScheme = FlexSchemeData(
    //   name: 'Toledo purple',
    //   description: 'Purple theme created from custom defined colors.',
    //   light: FlexSchemeColor(
    //     primary: Color(0xFF4E0028),
    //     primaryVariant: Color(0xFF320019),
    //     secondary: Color(0xFF003419),
    //     secondaryVariant: Color(0xFF002411),
    //   ),
    //   dark: FlexSchemeColor(
    //     primary: Color(0xFF9E7389),
    //     primaryVariant: Color(0xFF775C69),
    //     secondary: Color(0xFF738F81),
    //     secondaryVariant: Color(0xFF5C7267),
    //   ),
    // );

    // TextTheme whiteText = Theme.of(context)
    //     .textTheme
    //     .apply(bodyColor: Colors.grey, displayColor: Colors.white);
    // FlexSchemeColor lightColor = FlexSchemeColor(
    //     primary: Color(0xFF9B1B30),
    //     primaryVariant: Color(0xFF6C1322),
    //     secondary: Color(0xFFA70043),
    //     secondaryVariant: Color(0xFFA4121C),
    //     appBarColor: Color(0xFF002411));

    // FlexColorScheme lightScheme = FlexColorScheme.light(colors: lightColor);

    const FlexScheme usedFlexScheme = FlexScheme.hippieBlue;
    return MaterialApp(
      home: DbManager(),
      theme: FlexColorScheme.light(scheme: usedFlexScheme).toTheme,
      darkTheme: FlexColorScheme.dark(scheme: usedFlexScheme).toTheme,
      themeMode: ThemeMode.light,

      // initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == SESSION_DATA_ROUTE) {
          final int newSessionId = settings.arguments;
          SessionDataScreen dataScreen = locator<SessionDataScreen>();
          dataScreen.bloc
              .add(GetSessionAndActivitiesEvent(sessionId: newSessionId));
          return MaterialPageRoute(builder: (context) {
            return dataScreen;
          });
        } else
          return null;
      },
    );
  }
}
