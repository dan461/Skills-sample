import 'package:flutter/material.dart';

class TickTock {
  static DateTime changeMonth(DateTime month, int change) {
    return DateTime(month.year, month.month + change);
  }

  static double timeToDouble(TimeOfDay time) {
    return time.hour + time.minute / 60;
  }

  static bool timesAreEqual(TimeOfDay time1, TimeOfDay time2) {
    double d1 = timeToDouble(time1);
    double d2 = timeToDouble(time2);
    return d1 == d2;
  }

  static TimeOfDay timeFromInt(int timeInt) {
    int hours = (timeInt / 60).floor();
    return TimeOfDay(hour: hours, minute: timeInt % 60);
  }

  static int timeToInt(TimeOfDay timeOfDay) {
    return (timeOfDay.hour * 60) + timeOfDay.minute;
  }
}

class TimeOfDayEx extends TimeOfDay {
  double get timeAsDouble {
    return (hour + minute / 60);
  }

  double timeToDouble(TimeOfDay time) {
    return time.hour + time.minute / 60;
  }

  bool isEqualTo(TimeOfDay time2) {
    return timeAsDouble == timeToDouble(time2);
  }

  bool isBefore(TimeOfDay time2) {
    return timeAsDouble < timeToDouble(time2);
  }

  bool isAfter(TimeOfDay time2) {
    return timeAsDouble > timeToDouble(time2);
  }
}
