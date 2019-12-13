import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skills/features/skills/data/models/sessionModel.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'dart:convert';
import '../../../../fixtures/jsonFixtureReader.dart';

void main() {
  SessionModel sut;

  setUp(() {
    // date is Tuesday, November 27, 2019 12:00:00 AM
    // startTime is Wednesday, November 27, 2019 5:00:00 PM
    // endTime is Wednesday, November 27, 2019 6:00:00 PM
    sut = SessionModel(
        sessionId: 1,
        date: 1574812800,
        startTime: 1574874000,
        endTime: 1574877600,
        duration: 60,
        timeRemaining: 60,
        isScheduled: true,
        isCompleted: false);
  });

  test(
    'should be subclass of Session',
    () async {
      expect(sut, isA<Session>());
    },
  );

  test('fromMap should return a valid SessionModel', () async {
    final Map<String, dynamic> jsonMap = json.decode(fixture('sessionJson.json'));
    final result = SessionModel.fromMap(jsonMap);
    expect(result, sut);
  });

  test('toMap returns a valid map from a SessionModel', (){
    final result = sut.toMap();
    final expectedMap = {
      "sessionId" : 1,
    "date" : 1574812800,
    "startTime" : 1574874000,
    "endTime" : 1574877600,
    "duration" : 60,
    "timeRemaining" : 60,
    "isScheduled" : true,
    "isCompleted" : false
    };
    expect(result, expectedMap);
  });
}
