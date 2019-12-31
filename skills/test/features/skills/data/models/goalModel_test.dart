
import 'package:flutter_test/flutter_test.dart';
import 'package:skills/features/skills/data/models/goalModel.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';


void main() {
  GoalModel sut;
  Map<String, dynamic> testMap;

  setUp(() {
    sut = GoalModel(
        id: 1,
        skillId: 1,
        fromDate: DateTime.fromMillisecondsSinceEpoch(0),
        toDate: DateTime.fromMillisecondsSinceEpoch(0),
        timeBased: true,
        isComplete: false,
        goalTime: 60,
        timeRemaining: 60,
        desc: "test");

    testMap = {
      'id': 1,
      'skillId': 1,
      'fromDate': 0,
      'toDate': 0,
      'timeBased': 1,
      'isComplete': 0,
      'goalTime': 60,
      'timeRemaining': 60,
      'desc': "test"
    };
  });
  test(
    'should be subclass of Goal',
    () async {
      expect(sut, isA<Goal>());
    },
  );

  test('fromMap should return a valid GoalModel', () async {
    final result = GoalModel.fromMap(testMap);
    expect(result, sut);
  });

  test('toMap returns a valid map from a GoalModel', () {
    final result = sut.toMap();
    final expectedMap = {
      "id": 1,
      "skillId": 1,
      "fromDate": 0,
      "toDate": 0,
      "timeBased": true,
      "isComplete": false,
      "goalTime": 60,
      "timeRemaining": 60,
      "desc": "test"
    };
    expect(result, expectedMap);
  });
}
