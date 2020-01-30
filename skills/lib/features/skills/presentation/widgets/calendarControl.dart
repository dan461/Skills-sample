import 'package:flutter/material.dart';
import 'package:skills/core/tickTock.dart';

typedef CalendarModeChangeCallback(CalendarMode newMode);
typedef CalendarKeyDateChangeCallback(int change);

enum CalendarMode { year, month, week, day }

class CalendarControl {
  CalendarMode currentMode;
  DateTime focusDay;
  DateTime keyDate;
  DateTime selectedDay;
  List<DateTime> eventDates;
  CalendarModeChangeCallback modeChangeCallback;
  CalendarKeyDateChangeCallback keyDateChangeCallback;

  CalendarControl(
      {@required this.currentMode,
      @required this.focusDay,
      @required this.keyDate,
      this.modeChangeCallback,
      this.keyDateChangeCallback});

  void changeTimeRange(int change) {
    switch (currentMode) {
      case CalendarMode.month:
        keyDate = TickTock.changeMonth(keyDate, change);
        break;

      case CalendarMode.week:
        bool shift = change == 1 ? true : false;
        keyDate = TickTock.shiftOneWeek(day: keyDate, ahead: shift);
        break;

      default:
    }

    keyDateChangeCallback(change);
  }

  void modeChanged(CalendarMode newMode){
    currentMode = newMode;
    modeChangeCallback(newMode);
  }
}
