import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

import '../../mockClasses.dart';

void main() {
  GetCompletedEventsForSkill sut;
  MockEventsRepo mockEventsRepo;

  setUp(() {
    mockEventsRepo = MockEventsRepo();
    sut = GetCompletedEventsForSkill(mockEventsRepo);
  });

  test(
      'test that usecase will return a list of completed SkillEvents for a Skill',
      () async {
    final SkillEvent event = SkillEvent(
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
