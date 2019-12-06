import 'package:flutter/material.dart';
import 'package:skills/features/skills/presentation/widgets/calendar.dart';
import 'package:skills/features/skills/presentation/widgets/dayDetails.dart';

class SchedulerScreen extends StatefulWidget {
  @override
  _SchedulerScreenState createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(flex: 2, child: Calendar()),
        // Day Detail
        Expanded(flex: 1, child: DayDetails()),
      ],
    );
  }
}
