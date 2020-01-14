import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skills/core/TickTock.dart';
import 'package:skills/features/skills/data/models/sessionModel.dart';
import 'package:skills/features/skills/domain/entities/session.dart';

void main() {
  SessionModel sut;
  Map<String, dynamic> testMap;

  setUp(() {
    var testDate = DateTime.fromMillisecondsSinceEpoch(0).toUtc();
    var start = TimeOfDay(hour: 12, minute: 0);
    var end = TimeOfDay(hour: 13, minute: 0);
    sut = SessionModel(
        sessionId: 1,
        date: testDate,
        startTime: TimeOfDay(hour: 12, minute: 0),
        endTime: TimeOfDay(hour: 13, minute: 0),
        duration: 60,
        timeRemaining: 60,
        isScheduled: true,
        isComplete: false);

    testMap = {
      'sessionId': 1,
      'date': 0,
      'startTime': TickTock.timeToInt(start),
      'endTime': TickTock.timeToInt(end),
      'duration': 60,
      'timeRemaining': 60,
      'isScheduled': 1,
      'isComplete': 0
    };
  });

  test(
    'should be subclass of Session',
    () async {
      expect(sut, isA<Session>());
    },
  );

  test('fromMap should return a valid SessionModel', () async {
    final result = SessionModel.fromMap(testMap);
    expect(result, sut);
  });

  test('toMap returns a valid map from a SessionModel', () {
    final result = sut.toMap();
    final expectedMap = {
      "sessionId": 1,
      "date": 0,
      "startTime": TickTock.timeToInt(TimeOfDay(hour: 12, minute: 0)),
      "endTime": TickTock.timeToInt(TimeOfDay(hour: 13, minute: 0)),
      "duration": 60,
      "timeRemaining": 60,
      "isScheduled": true,
      "isComplete": false
    };
    expect(result, expectedMap);
  });
}
