
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import '../../mockClasses.dart';

void main() {
  GetSessionAndActivities sut;
  MockSessionRepo mockSessionRepo;

  setUp(() {
    mockSessionRepo = MockSessionRepo();
    sut = GetSessionAndActivities(mockSessionRepo);
  });

  test('should return a session with an activities list', () async {
    final Activity activity = Activity(
        eventId: 1,
        skillId: 1,
        sessionId: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        duration: 30,
        isComplete: false,
        skillString: 'test');

    final newSession = Session(
        sessionId: 1,
        date: DateTime.now(),
        startTime: TimeOfDay(hour: 12, minute: 0),
        isComplete: false,
        isScheduled: true);
    newSession.activities = [activity];

    when(mockSessionRepo.getSessionAndActivities(1))
        .thenAnswer((_) async => Right(newSession));
    final result =
        await sut(SessionByIdParams(sessionId: newSession.sessionId));
    expect(result, Right(newSession));
    verify(mockSessionRepo.getSessionAndActivities(1));
    verifyNoMoreInteractions(mockSessionRepo);
  });
}
