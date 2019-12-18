
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/new_session/bloc.dart';
import '../../mockClasses.dart';

void main() {
  NewSessionBloc sut;
  MockInsertNewSessionUC mockInsertNewSessionUC;
  MockSessionRepo mockSessionRepo;
  Session testSession;
  Session newSession;

  setUp(() {
    mockSessionRepo = MockSessionRepo();
    mockInsertNewSessionUC = MockInsertNewSessionUC();
    sut = NewSessionBloc(insertNewSession: mockInsertNewSessionUC);
    testSession = Session(
        date: 1,
        startTime: 1,
        endTime: 1,
        isCompleted: false,
        isScheduled: true);
    newSession = Session(
        sessionId: 1,
        date: 1,
        startTime: 1,
        endTime: 1,
        isCompleted: false,
        isScheduled: true);
  });

  test('test bloc initial state is correct', () {
    expect(sut.initialState, equals(InitialNewSessionState()));
  });

  test('test that duration integer is correct', () {
    sut.selectedStartTime = TimeOfDay(hour: 12, minute: 0);
    sut.selectedFinishTime = TimeOfDay(hour: 13, minute: 0);
    expect(sut.duration, 60);
  });

  group('InsertNewSession', () {
    test('test that InsertNewSession usecase is called', () async {
      when(mockInsertNewSessionUC(
              SessionInsertOrUpdateParams(session: testSession)))
          .thenAnswer((_) async => Right(newSession));
      sut.add(InsertNewSessionEvent(newSession: testSession));
      await untilCalled(mockInsertNewSessionUC(
          SessionInsertOrUpdateParams(session: testSession)));
      verify(mockInsertNewSessionUC(
          SessionInsertOrUpdateParams(session: testSession)));
    });

    test(
        'test that bloc emits [NewSessionInsertingState, NewSessionInsertedState] upon successful insert',
        () async {
      when(mockInsertNewSessionUC(
              SessionInsertOrUpdateParams(session: testSession)))
          .thenAnswer((_) async => Right(newSession));
      final expected = [
        InitialNewSessionState(),
        NewSessionInsertingState(),
        NewSessionInsertedState(newSession)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(InsertNewSessionEvent(newSession: testSession));
    });

    test(
        'test that bloc emits [NewSessionInsertingState, NewSessionErrorState] upon unsuccessful insert',
        () async {
      when(mockInsertNewSessionUC(
              SessionInsertOrUpdateParams(session: testSession)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        InitialNewSessionState(),
        NewSessionInsertingState(),
        NewSessionErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(InsertNewSessionEvent(newSession: testSession));
    });
  });
}
