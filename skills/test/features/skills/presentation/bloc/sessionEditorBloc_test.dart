import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/core/tickTock.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/sessionEditorScreen/bloc.dart';
import '../../mockClasses.dart';
import 'blocTestClasses.dart';

void main() {
  SessionEditorBloc sut;
  MockInsertEventsForSessionUC mockInsertEventsForSessionUC;
  MockUpdateSessionWithId mockUpdateSessionWithId;
  MockDeleteSessionWithId mockDeleteSessionWithId;
  MockDeleteEventByIdUC mockDeleteEventByIdUC;
  MockGetEventMapsForSession mockGetEventMapsForSession;
  MockCompleteSessionAndEvents mockCompleteSessionAndEvents;
  Session testSession;
  Map<String, dynamic> testChangeMap;

  setUp(() {
    mockInsertEventsForSessionUC = MockInsertEventsForSessionUC();
    mockUpdateSessionWithId = MockUpdateSessionWithId();
    mockDeleteSessionWithId = MockDeleteSessionWithId();
    mockDeleteEventByIdUC = MockDeleteEventByIdUC();
    mockGetEventMapsForSession = MockGetEventMapsForSession();
    mockCompleteSessionAndEvents = MockCompleteSessionAndEvents();

    sut = SessionEditorBloc(
        updateSessionWithId: mockUpdateSessionWithId,
        deleteSessionWithId: mockDeleteSessionWithId,
        getEventMapsForSession: mockGetEventMapsForSession,
        insertEventsForSession: mockInsertEventsForSessionUC,
        completeSessionAndEvents: mockCompleteSessionAndEvents,
        deleteEventByIdUC: mockDeleteEventByIdUC);

    testSession = Session(
        sessionId: 1,
        date: DateTime.now(),
        startTime: TimeOfDay(hour: 12, minute: 0),
        endTime: TimeOfDay(hour: 12, minute: 30),
        duration: 30,
        isComplete: false,
        isScheduled: true);

    sut.sessionForEdit = testSession;
    testChangeMap = {};
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

    sut.sessionForEdit = testSession;
    sut.eventMapsForListView = [eventMap];

    expect(sut.availableTime, 20);
  });

  group('changeMap logic: ', () {
    // StartTime
    test('test that changeMap is correct after new startTime is selected',
        () async {
      sut.selectedStartTime = TimeOfDay(hour: 12, minute: 15);
      sut.changeStartTime(TimeOfDay(hour: 12, minute: 30));
      bool rightTime = sut.changeMap['startTime'] ==
          TickTock.timeToInt(sut.selectedStartTime);
      expect(true, rightTime);
    });

    test(
        'test that changeMap has no startTime entry after selectedStartTime is returned to the original start time',
        () {
      sut.sessionForEdit = testSession;
      sut.selectedStartTime = testSession.startTime;
      sut.changeStartTime(TimeOfDay(hour: 12, minute: 30));
      sut.changeStartTime(testSession.startTime);
      expect(sut.changeMap['startTime'], null);
    });

    // EndTime
    test('test that changeMap is correct after new endTime is selected',
        () async {
      sut.selectedFinishTime = TimeOfDay(hour: 12, minute: 15);
      sut.changeFinishTime(TimeOfDay(hour: 12, minute: 0));
      bool rightTime = sut.changeMap['endTime'] ==
          TickTock.timeToInt(sut.selectedFinishTime);
      expect(true, rightTime);
    });

    test(
        'test that changeMap has no endTime entry after selectedFinishTime is returned to the original finish time',
        () {
      sut.sessionForEdit = testSession;
      sut.selectedFinishTime = testSession.endTime;
      sut.changeFinishTime(TimeOfDay(hour: 12, minute: 40));
      sut.changeFinishTime(testSession.endTime);
      expect(sut.changeMap['endTime'], null);
    });
  });

  // test(
  //     'test that SessionEditorFinishedEvent is called if when Done button tappee and changeMap is empty',
  //     () async {
  //   sut.changeMap = testChangeMap;

  //   sut.updateSession();
  //   await untilCalled(mockUpdateSessionWithId(
  //       SessionUpdateParams(sessionId: 1, changeMap: sut.changeMap)));
  //   verifyNever(mockUpdateSessionWithId(
  //       SessionUpdateParams(sessionId: 1, changeMap: sut.changeMap)));

  //   // sut.add(BeginSessionEditingEvent(session: testSession));
  // });

  test('test that UpdateSessionEvent is called if changeMap is not empty',
      () async {
    sut.changeMap = {'test': 'test'};
    sut.updateSession();
    await untilCalled(mockUpdateSessionWithId(
        SessionUpdateParams(sessionId: 1, changeMap: sut.changeMap)));
    verify(mockUpdateSessionWithId(
        SessionUpdateParams(sessionId: 1, changeMap: sut.changeMap)));
  });

  test('test bloc initial state is correct', () {
    expect(sut.initialState, equals(InitialSessionEditorState()));
  });

  group('UpdateSession: ', () {
    test('test that UpdateSessionWithId usecase is called', () async {
      sut.add(UpdateSessionEvent(testChangeMap));
      await untilCalled(mockUpdateSessionWithId(
          SessionUpdateParams(sessionId: 1, changeMap: testChangeMap)));
      verify(mockUpdateSessionWithId(
          SessionUpdateParams(sessionId: 1, changeMap: testChangeMap)));
    });

    test(
        'test that bloc emits [SessionEditorCrudInProgressState, SessionUpdatedState] upon successful update',
        () async {
      when(mockUpdateSessionWithId(
              SessionUpdateParams(sessionId: 1, changeMap: testChangeMap)))
          .thenAnswer((_) async => Right(1));
      final expected = [
        InitialSessionEditorState(),
        SessionEditorCrudInProgressState(),
        SessionUpdatedState()
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(UpdateSessionEvent(testChangeMap));
    });

    test(
        'test that bloc emits [SessionEditorCrudInProgressState, SessionEditorErrorState] when update fails',
        () async {
      when(mockUpdateSessionWithId(
              SessionUpdateParams(sessionId: 1, changeMap: testChangeMap)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        InitialSessionEditorState(),
        SessionEditorCrudInProgressState(),
        SessionEditorErrorState(CACHE_FAILURE_MESSAGE)
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

      //   UseCaseCalledTestFunction func = UseCaseCalledTestFunction();
      //   await func(
      //       bloc: sut,
      //       useCase: mockDeleteSessionWithId,
      //       params: SessionDeleteParams(sessionId: 1),
      //       event: DeleteSessionWithIdEvent(id: 1),
      //       response: 1);
    });

    test(
        'test that bloc emits [SessionEditorCrudInProgressState, SessionDeletedState] upon successful delete',
        () async {
      when(mockDeleteSessionWithId(SessionDeleteParams(sessionId: 1)))
          .thenAnswer((_) async => Right(1));

      final expected = [
        InitialSessionEditorState(),
        SessionEditorCrudInProgressState(),
        SessionDeletedState()
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(DeleteSessionWithIdEvent(id: 1));

      // Either<Failure, int> response = Right(1);
      // BlocEmitsStatesInOrderTest func = BlocEmitsStatesInOrderTest();
      // await func(
      //     bloc: sut,
      //     useCase: mockDeleteSessionWithId,
      //     params: SessionDeleteParams(sessionId: 1),
      //     expectedStates: expected,
      //     event: DeleteSessionWithIdEvent(id: 1),
      //     response: response);
    });
// (type 'Future<Right<Failure, dynamic>>' is not a subtype of type 'Future<Either<Failure, int>>')

    test(
        'test that bloc emits [SessionEditorCrudInProgressState, SessionEditorErrorState] when delete fails',
        () async {
      when(mockDeleteSessionWithId(SessionDeleteParams(sessionId: 1)))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        InitialSessionEditorState(),
        SessionEditorCrudInProgressState(),
        SessionEditorErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(DeleteSessionWithIdEvent(id: 1));
    });
  });

  group('InsertEvents: ', () {
    var testEvent = SkillEvent(
        skillId: 1,
        sessionId: 1,
        duration: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        isComplete: false,
        skillString: 'test');

    List<SkillEvent> events = [testEvent];
    List<int> resultsList = [1];
    test('test that InsertEvents usecase is called', () async {
      // when(mockInsertEventsForSessionUC(
      //         SkillEventMultiInsertParams(events: events, newSessionId: 1)))
      //     .thenAnswer((_) async => Right(resultsList));

      sut.add(InsertEventForSessionEvnt(testEvent));
      await untilCalled(mockInsertEventsForSessionUC(
          SkillEventMultiInsertParams(events: events, newSessionId: 1)));
      verify(mockInsertEventsForSessionUC(
          SkillEventMultiInsertParams(events: events, newSessionId: 1)));

      // UseCaseCalledTestFunction insertfunc = UseCaseCalledTestFunction();
      // await insertfunc(
      //     bloc: sut,
      //     useCase: mockInsertEventsForSessionUC,
      //     params: SkillEventMultiInsertParams(events: events, newSessionId: 1),
      //     event: EventsCreationForExistingSessionEvent(events: events),
      //     response: 1); ??
    });

    test(
        'test that bloc emits [SessionEditorCrudInProgressState, NewEventsCreatedState] upon successful event creation',
        () {
      when(mockInsertEventsForSessionUC(
              SkillEventMultiInsertParams(events: events, newSessionId: 1)))
          .thenAnswer((_) async => Right(resultsList));

      final expected = [
        InitialSessionEditorState(),
        // SessionEditorCrudInProgressState(),
        NewEventsCreatedState()
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(InsertEventForSessionEvnt(testEvent));
    });

    test(
        'test that bloc emits [SessionEditorCrudInProgressState, SessionEditorErrorState] when event creation fails',
        () {
      when(mockInsertEventsForSessionUC(
              SkillEventMultiInsertParams(events: events, newSessionId: 1)))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        InitialSessionEditorState(),
        // SessionEditorCrudInProgressState(),
        SessionEditorErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(InsertEventForSessionEvnt(testEvent));
    });
  });

  group('DeleteEvent: ', () {
    test('test that DeleteEventById usecase is called', () async {
      sut.add(DeleteEventFromSessionEvent(1));
      await untilCalled(
          mockDeleteEventByIdUC(SkillEventGetOrDeleteParams(eventId: 1)));
      verify(mockDeleteEventByIdUC(SkillEventGetOrDeleteParams(eventId: 1)));
    });

    test(
        'test that bloc emits [SessionEditorCrudInProgressState, EventDeletedFromSessionState] upon successful event deletion',
        () {
      when(mockDeleteEventByIdUC(SkillEventGetOrDeleteParams(eventId: 1)))
          .thenAnswer((_) async => Right(1));

      final expected = [
        InitialSessionEditorState(),
        SessionEditorCrudInProgressState(),
        EventDeletedFromSessionState()
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(DeleteEventFromSessionEvent(1));
    });

    test(
        'test that bloc emits [SessionEditorCrudInProgressState, SessionEditorErrorState] when event deletion fails',
        () {
      when(mockDeleteEventByIdUC(SkillEventGetOrDeleteParams(eventId: 1)))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        InitialSessionEditorState(),
        SessionEditorCrudInProgressState(),
        SessionEditorErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(DeleteEventFromSessionEvent(1));
    });
  });

  group('GetEventMapsForSession: ', () {
    test(
        'test that GetEventMapsForSession usecase is called after a BeginSessionEditingEvent is added',
        () async {
      sut.add(BeginSessionEditingEvent(session: testSession));
      await untilCalled(
          mockGetEventMapsForSession(SessionByIdParams(sessionId: 1)));
      verify(mockGetEventMapsForSession(SessionByIdParams(sessionId: 1)));
    });

    test(
        'test that GetEventMapsForSession usecase is called after a RefreshEventsListEvnt is added',
        () async {
      sut.add(RefreshEventsListEvnt());
      await untilCalled(
          mockGetEventMapsForSession(SessionByIdParams(sessionId: 1)));
      verify(mockGetEventMapsForSession(SessionByIdParams(sessionId: 1)));
    });

    test(
        'test that bloc emits [SessionEditorCrudInProgressState, EditingSessionState] when getting Event maps, after a BeginSessionEditingEvent is added.',
        () async {
      // the events list returned by the repo can be an empty list, if there are no events
      when(mockGetEventMapsForSession(SessionByIdParams(sessionId: 1)))
          .thenAnswer((_) async => Right([]));
      final expected = [
        InitialSessionEditorState(),
        SessionEditorCrudInProgressState(),
        EditingSessionState()
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(BeginSessionEditingEvent(session: testSession));
    });

    test(
        'test that bloc emits [SessionEditorCrudInProgressState, EditingSessionState] when getting Event maps, after a RefreshEventsListEvnt is added.',
        () async {
      when(mockGetEventMapsForSession(SessionByIdParams(sessionId: 1)))
          .thenAnswer((_) async => Right([]));
      final expected = [
        InitialSessionEditorState(),
        SessionEditorCrudInProgressState(),
        EditingSessionState()
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(RefreshEventsListEvnt());
    });

    test(
        'test that bloc emits [SessionEditorCrudInProgressState, SessionEditorErrorState] after cache failure getting Event maps.',
        () async {
      // the events list returned by the repo can be an empty list, if there are no events
      when(mockGetEventMapsForSession(SessionByIdParams(sessionId: 1)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        InitialSessionEditorState(),
        SessionEditorCrudInProgressState(),
        SessionEditorErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(BeginSessionEditingEvent(session: testSession));
    });
  });

  group('CompleteSessionAndEvents', () {
    test(
        'test that a CompleteSessionEvent is added when markSessionComplete is called',
        () async {
      sut.markSessionComplete();
      await untilCalled(mockCompleteSessionAndEvents(
          SessionCompleteParams(testSession.sessionId, testSession.date)));
      verify(mockCompleteSessionAndEvents(
          SessionCompleteParams(testSession.sessionId, testSession.date)));
    });

    test(
        'test that CompleteSessionAndEvents usecase is called when a CompleteSessionEvent is called',
        () async {
      sut.add(CompleteSessionEvent());
      await untilCalled(mockCompleteSessionAndEvents(
          SessionCompleteParams(testSession.sessionId, testSession.date)));
      verify(mockCompleteSessionAndEvents(
          SessionCompleteParams(testSession.sessionId, testSession.date)));
    });

    test(
        'test that bloc emits [SessionEditorCrudInProgressState, SessionCompletedState] after a Session is completed',
        () async {
      when(mockCompleteSessionAndEvents(
              SessionCompleteParams(testSession.sessionId, testSession.date)))
          .thenAnswer((_) async => Right(1));
      final expected = [
        InitialSessionEditorState(),
        SessionEditorCrudInProgressState(),
        SessionCompletedState()
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(CompleteSessionEvent());
    });

    test(
        'test that bloc emits [SessionEditorCrudInProgressState, SessionEditorErrorState] after a Session is completion fails',
        () async {
      when(mockCompleteSessionAndEvents(
              SessionCompleteParams(testSession.sessionId, testSession.date)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        InitialSessionEditorState(),
        SessionEditorCrudInProgressState(),
        SessionEditorErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(CompleteSessionEvent());
    });
  });
}
