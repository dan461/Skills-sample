import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/new_session/bloc.dart';
import '../../mockClasses.dart';

void main() {
  NewSessionBloc sut;
  MockInsertNewSessionUC mockInsertNewSessionUC;
  MockInsertNewEventUC mockInsertNewEventUC;
  MockInsertEventsForSessionUC mockInsertEventsForSessionUC;
  MockSessionRepo mockSessionRepo;
  Session testSession;
  Session newSession;

  setUp(() {
    mockSessionRepo = MockSessionRepo();
    mockInsertNewSessionUC = MockInsertNewSessionUC();
    mockInsertNewEventUC = MockInsertNewEventUC();
    sut = NewSessionBloc(insertNewSession: mockInsertNewSessionUC, insertEventsForSessionUC: mockInsertEventsForSessionUC);
    testSession = Session(
        date: DateTime.now(),
        startTime: TimeOfDay(hour: 12, minute: 0),
        endTime: TimeOfDay(hour: 12, minute: 0),
        isCompleted: false,
        isScheduled: true);
    newSession = Session(
        sessionId: 1,
        date: DateTime.now(),
        startTime: TimeOfDay(hour: 12, minute: 0),
        endTime: TimeOfDay(hour: 12, minute: 0),
        isCompleted: false,
        isScheduled: true);
  });

  test('test bloc initial state is correct', () {
    expect(sut.initialState, equals(InitialNewSessionState()));
  });

  test('test that sessionDuration integer is correct', () {
    sut.selectedStartTime = TimeOfDay(hour: 12, minute: 0);
    sut.selectedFinishTime = TimeOfDay(hour: 13, minute: 0);
    expect(sut.sessionDuration, 60);
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

  group('testing for correct state when addding an event to a session: ', () {
    var testSkill = Skill(
        name: 'test',
        source: 'testing',
        lastPracDate: DateTime.fromMillisecondsSinceEpoch(0));

    var testEvent = SkillEvent(
        skillId: 1,
        sessionId: 1,
        duration: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        isComplete: false,
        skillString: 'test');

    var newEvent = SkillEvent(
        eventId: 1,
        skillId: 1,
        sessionId: 1,
        duration: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        isComplete: false,
        skillString: 'test');
    test(
        'test that bloc emits [SkillSelectedForEventState] when a Skill is selected to be added to the new event',
        () async {
      final expected = [
        InitialNewSessionState(),
        SkillSelectedForEventState(skill: testSkill)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(SkillSelectedForSessionEvent(skill: testSkill));
    });

    test(
        'test that bloc emits [NewSessionCrudInProgressState, SkillEventCreatedState] when a new Event is created',
        () async {
      when(mockInsertNewEventUC(
              SkillEventInsertOrUpdateParams(event: testEvent)))
          .thenAnswer((_) async => Right(newEvent));
      final expected = [
        InitialNewSessionState(),
        NewSessionCrudInProgressState(),
        SkillEventCreatedState(event: newEvent)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(EventCreationEvent(event: testEvent));
    });

    test(
        'test that bloc emits [NewSessionCrudInProgressState, NewSessionErrorState] when new event creation fails',
        () async {
      when(mockInsertNewEventUC(
              SkillEventInsertOrUpdateParams(event: testEvent)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        InitialNewSessionState(),
        NewSessionCrudInProgressState(),
        NewSessionErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(EventCreationEvent(event: testEvent));
    });
  });
}
