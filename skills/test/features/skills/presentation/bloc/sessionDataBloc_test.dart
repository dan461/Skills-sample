import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/core/tickTock.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/sessionDataScreen/sessiondata_bloc.dart';
import '../../mockClasses.dart';

void main() {
  SessiondataBloc sut;
  MockInsertEventsForSessionUC mockInsertEventsForSessionUC;
  MockUpdateAndRefreshSessionWithId mockUpdateAndRefreshSessionWithId;
  MockDeleteSessionWithId mockDeleteSessionWithId;
  MockDeleteEventByIdUC mockDeleteEventByIdUC;
  MockGetEventMapsForSession mockGetEventMapsForSession;

  Session testSession;
  SkillEvent testEvent;
  Map<String, dynamic> testChangeMap;

  setUp(() {
    mockInsertEventsForSessionUC = MockInsertEventsForSessionUC();
    mockUpdateAndRefreshSessionWithId = MockUpdateAndRefreshSessionWithId();
    mockDeleteSessionWithId = MockDeleteSessionWithId();
    mockDeleteEventByIdUC = MockDeleteEventByIdUC();
    mockGetEventMapsForSession = MockGetEventMapsForSession();

    sut = SessiondataBloc(
        updateAndRefreshSessionWithId: mockUpdateAndRefreshSessionWithId,
        deleteSessionWithId: mockDeleteSessionWithId,
        getEventMapsForSession: mockGetEventMapsForSession,
        insertEventsForSession: mockInsertEventsForSessionUC,
        deleteEventByIdUC: mockDeleteEventByIdUC);

    testSession = Session(
        sessionId: 1,
        date: DateTime.now(),
        startTime: TimeOfDay(hour: 12, minute: 0),
        duration: 30,
        isComplete: false,
        isScheduled: true);

    testChangeMap = {};
    sut.session = testSession;

    testEvent = SkillEvent(
        skillId: 1,
        sessionId: 1,
        duration: 10,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        isComplete: false,
        skillString: 'test');
  });

  test('test that availableTime is correct', () async {
    var testEvent = SkillEvent(
        skillId: 1,
        sessionId: 1,
        duration: 10,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        isComplete: false,
        skillString: 'test');
    Map<String, dynamic> eventMap = {'event': testEvent};

    // sut.session = testSession;
    sut.activityMapsForListView = [eventMap];

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

    var newTestEvent = SkillEvent(
        skillId: testSkill.skillId,
        sessionId: 1,
        duration: 20,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        isComplete: false,
        skillString: testSkill.name);
    List<SkillEvent> events = [newTestEvent];

    sut.sessionDate = DateTime.fromMillisecondsSinceEpoch(0);

    sut.createActivity(20, testSkill);
    await untilCalled(mockInsertEventsForSessionUC(
        SkillEventMultiInsertParams(events: events, newSessionId: 1)));
    verify(mockInsertEventsForSessionUC(
        SkillEventMultiInsertParams(events: events, newSessionId: 1)));
  });

  test('test that countCompletedActivities returns correct count ', () async {
    SkillEvent testEvent2 = SkillEvent(
        skillId: 1,
        sessionId: 1,
        duration: 10,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        isComplete: true,
        skillString: 'test');
    Map<String, dynamic> map1 = {'event': testEvent};
    Map<String, dynamic> map2 = {'event': testEvent2};
    var testActivitiesList = [map1, map2];
    sut.activityMapsForListView = testActivitiesList;

    expect(sut.completedActivitiesCount, equals(1));
  });

  test(
      'test that bloc emits SessionEditingState after BeginSessionEditingEvent is added',
      () async {
    sut.add(BeginSessionEditingEvent());
    final expected = [SessiondataInitial(), SessionEditingState()];
    expectLater(sut, emitsInOrder(expected));
  });

  test(
      'test that bloc emits SessionViewingState after CancelSessionEditingEvent is added',
      () async {
    sut.add(CancelSessionEditingEvent());
    final expected = [SessiondataInitial(), SessionViewingState()];
    expectLater(sut, emitsInOrder(expected));
  });

  test(
      'test that bloc emits SessionViewingState after CancelSkillForSessionEvent is added',
      () async {
    sut.add(CancelSkillForSessionEvent());
    final expected = [SessiondataInitial(), SessionViewingState()];
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
    final expected = [
      SessiondataInitial(),
      SkillSelectedForSessionState(testSkill)
    ];
    expectLater(sut, emitsInOrder(expected));
  });

  group('GetEventMapsForSession: ', () {
    test(
        'test that GetEventMapsForSession usecase is called after a GetActivitiesForSessionEvent is added',
        () async {
      sut.add(GetActivitiesForSessionEvent(testSession));
      await untilCalled(
          mockGetEventMapsForSession(SessionByIdParams(sessionId: 1)));
      verify(mockGetEventMapsForSession(SessionByIdParams(sessionId: 1)));
    });

    test(
        'test that bloc emits [SessionDataCrudInProgressState, SessionDataEventsLoadedState] when getting Activity maps after a GetActivitiesForSessionEvent is added.',
        () async {
      // the events list returned by the repo can be an empty list, if there are no events
      when(mockGetEventMapsForSession(SessionByIdParams(sessionId: 1)))
          .thenAnswer((_) async => Right([]));
      final expected = [
        SessiondataInitial(),
        SessionDataCrudInProgressState(),
        SessionDataEventsLoadedState()
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(GetActivitiesForSessionEvent(testSession));
    });

    test(
        'test that bloc emits [SessionDataCrudInProgressState, SessionDataErrorState] on cache failure after a GetActivitiesForSessionEvent is added.',
        () async {
      // the events list returned by the repo can be an empty list, if there are no events
      when(mockGetEventMapsForSession(SessionByIdParams(sessionId: 1)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        SessiondataInitial(),
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
        SessiondataInitial(),
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
        SessiondataInitial(),
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
        SessiondataInitial(),
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
        SessiondataInitial(),
        SessionDataCrudInProgressState(),
        SessionDataErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(DeleteSessionWithIdEvent(id: 1));
    });
  });

  group('InsertEvents: ', () {
    var newTestEvent = SkillEvent(
        skillId: 1,
        sessionId: 1,
        duration: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        isComplete: false,
        skillString: 'test');
    List<SkillEvent> events = [newTestEvent];
    List<int> resultsList = [1];

    test('test that InsertEvents usecase is called', () async {
      sut.add(InsertActivityForSessionEvent(newTestEvent));
      await untilCalled(mockInsertEventsForSessionUC(
          SkillEventMultiInsertParams(events: events, newSessionId: 1)));
      verify(mockInsertEventsForSessionUC(
          SkillEventMultiInsertParams(events: events, newSessionId: 1)));
    });

    test(
        'test that getEventMapsForSession is called after an Activity is added to the Session',
        () async {
      when(mockInsertEventsForSessionUC(
              SkillEventMultiInsertParams(events: events, newSessionId: 1)))
          .thenAnswer((_) async => Right(resultsList));
      sut.add(InsertActivityForSessionEvent(newTestEvent));
      await untilCalled(
          mockGetEventMapsForSession(SessionByIdParams(sessionId: 1)));
      verify(mockGetEventMapsForSession(SessionByIdParams(sessionId: 1)));
    });

    test(
        'test that bloc emits [SessionDataCrudInProgressState, NewActivityCreatedState] upon successful event creation',
        () {
      when(mockInsertEventsForSessionUC(
              SkillEventMultiInsertParams(events: events, newSessionId: 1)))
          .thenAnswer((_) async => Right(resultsList));

      final expected = [
        SessiondataInitial(),
        SessionDataCrudInProgressState(),
        NewActivityCreatedState()
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(InsertActivityForSessionEvent(newTestEvent));
    });

    test(
        'test that bloc emits [SessionDataCrudInProgressState, SessionDataErrorState] test that bloc emits [SessionDataCrudInProgressState, SessionDataErrorState] on cache failure after InsertActivityForSessionEvent added',
        () {
      when(mockInsertEventsForSessionUC(
              SkillEventMultiInsertParams(events: events, newSessionId: 1)))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        SessiondataInitial(),
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
          mockDeleteEventByIdUC(SkillEventGetOrDeleteParams(eventId: 1)));
      verify(mockDeleteEventByIdUC(SkillEventGetOrDeleteParams(eventId: 1)));
    });

    test(
        'test that getEventMapsForSession is called after an Activity is removed from the Session',
        () async {
      var newTestEvent = SkillEvent(
          skillId: 1,
          sessionId: 1,
          duration: 1,
          date: DateTime.fromMillisecondsSinceEpoch(0),
          isComplete: false,
          skillString: 'test');
      List<SkillEvent> events = [newTestEvent];
      List<int> resultsList = [1];

      when(mockInsertEventsForSessionUC(
              SkillEventMultiInsertParams(events: events, newSessionId: 1)))
          .thenAnswer((_) async => Right(resultsList));
      sut.add(InsertActivityForSessionEvent(newTestEvent));
      await untilCalled(
          mockGetEventMapsForSession(SessionByIdParams(sessionId: 1)));
      verify(mockGetEventMapsForSession(SessionByIdParams(sessionId: 1)));
    });

    test(
        'test that bloc emits [SessionDataCrudInProgressState, ActivityRemovedFromSessionState] on succesful removal after RemoveActivityFromSessionEvent is added',
        () {
      when(mockDeleteEventByIdUC(SkillEventGetOrDeleteParams(eventId: 1)))
          .thenAnswer((_) async => Right(1));

      final expected = [
        SessiondataInitial(),
        SessionDataCrudInProgressState(),
        ActivityRemovedFromSessionState()
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(RemoveActivityFromSessionEvent(1));
    });

    test(
        'test that bloc emits [SessionDataCrudInProgressState, ActivityRemovedFromSessionState] on cache failure after RemoveActivityFromSessionEvent is added',
        () {
      when(mockDeleteEventByIdUC(SkillEventGetOrDeleteParams(eventId: 1)))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        SessiondataInitial(),
        SessionDataCrudInProgressState(),
        SessionDataErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(RemoveActivityFromSessionEvent(1));
    });
  });
}
