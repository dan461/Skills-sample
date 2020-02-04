import 'package:flutter/material.dart';
import 'package:skills/core/tickTock.dart';

abstract class CalendarDataSource {
  CalendarControl calendarControl;
  void dateRangeCallback(List<DateTime> dateRange);
  List calendarEvents;
}

typedef CalendarModeChangeCallback(CalendarMode newMode);
typedef CalendarKeyDateChangeCallback(int change, CalendarMode mode);
typedef CalendarDateRangeChangeCallback(List<DateTime> dateRange);

enum CalendarMode { year, month, week, day }

class CalendarControl {
  CalendarDataSource dataSource;
  CalendarMode currentMode;
  DateTime focusDay;
  DateTime keyDate;
  DateTime selectedDay;
  List<DateTime> eventDates;
  List events;

  CalendarModeChangeCallback modeChangeCallback;
  CalendarKeyDateChangeCallback keyDateChangeCallback;

  CalendarControl({
    this.dataSource,
    @required this.currentMode,
    @required this.focusDay,
    @required this.keyDate,
    this.modeChangeCallback,
  });

  List<DateTime> get dateRange {
    List<DateTime> dates = [];
    switch (currentMode) {
      case CalendarMode.month:
        dates.add(TickTock.firstSunday(keyDate));
        dates.add(TickTock.firstSunday(keyDate).add(Duration(days: 35)));

        break;

      case CalendarMode.week:
        dates.add(TickTock.sundayOfWeek(keyDate));
        dates.add(TickTock.sundayOfWeek(keyDate).add(Duration(days: 7)));
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

    dataSource.dateRangeCallback(dateRange);
  }

  void modeChanged(CalendarMode newMode) {
    currentMode = newMode;

    dataSource.dateRangeCallback(dateRange);
  }
}
