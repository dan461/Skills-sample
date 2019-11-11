import 'package:flutter/material.dart';
import 'package:skills/features/skills/presentation/widgets/calendar.dart';


class SchedulerScreen extends StatefulWidget {
  @override
  _SchedulerScreenState createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget>[
        Expanded(flex: 2, child: Calendar()),
        // Day Detail
        Container(
          height: height / 4.5,
          child: Center(
            child: Text('Day Details'),
          ),
          color: Colors.red,
        ),
      ],
    );
  }
}
