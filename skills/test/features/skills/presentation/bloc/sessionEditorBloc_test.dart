import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
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
  Session testSession;

  setUp(() {
    mockInsertEventsForSessionUC = MockInsertEventsForSessionUC();
    mockUpdateSessionWithId = MockUpdateSessionWithId();
    mockDeleteSessionWithId = MockDeleteSessionWithId();
    mockDeleteEventByIdUC = MockDeleteEventByIdUC();
    mockGetEventMapsForSession = MockGetEventMapsForSession();

    sut = SessionEditorBloc(
        updateSessionWithId: mockUpdateSessionWithId,
        deleteSessionWithId: mockDeleteSessionWithId,
        getEventMapsForSession: mockGetEventMapsForSession,
        insertEventsForSession: mockInsertEventsForSessionUC,
        deleteEventByIdUC: mockDeleteEventByIdUC);

    testSession = Session(
        sessionId: 1,
        date: DateTime.now(),
        startTime: TimeOfDay(hour: 12, minute: 0),
        endTime: TimeOfDay(hour: 12, minute: 0),
        isCompleted: false,
        isScheduled: true);

    sut.sessionForEdit = testSession;
  });

  test('test bloc initial state is correct', () {
    expect(sut.initialState, equals(InitialSessionEditorState()));
  });

  group('UpdateSession: ', () {
    Map<String, dynamic> testChangeMap = {};

    test('test that UpdateSessionWithId usecase is called', () async {
      when(mockUpdateSessionWithId(
              SessionUpdateParams(sessionId: 1, changeMap: testChangeMap)))
          .thenAnswer((_) async => Right(1));

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

      sut.add(EventsCreationForExistingSessionEvent(events: events));
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
        SessionEditorCrudInProgressState(),
        NewEventsCreatedState()
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(EventsCreationForExistingSessionEvent(events: events));
    });

    test(
        'test that bloc emits [SessionEditorCrudInProgressState, SessionEditorErrorState] when event creation fails',
        () {
      when(mockInsertEventsForSessionUC(
              SkillEventMultiInsertParams(events: events, newSessionId: 1)))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        InitialSessionEditorState(),
        SessionEditorCrudInProgressState(),
        SessionEditorErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(EventsCreationForExistingSessionEvent(events: events));
    });
  });

  group('DeleteEvent: ', () {
    test('test that DeleteEventById usecase is called', () async {
      sut.add(DeleteEventFromSessionEvent(1));
      await untilCalled(
          mockDeleteEventByIdUC(SkillEventGetOrDeleteParams(eventId: 1)));
      verify(mockDeleteEventByIdUC(SkillEventGetOrDeleteParams(eventId: 1)));

      // UseCaseCalledTestFunction deleteTestfunc = UseCaseCalledTestFunction();
      // await deleteTestfunc(
      //     bloc: sut,
      //     useCase: mockDeleteEventByIdUC,
      //     params: SkillEventGetOrDeleteParams(eventId: 1),
      //     event: DeleteEventFromSessionEvent(1),
      //     response: 1);
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

    test('test that bloc emits [SessionEditorCrudInProgressState, EditingSessionState] when getting Event maps, after a RefreshEventsListEvnt is added.', () async {
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
}
