import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/data/models/sessionModel.dart';
import 'package:skills/features/skills/data/repos/sessionsRepositoryImpl.dart';
import 'package:skills/features/skills/domain/entities/session.dart';

import 'goalsRepositoryImpl_test.dart';

void main() {
  SessionsRepositoryImpl sut;
  MockLocalDataSource mockLocalDataSource;
  SessionModel testSessionModel;
  Session testSession;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    sut = SessionsRepositoryImpl(mockLocalDataSource);
    testSessionModel = SessionModel(
        date: 1,
        startTime: 1,
        endTime: 1,
        duration: 1,
        timeRemaining: 1,
        isScheduled: false,
        isCompleted: false);

    testSession = Session(
        date: 1,
        startTime: 1,
        endTime: 1,
        duration: 1,
        timeRemaining: 1,
        isCompleted: false,
        isScheduled: false);
  });

  group('Sessions CRUD tests', () {
    Session newSession = Session(
        sessionId: 1,
        date: 1,
        startTime: 1,
        endTime: 1,
        duration: 1,
        timeRemaining: 1,
        isCompleted: false,
        isScheduled: false);
    test('insertNewSession - returns a new Session with an id', () async {
      when(mockLocalDataSource.insertNewSession(testSession))
          .thenAnswer((_) async => newSession);
      final result = await sut.insertNewSession(testSession);
      verify(mockLocalDataSource.insertNewSession(testSession));
      expect(result, equals(Right(newSession)));
    });
  });
}
