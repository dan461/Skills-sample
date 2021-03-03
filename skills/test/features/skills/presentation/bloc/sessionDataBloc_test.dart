import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/sessionDataScreen/sessiondata_bloc.dart';
import '../../mockClasses.dart';

void main() {
  SessiondataBloc sut;
  MockGetSessionAndActivities mockGetSessionAndActivities;
  MockInsertActivitiesForSessionUC mockInsertActivitiesForSessionUC;
  MockUpdateAndRefreshSessionWithId mockUpdateAndRefreshSessionWithId;
  MockDeleteSessionWithId mockDeleteSessionWithId;
  MockDeleteActivityByIdUC mockDeleteEventByIdUC;
  // MockGetActivityMapsForSession mockGetActivityMapsForSession;
  MockGetActivitiesWithSkillsForSessionUC
      mockGetActivitiesWithSkillsForSessionUC;

  Session testSession;
  Activity testActivity;
  Map<String, dynamic> testChangeMap;

  setUp(() {
    mockGetSessionAndActivities = MockGetSessionAndActivities();
    mockInsertActivitiesForSessionUC = MockInsertActivitiesForSessionUC();
    mockUpdateAndRefreshSessionWithId = MockUpdateAndRefreshSessionWithId();
    mockDeleteSessionWithId = MockDeleteSessionWithId();
    mockDeleteEventByIdUC = MockDeleteActivityByIdUC();
    mockGetActivitiesWithSkillsForSessionUC =
        MockGetActivitiesWithSkillsForSessionUC();

    sut = SessiondataBloc(
        getSessionAndActivities: mockGetSessionAndActivities,
        updateAndRefreshSessionWithId: mockUpdateAndRefreshSessionWithId,
        deleteSessionWithId: mockDeleteSessionWithId,
        getActivitiesWithSkillsForSession:
            mockGetActivitiesWithSkillsForSessionUC,
        insertActivitiesForSession: mockInsertActivitiesForSessionUC,
        deleteActivityByIdUC: mockDeleteEventByIdUC);

    testSession = Session(
        sessionId: 1,
        date: DateTime.now(),
        startTime: TimeOfDay(hour: 12, minute: 0),
        duration: 30,
        isComplete: false,
        isScheduled: true);

    sut.session = testSession;

    testChangeMap = {};

    testActivity = Activity(
        skillId: 1,
        sessionId: 1,
        duration: 10,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        isComplete: false,
        skillString: 'test',
        notes: '');
  });

  test('test that availableTime is correct', () async {
    sut.activitiesForSession = [testActivity];

    expect(sut.availableTime, 20);
  });

  test(
      'test that insertEventsForSession usecase is called when createActivity is called',
      () async {
    Skill testSkill = Skill(
      skillId: 1,
      name: 'Delta',
      source: 'test',
      type: 'composition',
      startDate: DateTime.fromMillisecondsSinceEpoch(0),
    );

    var newTestActivity = Activity(
      skillId: testSkill.skillId,
      sessionId: 1,
      duration: 20,
      date: DateTime.fromMillisecondsSinceEpoch(0),
      isComplete: false,
      skillString: testSkill.name,
      notes: 'note',
    );
    List<Activity> activities = [newTestActivity];
    sut.session = testSession;
    sut.sessionDate = DateTime.fromMillisecondsSinceEpoch(0);

    sut.createActivity(20, 'note', testSkill, newTestActivity.date);
    await untilCalled(mockInsertActivitiesForSessionUC(
        ActivityMultiInsertParams(activities: activities, newSessionId: 1)));
    verify(mockInsertActivitiesForSessionUC(
        ActivityMultiInsertParams(activities: activities, newSessionId: 1)));
  });

  test('test that countCompletedActivities returns correct count ', () async {
    Activity testActivity2 = Activity(
        skillId: 1,
        sessionId: 1,
        duration: 10,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        isComplete: true,
        skillString: 'test',
        notes: 'notes');

    var testActivitiesList = [testActivity, testActivity2];
    sut.activitiesForSession = testActivitiesList;

    expect(sut.completedActivitiesCount, equals(1));
  });

  test(
      'test that bloc emits SessionEditingState after BeginSessionEditingEvent is added',
      () async {
    sut.add(BeginSessionEditingEvent());
    final expected = [SessionEditingState()];
    expectLater(sut, emitsInOrder(expected));
  });

  test(
      'test that bloc emits SessionViewingState after CancelSessionEditingEvent is added',
      () async {
    sut.add(CancelSessionEditingEvent());
    final expected = [SessionViewingState()];
    expectLater(sut, emitsInOrder(expected));
  });

  test(
      'test that bloc emits SessionViewingState after CancelSkillForSessionEvent is added',
      () async {
    sut.add(CancelSkillForSessionEvent());
    final expected = [SessionViewingState()];
    expectLater(sut, emitsInOrder(expected));
  });

  test(
      'test that bloc emits SkillSelectedForSessionState after SkillSelectedForSessionEvent is added',
      () async {
    Skill testSkill = Skill(
      name: 'Delta',
      source: 'test',
      type: 'composition',
      startDate: DateTime.fromMillisecondsSinceEpoch(0),
    );
    sut.add(SkillSelectedForSessionEvent(skill: testSkill));
    final expected = [SkillSelectedForSessionState(testSkill)];
    expectLater(sut, emitsInOrder(expected));
  });

  group('GetSessionAndActivities - ', () {
    Session testSession2 = Session(
        sessionId: 1,
        date: DateTime.now(),
        startTime: TimeOfDay(hour: 12, minute: 0),
        duration: 30,
        isComplete: false,
        isScheduled: true);
    testSession2.activities = [];

    test(
        'test that GetSessionAndActivities use case is called after a GetSessionAndActivitiesEvent event is added.',
        () async {
      sut.add(GetSessionAndActivitiesEvent(sessionId: 1));
      await untilCalled(
          mockGetSessionAndActivities(SessionByIdParams(sessionId: 1)));
      verify(mockGetSessionAndActivities(SessionByIdParams(sessionId: 1)));
    });

    test(
        'test that bloc emits [SessionDataCrudInProgressState, SessionDataInfoLoadedState] when getting Activity maps after a GetSessionAndActivities is added.',
        () async {
      // the events list returned by the repo can be an empty list, if there are no events
      when(mockGetSessionAndActivities(SessionByIdParams(sessionId: 1)))
          .thenAnswer((_) async => Right(testSession2));
      final expected = [
        SessionDataCrudInProgressState(),
        SessionDataInfoLoadedState()
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(GetSessionAndActivitiesEvent(sessionId: 1));
    });

    test(
        'test that bloc emits [SessionDataCrudInProgressState, SessionDataErrorState] on cache failure after a GetSessionAndActivities is added.',
        () async {
      // the events list returned by the repo can be an empty list, if there are no events
      when(mockGetSessionAndActivities(SessionByIdParams(sessionId: 1)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        SessionDataCrudInProgressState(),
        SessionDataErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(GetSessionAndActivitiesEvent(sessionId: 1));
    });
  });

  group('GetActivitiesWithSkillsForSession: ', () {
    test(
        'test that GetActivitiesWithSkillsForSession usecase is called after a GetActivitiesForSessionEvent is added',
        () async {
      sut.add(GetActivitiesForSessionEvent(testSession));
      await untilCalled(mockGetActivitiesWithSkillsForSessionUC(
          SessionByIdParams(sessionId: testSession.sessionId)));
      verify(mockGetActivitiesWithSkillsForSessionUC(
          SessionByIdParams(sessionId: testSession.sessionId)));
    });

    test(
        'test that bloc emits [SessionDataCrudInProgressState, SessionDataEventsLoadedState] when getting Activity maps after a GetActivitiesForSessionEvent is added.',
        () async {
      // the events list returned by the repo can be an empty list, if there are no events
      when(mockGetActivitiesWithSkillsForSessionUC(
              SessionByIdParams(sessionId: 1)))
          .thenAnswer((_) async => Right([]));
      final expected = [
        SessionDataCrudInProgressState(),
        SessionDataActivitesLoadedState()
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(GetActivitiesForSessionEvent(testSession));
    });

    test(
        'test that bloc emits [SessionDataCrudInProgressState, SessionDataErrorState] on cache failure after a GetActivitiesForSessionEvent is added.',
        () async {
      // the events list returned by the repo can be an empty list, if there are no events
      when(mockGetActivitiesWithSkillsForSessionUC(
              SessionByIdParams(sessionId: 1)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        SessionDataCrudInProgressState(),
        SessionDataErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(GetActivitiesForSessionEvent(testSession));
    });
  });

  group('UpdateAndRefreshSessionWithId', () {
    test('test that UpdateSessionWithId usecase is called', () async {
      sut.add(UpdateSessionEvent(testChangeMap));
      await untilCalled(mockUpdateAndRefreshSessionWithId(
          SessionUpdateParams(sessionId: 1, changeMap: testChangeMap)));
      verify(mockUpdateAndRefreshSessionWithId(
          SessionUpdateParams(sessionId: 1, changeMap: testChangeMap)));
    });

    test(
        'test that bloc emits [SessionDataCrudInProgressState, SessionUpdatedState] upon successful update',
        () async {
      when(mockUpdateAndRefreshSessionWithId(
              SessionUpdateParams(sessionId: 1, changeMap: testChangeMap)))
          .thenAnswer((_) async => Right(testSession));
      final expected = [
        SessionDataCrudInProgressState(),
        SessionUpdatedAndRefreshedState(testSession)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(UpdateSessionEvent(testChangeMap));
    });

    test(
        'test that bloc emits [SessionDataCrudInProgressState, SessionDataErrorState] upon cache failure during update',
        () async {
      when(mockUpdateAndRefreshSessionWithId(
              SessionUpdateParams(sessionId: 1, changeMap: testChangeMap)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        SessionDataCrudInProgressState(),
        SessionDataErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(UpdateSessionEvent(testChangeMap));
    });
  });

  group('DeleteSession: ', () {
    test('test that DeleteSession usecase is called', () async {
      when(mockDeleteSessionWithId(SessionDeleteParams(sessionId: 1)))
          .thenAnswer((_) async => Right(1));

      sut.add(DeleteSessionWithIdEvent(id: 1));
      await untilCalled(
          mockDeleteSessionWithId(SessionDeleteParams(sessionId: 1)));
      verify(mockDeleteSessionWithId(SessionDeleteParams(sessionId: 1)));
    });

    test(
        'test that bloc emits [SessionEditorCrudInProgressState, SessionWasDeletedState] upon successful delete',
        () async {
      when(mockDeleteSessionWithId(SessionDeleteParams(sessionId: 1)))
          .thenAnswer((_) async => Right(1));

      final expected = [
        SessionDataCrudInProgressState(),
        SessionWasDeletedState()
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(DeleteSessionWithIdEvent(id: 1));
    });

    test(
        'test that bloc emits [SessionEditorCrudInProgressState, SessionEditorErrorState] when delete fails',
        () async {
      when(mockDeleteSessionWithId(SessionDeleteParams(sessionId: 1)))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        SessionDataCrudInProgressState(),
        SessionDataErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(DeleteSessionWithIdEvent(id: 1));
    });
  });

  group('InsertEvents: ', () {
    var newTestEvent = Activity(
        skillId: 1,
        sessionId: 1,
        duration: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        isComplete: false,
        skillString: 'test',
        notes: '');
    List<Activity> events = [newTestEvent];
    List<int> resultsList = [1];

    test('test that InsertEvents usecase is called', () async {
      sut.add(InsertActivityForSessionEvent(newTestEvent));
      await untilCalled(mockInsertActivitiesForSessionUC(
          ActivityMultiInsertParams(activities: events, newSessionId: 1)));
      verify(mockInsertActivitiesForSessionUC(
          ActivityMultiInsertParams(activities: events, newSessionId: 1)));
    });

    test(
        'test that getActivitiesWithSkillsForSessionUC is called after an Activity is added to the Session',
        () async {
      when(mockInsertActivitiesForSessionUC(
              ActivityMultiInsertParams(activities: events, newSessionId: 1)))
          .thenAnswer((_) async => Right(resultsList));
      sut.add(InsertActivityForSessionEvent(newTestEvent));
      await untilCalled(mockGetActivitiesWithSkillsForSessionUC(
          SessionByIdParams(sessionId: 1)));
      verify(mockGetActivitiesWithSkillsForSessionUC(
          SessionByIdParams(sessionId: 1)));
    });

    test(
        'test that bloc emits [SessionDataCrudInProgressState, NewActivityCreatedState] upon successful event creation',
        () {
      when(mockInsertActivitiesForSessionUC(
              ActivityMultiInsertParams(activities: events, newSessionId: 1)))
          .thenAnswer((_) async => Right(resultsList));

      final expected = [
        SessionDataCrudInProgressState(),
        NewActivityCreatedState()
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(InsertActivityForSessionEvent(newTestEvent));
    });

    test(
        'test that bloc emits [SessionDataCrudInProgressState, SessionDataErrorState] test that bloc emits [SessionDataCrudInProgressState, SessionDataErrorState] on cache failure after InsertActivityForSessionEvent added',
        () {
      when(mockInsertActivitiesForSessionUC(
              ActivityMultiInsertParams(activities: events, newSessionId: 1)))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        SessionDataCrudInProgressState(),
        SessionDataErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(InsertActivityForSessionEvent(newTestEvent));
    });
  });

  group('DeleteEvent: ', () {
    test('test that DeleteEventById usecase is called', () async {
      sut.add(RemoveActivityFromSessionEvent(1));
      await untilCalled(
          mockDeleteEventByIdUC(ActivityGetOrDeleteParams(activityId: 1)));
      verify(mockDeleteEventByIdUC(ActivityGetOrDeleteParams(activityId: 1)));
    });

    test(
        'test that getActivitiesWithSkillsForSessionUC is called after an Activity is removed from the Session',
        () async {
      var newTestEvent = Activity(
          skillId: 1,
          sessionId: 1,
          duration: 1,
          date: DateTime.fromMillisecondsSinceEpoch(0),
          isComplete: false,
          skillString: 'test',
          notes: '');
      List<Activity> events = [newTestEvent];
      List<int> resultsList = [1];

      when(mockInsertActivitiesForSessionUC(
              ActivityMultiInsertParams(activities: events, newSessionId: 1)))
          .thenAnswer((_) async => Right(resultsList));
      sut.add(InsertActivityForSessionEvent(newTestEvent));
      await untilCalled(mockGetActivitiesWithSkillsForSessionUC(
          SessionByIdParams(sessionId: 1)));
      verify(mockGetActivitiesWithSkillsForSessionUC(
          SessionByIdParams(sessionId: 1)));
    });

    test(
        'test that bloc emits [SessionDataCrudInProgressState, ActivityRemovedFromSessionState] on succesful removal after RemoveActivityFromSessionEvent is added',
        () {
      when(mockDeleteEventByIdUC(ActivityGetOrDeleteParams(activityId: 1)))
          .thenAnswer((_) async => Right(1));

      final expected = [
        SessionDataCrudInProgressState(),
        ActivityRemovedFromSessionState()
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(RemoveActivityFromSessionEvent(1));
    });

    test(
        'test that bloc emits [SessionDataCrudInProgressState, ActivityRemovedFromSessionState] on cache failure after RemoveActivityFromSessionEvent is added',
        () {
      when(mockDeleteEventByIdUC(ActivityGetOrDeleteParams(activityId: 1)))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        SessionDataCrudInProgressState(),
        SessionDataErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(RemoveActivityFromSessionEvent(1));
    });
  });
}
