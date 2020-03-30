import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/activeSessionScreen/activesession_bloc.dart';
import '../../mockClasses.dart';

void main() {
  ActiveSessionBloc sut;
  MockCompleteActivityUC mockCompleteActivityUC;
  MockGetActivitiesWithSkillsForSessionUC
      mockGetActivitiesWithSkillsForSessionUC;
  MockUpdateSessionWithId mockUpdateSessionWithId;

  Session testSession;
  List<Activity> testActivitiesList;
  Activity testActivity;
  Map<String, dynamic> changeMap;

  setUp(() {
    mockCompleteActivityUC = MockCompleteActivityUC();
    mockGetActivitiesWithSkillsForSessionUC =
        MockGetActivitiesWithSkillsForSessionUC();
    mockUpdateSessionWithId = MockUpdateSessionWithId();

    sut = ActiveSessionBloc(
        completeActivityUC: mockCompleteActivityUC,
        getActivitiesWithSkillsForSessionUC:
            mockGetActivitiesWithSkillsForSessionUC,
        updateSessionWithId: mockUpdateSessionWithId);

    testSession = Session(
        sessionId: 1,
        date: DateTime.now(),
        startTime: TimeOfDay(hour: 12, minute: 0),
        duration: 30,
        isComplete: false,
        isScheduled: true);
    sut.session = testSession;

    testActivity = Activity(
        skillId: 1,
        sessionId: 1,
        duration: 10,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        isComplete: false,
        skillString: 'test');

    testActivitiesList = [testActivity];

    changeMap = {'isComplete': true, 'duration': testSession.duration};
  });

  test('test for correct initial state', () {
    expect(sut.initialState, equals(ActiveSessionInitial()));
  });

  test(
      'test for bloc emitting [ActiveSessionInfoLoadedState] after ActiveSessionLoadInfoEvent added',
      () async {
    sut.add(ActiveSessionLoadInfoEvent(
        session: testSession, activities: testActivitiesList));
    final expected = [
      ActiveSessionInitial(),
      ActiveSessionInfoLoadedState(
          activities: testActivitiesList, duration: testSession.duration)
    ];
    expectLater(sut, emitsInOrder(expected));
  });

  test(
      'test for bloc emitting [ActivityReadyState] after ActivitySelectedForTimerEvent is added.',
      () async {
    sut.add(ActivitySelectedForTimerEvent(selectedActivity: testActivity));
    final expected = [
      ActiveSessionInitial(),
      ActivityReadyState(activity: testActivity)
    ];
    expectLater(sut, emitsInOrder(expected));
  });

  // test(
  //     'test for correct activity map selected after ActivitySelectedForTimerEvent is added',
  //     () async {
  //   sut.add(ActivitySelectedForTimerEvent(selectedMap: activityMap));
  //   expectLater(sut.selectedMap, equals(activityMap));
  // });

  test(
      'test for bloc emitting [ActivityTimerStoppedState] after ActivityTimerStoppedEvent is added.',
      () async {
    sut.add(ActivityTimerStoppedEvent());
    final expected = [
      ActiveSessionInitial(),
      ActivityTimerStoppedState(activity: testActivity)
    ];
    expectLater(sut, emitsInOrder(expected));
  });

  group('CompleteActivity - ', () {
    test(
        'test for CompleteActivity use case called after CurrentActivityFinishedEvent added',
        () async {
      sut.add(CurrentActivityFinishedEvent(
          activity: testActivity, elapsedTime: 20));
      await untilCalled(mockCompleteActivityUC(ActivityCompleteParams(
          testActivity.eventId, testActivity.date, 20, testActivity.skillId)));
      verify(mockCompleteActivityUC(ActivityCompleteParams(
          testActivity.eventId, testActivity.date, 20, testActivity.skillId)));
    });

    test(
        'test for bloc emitting [ActiveSessionProcessingState, CurrentActivityFinishedState] after CurrentActivityFinishedEvent is added.',
        () async {
      when(mockCompleteActivityUC(ActivityCompleteParams(testActivity.eventId,
              testActivity.date, 20, testActivity.skillId)))
          .thenAnswer((_) async => Right(1));

      sut.add(CurrentActivityFinishedEvent(
          activity: testActivity, elapsedTime: 20));
      final expected = [
        ActiveSessionInitial(),
        ActiveSessionProcessingState(),
        CurrentActivityFinishedState()
      ];
      expectLater(sut, emitsInOrder(expected));
    });

    test(
        'test for bloc emitting [ActiveSessionProcessingState, ActiveSessionErrorState] after cache failure when CurrentActivityFinishedEvent is added.',
        () async {
      when(mockCompleteActivityUC(ActivityCompleteParams(testActivity.eventId,
              testActivity.date, 20, testActivity.skillId)))
          .thenAnswer((_) async => Left(CacheFailure()));

      sut.add(CurrentActivityFinishedEvent(
          activity: testActivity, elapsedTime: 20));
      final expected = [
        ActiveSessionInitial(),
        ActiveSessionProcessingState(),
        ActiveSessionErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
    });
  });

  group('GetActivitiesWithSkillsForSession - ', () {
    test(
        'test for GetActivitiesWithSkillsForSession use case called after ActiveSessionRefreshActivitiesEvent added',
        () async {
      sut.add(ActiveSessionRefreshActivitiesEvent());
      await untilCalled(mockGetActivitiesWithSkillsForSessionUC(
          SessionByIdParams(sessionId: testSession.sessionId)));
      verify(mockGetActivitiesWithSkillsForSessionUC(
          SessionByIdParams(sessionId: testSession.sessionId)));
    });

    test(
        'test that bloc emits [ActiveSessionProcessingState, ActiveSessionActivitiesRefreshedState] after ActiveSessionRefreshActivitiesEvent added',
        () async {
      when(mockGetActivitiesWithSkillsForSessionUC(
              SessionByIdParams(sessionId: testSession.sessionId)))
          .thenAnswer((_) async => Right(testActivitiesList));

      sut.add(ActiveSessionRefreshActivitiesEvent());
      final expected = [
        ActiveSessionInitial(),
        ActiveSessionProcessingState(),
        ActiveSessionActivitiesRefreshedState(
            duration: testSession.duration, activities: testActivitiesList)
      ];
      expectLater(sut, emitsInOrder(expected));
    });

    test(
        'test that bloc emits [ActiveSessionProcessingState, ActiveSessionErrorState] after cache failure when ActiveSessionRefreshActivitiesEvent added',
        () async {
      when(mockGetActivitiesWithSkillsForSessionUC(
              SessionByIdParams(sessionId: testSession.sessionId)))
          .thenAnswer((_) async => Left(CacheFailure()));

      sut.add(ActiveSessionRefreshActivitiesEvent());
      final expected = [
        ActiveSessionInitial(),
        ActiveSessionProcessingState(),
        ActiveSessionErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
    });
  });

  group('UpdateSessionWithId - ', () {
    test(
        'test for UpdateSessionWithId use case called after CompleteActiveSessionEvent added',
        () async {
      sut.add(CompleteActiveSessionEvent());
      await untilCalled(mockUpdateSessionWithId(SessionUpdateParams(
          sessionId: testSession.sessionId, changeMap: changeMap)));
      verify(mockUpdateSessionWithId(SessionUpdateParams(
          sessionId: testSession.sessionId, changeMap: changeMap)));
    });

    test(
        'test that bloc emits [ActiveSessionProcessingState, CompleteActiveSessionEvent] after ActiveSessionRefreshActivitiesEvent added',
        () async {
      when(mockUpdateSessionWithId(SessionUpdateParams(
              sessionId: testSession.sessionId, changeMap: changeMap)))
          .thenAnswer((_) async => Right(1));

      sut.add(CompleteActiveSessionEvent());
      final expected = [
        ActiveSessionInitial(),
        ActiveSessionProcessingState(),
        ActiveSessionCompletedState()
      ];
      expectLater(sut, emitsInOrder(expected));
    });

    test(
        'test that bloc emits [ActiveSessionProcessingState, ActiveSessionErrorState] after cache failure when CompleteActiveSessionEvent added',
        () async {
      when(mockUpdateSessionWithId(SessionUpdateParams(
              sessionId: testSession.sessionId, changeMap: changeMap)))
          .thenAnswer((_) async => Left(CacheFailure()));

      sut.add(CompleteActiveSessionEvent());
      final expected = [
        ActiveSessionInitial(),
        ActiveSessionProcessingState(),
        ActiveSessionErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
    });
  });
}
