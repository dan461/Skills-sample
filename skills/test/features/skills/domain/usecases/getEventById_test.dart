import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

import '../../mockClasses.dart';

void main() {
  GetEventByIdUC sut;
  MockEventsRepo mockEventsRepo;

  setUp(() {
    mockEventsRepo = MockEventsRepo();
    sut = GetEventByIdUC(mockEventsRepo);
  });

  test('test that class returns an event with given id', () async {
    final SkillEvent event = SkillEvent(
        eventId: 1,
        skillId: 1,
        sessionId: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        duration: 30,
        isComplete: false,
        skillString: 'test');

    when(mockEventsRepo.getEventById(1)).thenAnswer((_) async => Right(event));
    final result = await sut(SkillEventGetOrDeleteParams(eventId: 1));
    expect(result, Right(event));
    verify(mockEventsRepo.getEventById(1));
    verifyNoMoreInteractions(mockEventsRepo);
  });
}
