import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skills/core/tickTock.dart';

void main() {
  group('changeMonth', () {
    test('test that month is correct after change of 0', () async {
      var startMonth = DateTime.utc(2020, 1);
      var matcher = DateTime.utc(2020, 1);
      var newMonth = TickTock.changeMonth(startMonth, 0);
      expect(newMonth, matcher);
    });

    test('test that month is correct after change of 1', () async {
      var startMonth = DateTime.utc(2020, 1);
      var matcher = DateTime.utc(2020, 2);
      var newMonth = TickTock.changeMonth(startMonth, 1);
      expect(newMonth, matcher);
    });

    test('test that month is correct after change of -1', () async {
      var startMonth = DateTime.utc(2020, 1);
      var matcher = DateTime.utc(2019, 12);
      var newMonth = TickTock.changeMonth(startMonth, -1);
      expect(newMonth, matcher);
    });
  });

  group('shiftOneWeek: ', () {
    test('test that new date is correct after shifting one week ahead', () {
      var startDate = DateTime.utc(2019, 12, 29);
      var matcher = DateTime.utc(2020, 1, 5);
      var result = TickTock.shiftOneWeek(day: startDate, ahead: true);
      expect(result, matcher);
    });

    test('test that new date is correct after shifting one week back', () {
      var startDate = DateTime.utc(2020, 1, 5);
      var matcher = DateTime.utc(2019, 12, 29);
      var result = TickTock.shiftOneWeek(day: startDate, ahead: false);
      expect(result, matcher);
    });
  });

  test('firstSunday', () async {
    // need activeMonth to get month and year
    DateTime testMonth = DateTime.utc(2020, 1);
    DateTime firstDay = TickTock.firstSunday(testMonth);
    DateTime matcher = DateTime.utc(2019, 12, 29);
    expect(firstDay, matcher);
  });

  test('sundayOfWeek', () {
    DateTime keyDate = DateTime.utc(2020, 1, 15);
    DateTime matcher = DateTime.utc(2020, 1, 12);
    DateTime result = TickTock.sundayOfWeek(keyDate);
    expect(result, matcher);
  });

  test('daysOfWeek', () {
    DateTime testDay = DateTime.utc(2020, 1, 16);
    List<DateTime> result = TickTock.daysOfWeek(testDay);
    List<DateTime> expected = [
      DateTime.utc(2020, 1, 12),
      DateTime.utc(2020, 1, 13),
      DateTime.utc(2020, 1, 14),
      DateTime.utc(2020, 1, 15),
      DateTime.utc(2020, 1, 16),
      DateTime.utc(2020, 1, 17),
      DateTime.utc(2020, 1, 18)
    ];
    expect(result, expected);
  });

  group('TimeOfDay helpers', () {
    test('', () async {
      TimeOfDay t1 = TimeOfDay(hour: 12, minute: 30);
      int t1int = TickTock.timeToInt(t1);
      TimeOfDay t2 = TickTock.timeFromInt(t1int);
      bool right = TickTock.timesAreEqual(t1, t2);
      expect(true, right);
    });
  });
}
