import 'package:flutter/material.dart';
import 'package:skills/core/tickTock.dart';

typedef CalendarModeChangeCallback(CalendarMode newMode);
typedef CalendarKeyDateChangeCallback(int change, CalendarMode mode);

enum CalendarMode { year, month, week, day }

class CalendarControl {
  CalendarMode currentMode;
  DateTime focusDay;
  DateTime keyDate;
  DateTime selectedDay;
  List<DateTime> eventDates;
  List events;

  CalendarModeChangeCallback modeChangeCallback;
  CalendarKeyDateChangeCallback keyDateChangeCallback;

  CalendarControl(
      {@required this.currentMode,
      @required this.focusDay,
      @required this.keyDate,
      this.modeChangeCallback,
      this.keyDateChangeCallback}) {
    // dateRange = [];
  }

  List<DateTime> get dateRange {
    List<DateTime> dates = [];
    switch (currentMode) {
      case CalendarMode.month:
        dates.add(TickTock.firstSunday(keyDate));
        dates
            .add(TickTock.firstSunday(keyDate).add(Duration(days: 35)));

        break;

      case CalendarMode.week:
        dates.add(TickTock.sundayOfWeek(keyDate));
        dates
            .add(TickTock.sundayOfWeek(keyDate).add(Duration(days: 7)));
        break;

      case CalendarMode.day:
        dates.first = keyDate;
        break;

      default:
    }

    return dates;
  }

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

    keyDateChangeCallback(change, currentMode);
  }

  void modeChanged(CalendarMode newMode) {
    currentMode = newMode;
    modeChangeCallback(newMode);
  }
}
