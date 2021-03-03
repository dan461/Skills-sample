import 'package:flutter/material.dart';
import 'package:skills/core/constants.dart';

class DaysRow extends StatelessWidget {
  List<Widget> _daysBuilder() {
    
    List<Widget> days = [];
    for (var day in DAYS_ABBR) {
      days.add(
        Expanded(
          flex: 1,
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      );
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _daysBuilder()),
    );
  }
}
