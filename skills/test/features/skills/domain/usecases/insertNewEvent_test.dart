import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

import '../../mockClasses.dart';

void main() {
  InsertNewSkillEventUC sut;
  MockEventsRepo mockEventsRepo;

  setUp(() {
    mockEventsRepo = MockEventsRepo();
    sut = InsertNewSkillEventUC(mockEventsRepo);
  });

  test('test that class inserts a new event and returns a new event with an id',
      () async {
    final SkillEvent testEvent = SkillEvent(
        skillId: 1,
        sessionId: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        duration: 30,
        isComplete: false,
        skillString: 'test');

        final SkillEvent newEvent = SkillEvent(
          eventId: 1,
        skillId: 1,
        sessionId: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        duration: 30,
        isComplete: false,
        skillString: 'test');

        when(mockEventsRepo.insertNewEvent(testEvent)).thenAnswer((_) async => Right(newEvent));
        final result = await sut(SkillEventInsertOrUpdateParams(event: testEvent));
        expect(result, Right(newEvent));
        verify(mockEventsRepo.insertNewEvent(testEvent));
        verifyNoMoreInteractions(mockEventsRepo);
  });
}
