import 'package:flutter/material.dart';

enum CalendarMode { year, month, week, day }

class CalendarControl {
  CalendarMode currentMode;
  DateTime focusDay;
  DateTime visiblePeriod;
  DateTime selectedDay;
  List<DateTime> eventDates;
  
  CalendarControl(
      {@required this.currentMode,
      @required this.focusDay,
      @required this.visiblePeriod});
}
