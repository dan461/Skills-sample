import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:skills/features/skills/data/models/goalModel.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';

import '../../../../fixtures/jsonFixtureReader.dart';

void main() {
  GoalModel sut;

  setUp(() {
    sut = GoalModel(
        id: 1,
        skillId: 1,
        fromDate: 1574899200,
        toDate: 1574812800,
        timeBased: true,
        isComplete: false,
        goalTime: 60,
        timeRemaining: 60,
        desc: "test");
  });
  test(
    'should be subclass of Goal',
    () async {
      expect(sut, isA<Goal>());
    },
  );

  test('fromMap should return a valid GoalModel', () async {
    final Map<String, dynamic> jsonMap = json.decode(fixture('goalJson.json'));
    final result = GoalModel.fromMap(jsonMap);
    expect(result, sut);
  });

  test('toMap returns a valid map from a GoalModel', () {
    final result = sut.toMap();
    final expectedMap = {
      "id": 1,
      "skillId": 1,
      "fromDate": 1574899200,
      "toDate": 1574812800,
      "timeBased": true,
      "isComplete": false,
      "goalTime": 60,
      "timeRemaining": 60,
      "desc": "test"
    };
    expect(result, expectedMap);
  });
}
