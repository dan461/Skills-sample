import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:skills/features/skills/data/models/skillEventModel.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';

void main() {
  SkillEventModel sut;
  Map<String, dynamic> testMap;

  setUp(() {
    sut = SkillEventModel(
        eventId: 1,
        skillId: 1,
        sessionId: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        duration: 60,
        isComplete: false,
        skillString: 'test');

    testMap = {
      'eventId': 1,
      'skillId': 1,
      'sessionId': 1,
      'date': 0,
      'duration': 60,
      'isComplete': 0,
      'skillString': "test"
    };
  });

  test('should be subclass of SkillEvent', () async {
    expect(sut, isA<SkillEvent>());
  });

  test('fromMap returns a valid SkillEventModel', () async {
    final result = SkillEventModel.fromMap(testMap);
    expect(sut, result);
  });

  test('toMap returns a valid map from a SkillEventModel', () async {
    final result = sut.toMap();
    testMap['isComplete'] = false;
    expect(result, testMap);
  });
}
