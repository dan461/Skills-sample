import 'package:flutter_test/flutter_test.dart';
import 'package:skills/features/skills/data/models/goalModel.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';

void main() {
  GoalModel sut;
  Map<String, dynamic> testMap;

  setUp(() {
    sut = GoalModel(
        goalId: 1,
        skillId: 1,
        fromDate: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
        toDate: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
        timeBased: true,
        isComplete: false,
        goalTime: 60,
        goalText: 'None',
        timeRemaining: 60,
        desc: "test");

    testMap = {
      'goalId': 1,
      'skillId': 1,
      'fromDate': 0,
      'toDate': 0,
      'timeBased': 1,
      'isComplete': 0,
      'goalTime': 60,
      'goalText': 'None',
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
      "goalId": 1,
      "skillId": 1,
      "fromDate": 0,
      "toDate": 0,
      "timeBased": true,
      "isComplete": false,
      "goalTime": 60,
      'goalText': 'None',
      "timeRemaining": 60,
      "desc": "test"
    };
    expect(result, expectedMap);
  });

  group('testing translation of a goal to a descriptive string', () {
    test(
        'test translation of a time based goal into a descriptive string, with hours and minutes.',
        () {
      DateTime from = DateTime(2019, 07, 02);
      DateTime to = DateTime(2019, 07, 04);

      final testTimeGoal = Goal(
          skillId: 1,
          fromDate: from,
          toDate: to,
          isComplete: false,
          timeBased: true,
          goalTime: 330);

      String matcher = "Goal: 5 hrs 30 min between Jul 2 and Jul 4.";
      String translation = GoalModel.translateGoal(testTimeGoal);

      expect(translation, matcher);
    });

    test(
        'test translation of a time based goal into a descriptive string, with one hour and no minutes.',
        () {
      DateTime from = DateTime(2019, 07, 02);
      DateTime to = DateTime(2019, 07, 04);

      final testTimeGoal = Goal(
          skillId: 1,
          fromDate: from,
          toDate: to,
          isComplete: false,
          timeBased: true,
          goalTime: 60);

      String matcher = "Goal: 1 hour between Jul 2 and Jul 4.";
      String translation = GoalModel.translateGoal(testTimeGoal);

      expect(translation, matcher);
    });

    test(
        'test translation of a time based goal into a descriptive string, with less than one hour.',
        () {
      DateTime from = DateTime(2019, 07, 02);
      DateTime to = DateTime(2019, 07, 04);

      final testTimeGoal = Goal(
          skillId: 1,
          fromDate: from,
          toDate: to,
          isComplete: false,
          timeBased: true,
          goalTime: 15);

      String matcher = "Goal: 15 minutes between Jul 2 and Jul 4.";
      String translation = GoalModel.translateGoal(testTimeGoal);

      expect(translation, matcher);
    });

    test(
        'test translation of a time based goal with multiple hours and zero minutes into a descriptive string.',
        () {
      DateTime from = DateTime(2019, 07, 02);
      DateTime to = DateTime(2019, 07, 04);

      final testTimeGoal = Goal(
          skillId: 1,
          fromDate: from,
          toDate: to,
          isComplete: false,
          timeBased: true,
          goalTime: 120);

      String matcher = "Goal: 2 hrs between Jul 2 and Jul 4.";
      String translation = GoalModel.translateGoal(testTimeGoal);

      expect(translation, matcher);
    });

    test(
        'test translation of a time based goal into a descriptive string, start and end on same day.',
        () {
      DateTime from = DateTime(2019, 07, 02);
      DateTime to = DateTime(2019, 07, 02);

      final testTimeGoal = Goal(
          skillId: 1,
          fromDate: from,
          toDate: to,
          isComplete: false,
          timeBased: true,
          goalTime: 90);

      String matcher = "Goal: 1 hrs 30 min on Jul 2.";
      String translation = GoalModel.translateGoal(testTimeGoal);

      expect(translation, matcher);
    });

    test(
        'test translation of a task based goal into a descriptive string, start and end on different days.',
        () {
      DateTime from = DateTime(2019, 07, 02);
      DateTime to = DateTime(2019, 07, 04);

      final testTimeGoal = Goal(
          skillId: 1,
          fromDate: from,
          toDate: to,
          isComplete: false,
          timeBased: false,
          goalTime: 0,
          desc: 'Practice practice practice');

      String matcher =
          "Goal: Practice practice practice between Jul 2 and Jul 4.";
      String translation = GoalModel.translateGoal(testTimeGoal);

      expect(translation, matcher);
    });

    test(
        'test translation of a task based goal into a descriptive string, start and end on same day.',
        () {
      DateTime from = DateTime(2019, 07, 02);
      DateTime to = DateTime(2019, 07, 02);

      final testTimeGoal = Goal(
          skillId: 1,
          fromDate: from,
          toDate: to,
          isComplete: false,
          timeBased: false,
          goalTime: 0,
          desc: 'Practice practice practice');

      String matcher = "Goal: Practice practice practice on Jul 2.";
      String translation = GoalModel.translateGoal(testTimeGoal);

      expect(translation, matcher);
    });
  });
}
