import 'package:flutter/material.dart';

class TickTock {
  static DateTime changeMonth(DateTime month, int change) {
    return DateTime.utc(month.year, month.month + change);
  }

  static DateTime shiftOneWeek({DateTime day, bool ahead}) {
    int change = ahead ? 1 : -1;
    change *= 7;
    return DateTime.utc(day.year, day.month, day.day + change);
  }

  // returns the first Sunday of first week shown on calendar month view
  static DateTime firstSunday(DateTime month) {
    DateTime firstOfMonth = DateTime.utc(month.year, month.month, 1);
    return firstOfMonth.weekday == 7
        ? firstOfMonth
        : firstOfMonth.subtract(Duration(days: firstOfMonth.weekday));
  }

  // returns the DateTime for the Sunday of the week containing given day
  static DateTime sundayOfWeek(DateTime day) {
    DateTime sunday;
    if (day.weekday == 7) {
      sunday = day;
    } else {
      sunday = day.subtract(Duration(days: (day.weekday)));
    }

    return sunday;
  }

// DateTime: In accordance with ISO 8601 a week starts with Monday, which has the value 1.
// Need to return a list that starts with a Sunday, which is weekday = 7
  static List<DateTime> daysOfWeek(DateTime day) {
    List<DateTime> days = [];
    DateTime sunday = sundayOfWeek(day);

    days.add(sunday);
    for (int i = 1; i < 7; i++) {
      DateTime nextDay = sunday.add(Duration(days: i));
      days.add(nextDay);
    }

    assert(days.length == 7, 'Week list length incorrect');
    assert(days.first.weekday == DateTime.sunday,
        'First day in week list not a Sunday');
    assert(days.last.weekday == DateTime.saturday,
        'Last day in week list not a Saturday');

    return days;
  }

  static DateTime today(){
    DateTime today = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    assert(today.hour == 0, 'Hour value for Today is not zero');
    return today;
  }

  // ****** TIME OF DAY ************

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
