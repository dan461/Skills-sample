import 'package:flutter_test/flutter_test.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/data/models/skillModel.dart';
import 'dart:convert';
import '../../../../fixtures/jsonFixtureReader.dart';

void main() {
  SkillModel sut;
  Map<String, dynamic> testMap;

  setUp(() {
    sut = SkillModel(
        id: 1,
        name: 'test',
        source: 'testing',
        startDate: DateTime.fromMillisecondsSinceEpoch(0),
        totalTime: 1,
        lastPracDate: DateTime.fromMillisecondsSinceEpoch(0),
        currentGoalId: 1,
        goalText: "none");

    testMap = {
      'skillId': 1,
      'name': "test",
      'source': "testing",
      'startDate': 0,
      'totalTime': 1,
      'lastPracDate': 0,
      'currentGoalId': 1,
      'goalText': "none"
    };
  });

  test(
    'should be a subclass of Skill',
    () async {
      expect(sut, isA<Skill>());
    },
  );

  group('fromMap', () {
    test(
      'should return a valid SkillModel from a Map',
      () async {
        // final Map<String, dynamic> jsonMap =
        //     json.decode(fixture('skillJson.json'));
        final result = SkillModel.fromMap(testMap);
        expect(sut, result);
      },
    );
  });

  group('toMap', () {
    test('should return a valid Map from a SkillModel', () async {
      final result = sut.toMap();
      final expectedMap = {
        'skillId': 1,
        'name': 'test',
        'source': 'testing',
        'startDate': 0,
        'totalTime': 1,
        'lastPracDate': 0,
        'currentGoalId': 1,
        'goalText': 'none'
      };
      expect(result, expectedMap);
    });
  });
}
