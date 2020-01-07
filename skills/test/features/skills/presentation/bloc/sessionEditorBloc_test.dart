import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/new_session/bloc.dart';
import 'package:skills/features/skills/presentation/bloc/sessionEditorScreen/bloc.dart';
import '../../mockClasses.dart';

void main() {
  SessionEditorBloc sut;
  MockInsertEventsForSessionUC mockInsertEventsForSessionUC;
  MockUpdateSessionWithId mockUpdateSessionWithId;
  MockDeleteSessionWithId mockDeleteSessionWithId;
  Session testSession;

  setUp(() {
    mockInsertEventsForSessionUC = MockInsertEventsForSessionUC();
    mockUpdateSessionWithId = MockUpdateSessionWithId();
    mockDeleteSessionWithId = MockDeleteSessionWithId();

    sut = SessionEditorBloc(
        updateSessionWithId: mockUpdateSessionWithId,
        deleteSessionWithId: mockDeleteSessionWithId,
        insertEventsForSession: mockInsertEventsForSessionUC);

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

  group('UpdateSession', () {
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
        'test that bloc emits [SessionEditorCrudInProgressState, SessionEditorErrorState] upon unsuccessful update',
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

  group('DeleteSession', (){

  });

  group('InsertEvents', (){

  });

  group('DeleteEvents', (){

  });
}
