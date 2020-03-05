import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/enums.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/presentation/helpers/sessionChangeMonitor.dart';

void main() {
  SessionChangeMonitor sut;
  Session testSession;

  setUp(() {
    // TODO - update after adding Name to Session
    testSession = Session(
        date: DateTime.utc(2020, 2, 1),
        startTime: TimeOfDay(hour: 12, minute: 0),
        endTime: TimeOfDay(hour: 12, minute: 0),
        duration: 60,
        isScheduled: true,
        isComplete: false);

        sut = SessionChangeMonitor(testSession);
  });

  group('hasChanged - ', (){
    test('test that hasChanged bool is correct when no values have changed', (){
      expect(sut.hasChanged, false);
    });

    test('test that hasChanged bool is correct when a value has been changed',
        () {
      sut.nameText = 'testy';
      expect(sut.hasChanged, true);
    });

    test(
        'test that hasChanged bool is correct when a value has been changed and returned to original value',
        () {
      sut.nameText = 'testy';
      sut.nameText = 'name';
      expect(sut.hasChanged, false);
    });

    test(
        'test that hasChanged bool is correct when multiple values have been changed',
        () {
      sut.nameText = 'testy';
      sut.duration = 45;
      expect(sut.hasChanged, true);
    });

    test(
        'test that hasChanged bool is correct when multiple values have been changed and one has been returned to original',
        () {
      sut.nameText = 'testy';
      sut.duration = 45;
      sut.nameText = 'name';
      expect(sut.hasChanged, true);
    });

    test(
        'test that hasChanged bool is correct when all values have been returned to original after being changed',
        () {
      sut.nameText = 'testy';
      sut.duration = 45;
      sut.nameText = 'name';
      sut.duration = 60;
      expect(sut.hasChanged, false);
    });

    test('test that hasChanged is correct after date has changed', (){
      sut.date = DateTime.utc(2020, 2, 2);
      expect(sut.hasChanged, true);
    });

    test('test that hasChanged is correct after startTime has changed', (){
      sut.startTime = TimeOfDay(hour: 12, minute: 30);
      expect(sut.hasChanged, true);
    });

    test('test that hasChanged is correct after duration has changed', (){
      sut.duration = 45;
      expect(sut.hasChanged, true);
    });

    test('test that hasChanged is correct after isComplete has changed', (){
      sut.isComplete = true;
      expect(sut.hasChanged, true);
    });
  });

  group('toMap - ', (){
    test('test that toMap returns a correct map when Session name has changed', (){
      sut.nameText = 'test';
      Map<String, dynamic> result = sut.toMap();
      expect(result['name'], equals('test'));
    });

    test('test that toMap returns a correct map when Session date has changed', (){
      sut.date = DateTime.utc(2020, 2, 2);
      Map<String, dynamic> result = sut.toMap();
      expect(result['date'], equals(DateTime.utc(2020, 2, 2)));
    });

    test('test that toMap returns a correct map when Session startTime has changed', (){
      sut.startTime = TimeOfDay(hour: 12, minute: 30);
      Map<String, dynamic> result = sut.toMap();
      expect(result['startTime'], equals(TimeOfDay(hour: 12, minute: 30)));
    });

    test('test that toMap returns a correct map when Session duration has changed', (){
      sut.duration = 45;
      Map<String, dynamic> result = sut.toMap();
      expect(result['duration'], equals(45));
    });

    test('test that toMap returns a correct map when Session isComplete has changed', (){
      sut.isComplete = true;
      Map<String, dynamic> result = sut.toMap();
      expect(result['isComplete'], equals(true));
    });

    test('test that toMap returns a startTime value as in int, not a TimeOfDay', (){
      sut.startTime = TimeOfDay(hour: 12, minute: 30);
      Map<String, dynamic> result = sut.toMap();
      expect(result['startTime'], isA<int>());
    });

    test('test that toMap returns a date value as in int, not a DateTime', (){
      sut.date = DateTime.utc(2020, 2, 2);
      Map<String, dynamic> result = sut.toMap();
      expect(result['date'], isA<int>());
    });


  });
}
