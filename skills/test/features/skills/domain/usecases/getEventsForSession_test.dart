import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

import '../../mockClasses.dart';

void main() {
  GetEventsForSession sut;
  MockEventsRepo mockEventsRepo;

  setUp(() {
    mockEventsRepo = MockEventsRepo();
    sut = GetEventsForSession(mockEventsRepo);
  });

  test('test that usecase will return a list of SkillEvents for a Session',
      () async {
    final SkillEvent event = SkillEvent(
        eventId: 1,
        skillId: 1,
        sessionId: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        duration: 30,
        isComplete: false,
        skillString: 'test');

    final eventsList = [event];

    when(mockEventsRepo.getEventsForSession(1))
        .thenAnswer((_) async => Right(eventsList));
    final result = await sut(SessionByIdParams(sessionId: 1));
    expect(result, Right(eventsList));
    verify(mockEventsRepo.getEventsForSession(1));
    verifyNoMoreInteractions(mockEventsRepo);
  });
}
