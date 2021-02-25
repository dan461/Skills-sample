import 'package:flutter_test/flutter_test.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/enums.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/data/models/skillModel.dart';

void main() {
  SkillModel sut;
  Map<String, dynamic> testMap;

  setUp(() {
    sut = SkillModel(
      skillId: 1,
      name: 'test',
      type: skillTypeToString(SkillType.composition),
      source: 'testing',
      instrument: GUITAR_CL,
      startDate: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
      totalTime: 1,
      lastPracDate: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
      currentGoalId: 1,
      priority: 3,
      proficiency: 8.5,
    );

    testMap = {
      'skillId': 1,
      'name': "test",
      'type': 'composition',
      'source': "testing",
      'instrument': 'Guitar (Classical)',
      'startDate': 0,
      'totalTime': 1,
      'lastPracDate': 0,
      'goalId': 1,
      'priority': 3,
      'proficiency': 8.5
    };
  });

  test(
    'should be a subclass of Skill',
    () async {
      expect(sut, isA<Skill>());
    },
  );

  group('fromMap: - ', () {
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

  group('toMap: - ', () {
    test('should return a valid Map from a SkillModel', () async {
      final result = sut.toMap();
      final expectedMap = {
        'skillId': 1,
        'name': "test",
        'type': 'composition',
        'source': "testing",
        'instrument': 'Guitar (Classical)',
        'startDate': 0,
        'totalTime': 1,
        'lastPracDate': 0,
        'goalId': 1,
        'priority': 3,
        'proficiency': 8.5
      };
      expect(result, expectedMap);
    });
  });
}
