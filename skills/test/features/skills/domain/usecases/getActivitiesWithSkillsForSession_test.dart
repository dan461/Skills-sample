import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/usecases/activityUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

import '../../mockClasses.dart';

void main() {
  GetActivitiesWithSkillsForSession sut;
  MockActivitiesRepo mockEventsRepo;

  setUp(() {
    mockEventsRepo = MockActivitiesRepo();
    sut = GetActivitiesWithSkillsForSession(mockEventsRepo);
  });

  test('test that usecase will return a list of Activities for a Session',
      () async {
    final Activity activity = Activity(
        eventId: 1,
        skillId: 1,
        sessionId: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        duration: 30,
        isComplete: false,
        skillString: 'test');

    final activitiesList = [activity];

    when(mockEventsRepo.getActivitiesWithSkillsForSession(1))
        .thenAnswer((_) async => Right(activitiesList));
    final result = await sut(SessionByIdParams(sessionId: 1));
    expect(result, Right(activitiesList));
    verify(mockEventsRepo.getActivitiesWithSkillsForSession(1));
    verifyNoMoreInteractions(mockEventsRepo);
  });
}
