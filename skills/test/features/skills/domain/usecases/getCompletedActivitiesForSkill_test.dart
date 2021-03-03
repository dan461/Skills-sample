import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/usecases/activityUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

import '../../mockClasses.dart';

void main() {
  GetCompletedActivitiesForSkill sut;
  MockActivitiesRepo mockEventsRepo;

  setUp(() {
    mockEventsRepo = MockActivitiesRepo();
    sut = GetCompletedActivitiesForSkill(mockEventsRepo);
  });

  test(
      'test that usecase will return a list of completed SkillEvents for a Skill',
      () async {
    final Activity event = Activity(
        eventId: 1,
        skillId: 1,
        sessionId: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        duration: 30,
        isComplete: true,
        skillString: 'test');

    final eventsList = [event];
    when(mockEventsRepo.getCompletedActivitiesForSkill(1))
        .thenAnswer((_) async => Right(eventsList));
    final result = await sut(GetSkillParams(id: 1));
    expect(result, Right(eventsList));
    verify(mockEventsRepo.getCompletedActivitiesForSkill(1));
    verifyNoMoreInteractions(mockEventsRepo);
  });
}
