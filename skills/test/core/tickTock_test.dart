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
    test('test timeFromInt returns correct time for given integer', () async {
      TimeOfDay matcher = TimeOfDay(hour: 12, minute: 30);
      int t1int = TickTock.timeToInt(matcher);
      TimeOfDay result = TickTock.timeFromInt(t1int);

      expect(result, equals(matcher));
    });

    test(
        'test roundTimeOfDay returns a original time when that time is a multiple of 5',
        () {
      TimeOfDay testTime = TimeOfDay(hour: 12, minute: 15);
      TimeOfDay result = TickTock.roundTimeOfDay(testTime);
      expect(result, equals(testTime));
    });

    test(
        'test roundTimeOfDay returns a time rounded  down to nearest minute that is a multiple of 5',
        () {
      TimeOfDay testTime = TimeOfDay(hour: 12, minute: 13);
      TimeOfDay matcher = TimeOfDay(hour: 12, minute: 10);
      TimeOfDay result = TickTock.roundTimeOfDay(testTime);
      expect(result, equals(matcher));
    });

    test(
        'test roundTimeOfDay returns a time rounded up to nearest minute that is a multiple of 5',
        () {
      TimeOfDay testTime = TimeOfDay(hour: 12, minute: 14);
      TimeOfDay matcher = TimeOfDay(hour: 12, minute: 15);
      TimeOfDay result = TickTock.roundTimeOfDay(testTime);
      expect(result, equals(matcher));
    });

    test(
        'test roundTimeOfDay returns correct rounded time with next hour value',
        () {
      TimeOfDay testTime = TimeOfDay(hour: 11, minute: 58);
      TimeOfDay matcher = TimeOfDay(hour: 12, minute: 0);
      TimeOfDay result = TickTock.roundTimeOfDay(testTime);
      expect(result, equals(matcher));
    });

    test('test roundTimeOfDay returns correct time rounded to closest hour',
        () {
      TimeOfDay testTime = TimeOfDay(hour: 12, minute: 03);
      TimeOfDay matcher = TimeOfDay(hour: 12, minute: 0);
      TimeOfDay result = TickTock.roundTimeOfDay(testTime);
      expect(result, equals(matcher));
    });
  });
}
