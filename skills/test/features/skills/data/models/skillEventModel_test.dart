import 'package:flutter_test/flutter_test.dart';
import 'package:skills/features/skills/data/models/activityModel.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';

void main() {
  ActivityModel sut;
  Map<String, dynamic> testMap;

  setUp(() {
    sut = ActivityModel(
        eventId: 1,
        skillId: 1,
        sessionId: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
        duration: 60,
        isComplete: false,
        skillString: 'test',
        notes: '');

    testMap = {
      'eventId': 1,
      'skillId': 1,
      'sessionId': 1,
      'date': 0,
      'duration': 60,
      'isComplete': 0,
      'skillString': "test",
      'notes': ''
    };
  });

  test('should be subclass of SkillEvent', () async {
    expect(sut, isA<Activity>());
  });

  test('fromMap returns a valid SkillEventModel', () async {
    final result = ActivityModel.fromMap(testMap);
    expect(sut, result);
  });

  test('toMap returns a valid map from a SkillEventModel', () async {
    final result = sut.toMap();
    testMap['isComplete'] = false;
    expect(result, testMap);
  });
}
