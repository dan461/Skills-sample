import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
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
    sut = SessionsRepositoryImpl(localDataSource: mockLocalDataSource);
    testSessionModel = SessionModel(
        date: DateTime.now(),
        startTime: TimeOfDay(hour: 12, minute: 0),
        duration: 1,
        timeRemaining: 1,
        isScheduled: false,
        isComplete: false);

    testSession = Session(
        date: DateTime.now(),
        startTime: TimeOfDay(hour: 12, minute: 0),
        duration: 1,
        timeRemaining: 1,
        isComplete: false,
        isScheduled: false);
  });

  group('Sessions CRUD tests', () {
    Session newSession = Session(
        sessionId: 1,
        date: DateTime.now(),
        startTime: TimeOfDay(hour: 12, minute: 0),
        duration: 1,
        timeRemaining: 1,
        isComplete: false,
        isScheduled: false);
    test('insertNewSession - returns a new Session with an id', () async {
      when(mockLocalDataSource.insertNewSession(testSession))
          .thenAnswer((_) async => newSession);
      final result = await sut.insertNewSession(testSession);
      verify(mockLocalDataSource.insertNewSession(testSession));
      expect(result, equals(Right(newSession)));
    });

    test('updateSession - returns an integer after an update', () async {
      Map<String, dynamic> changeMap = {};
      when(mockLocalDataSource.updateSession(changeMap, 1))
          .thenAnswer((_) async => 1);
      final result = await sut.updateSession(changeMap, 1);
      verify(mockLocalDataSource.updateSession(changeMap, 1));
      expect(result, equals(Right(1)));
    });

    test('getSessionWithId - returns a SessionModel', () async {
      when(mockLocalDataSource.getSessionById(1))
          .thenAnswer((_) async => testSessionModel);
      final result = await sut.getSessionById(1);
      verify(mockLocalDataSource.getSessionById(1));
      expect(result, equals(Right(testSessionModel)));
    });

    test('deleteSessionWithId returns 0 for successful deletion', () async {
      when(mockLocalDataSource.deleteSessionWithId(1))
          .thenAnswer((_) async => 0);
      final result = await sut.deleteSessionById(1);
      verify(mockLocalDataSource.deleteSessionWithId(1));
      expect(result, equals(Right(0)));
    });

    test('getSessionsInMonth returns a List<Session>', () async {
      final testMonth = DateTime(2019, 12);
      final testList = [testSession];
      when(mockLocalDataSource.getSessionsInMonth(testMonth))
          .thenAnswer((_) async => testList);
      final result = await sut.getSessionsInMonth(testMonth);
      verify(mockLocalDataSource.getSessionsInMonth(testMonth));
      expect(result, equals(Right(testList)));
    });

    test('getSessionsInDateRange returns a List<Session>', () async {
      final dates = [DateTime(2019, 12, 29), DateTime(2020, 1, 1)];
      final testList = [testSession];
      when(mockLocalDataSource.getSessionsInDateRange(dates.first, dates.last))
          .thenAnswer((_) async => testList);
      final result = await sut.getSessionsInDateRange(dates.first, dates.last);
      verify(
          mockLocalDataSource.getSessionsInDateRange(dates.first, dates.last));
      expect(result, equals(Right(testList)));
    });

    test('completeSessionsAndEvents returns an int', () async {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(0);
      when(mockLocalDataSource.completeSessionAndEvents(1, date))
          .thenAnswer((_) async => 1);
      final result = await sut.completeSessionAndEvents(1, date);
      verify(mockLocalDataSource.completeSessionAndEvents(1, date));
      expect(result, equals(Right(1)));
    });
  });
}
