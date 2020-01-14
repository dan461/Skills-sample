import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skills/core/tickTock.dart';

void main() {
  group('changeMonth', () {
    test('test that month is correct after change of 0', () async {
      var startMonth = DateTime(2020, 1);
      var matcher = DateTime(2020, 1);
      var newMonth = TickTock.changeMonth(startMonth, 0);
      expect(newMonth, matcher);
    });

    test('test that month is correct after change of 1', () async {
      var startMonth = DateTime(2020, 1);
      var matcher = DateTime(2020, 2);
      var newMonth = TickTock.changeMonth(startMonth, 1);
      expect(newMonth, matcher);
    });

    test('test that month is correct after change of -1', () async {
      var startMonth = DateTime(2020, 1);
      var matcher = DateTime(2019, 12);
      var newMonth = TickTock.changeMonth(startMonth, -1);
      expect(newMonth, matcher);
    });
  });

  group('TimeOfDay helpers', (){
    
    test('', () async {
      TimeOfDay t1 = TimeOfDay(hour: 12, minute: 30);
      int t1int = TickTock.timeToInt(t1);
      TimeOfDay t2 = TickTock.timeFromInt(t1int);
      bool right = TickTock.timesAreEqual(t1, t2);
      expect(true, right);
    });
  });
  
}
