import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/data/models/skillEventModel.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/bloc.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/scheduler_bloc.dart';
import 'package:skills/features/skills/presentation/widgets/CalendarWidgets/calendarControl.dart';
import '../../mockClasses.dart';

void main() {
  SchedulerBloc sut;

  MockGetSessionsInDateRange mockGetSessionsInDateRange;
  MockGetEventsForSessionUC mockGetEventsForSessionUC;
  MockGetMapsForSessionsInDateRange mockGetMapsForSessionsInDateRange;

  // MockCalendarControl mockCalendarControl;
  Session testSession;
  Session testSession1;
  Session testSession2;
  Session testSession3;
  List<Session> testList = [testSession];
  final testDateRange = [DateTime(2019, 12, 29), DateTime(2020, 1, 1)];
  Map<String, dynamic> testSessionMap;

  setUp(() {
    mockGetSessionsInDateRange = MockGetSessionsInDateRange();
    mockGetEventsForSessionUC = MockGetEventsForSessionUC();
    mockGetMapsForSessionsInDateRange = MockGetMapsForSessionsInDateRange();
    // mockCalendarControl = MockCalendarControl();
    // mockCalendarControl.currentMode = CalendarMode.month;
    sut = SchedulerBloc(
        getSessionsInDateRange: mockGetSessionsInDateRange,
        getEventsForSession: mockGetEventsForSessionUC,
        getMapsForSessionsInDateRange: mockGetMapsForSessionsInDateRange);
    // sut.calendarControl = mockCalendarControl;

    testSession = Session(
        date: DateTime(2019, 12, 29),
        startTime: TimeOfDay(hour: 12, minute: 0),
        isComplete: false,
        isScheduled: true);

    testSession1 = Session(
        sessionId: 1,
        date: DateTime(2019, 12, 1),
        startTime: TimeOfDay(hour: 12, minute: 0),
        isComplete: false,
        isScheduled: true);

    testSession2 = Session(
        date: DateTime(2019, 12, 2),
        startTime: TimeOfDay(hour: 12, minute: 0),
        isComplete: false,
        isScheduled: true);

    testSession3 = Session(
        date: DateTime(2019, 12, 2),
        startTime: TimeOfDay(hour: 12, minute: 0),
        isComplete: false,
        isScheduled: true);

    testList = [testSession];

    SkillEventModel testEventModel = SkillEventModel(
        eventId: 1,
        skillId: 1,
        sessionId: 1,
        date: DateTime(2019, 12, 29),
        duration: 30,
        isComplete: false,
        skillString: 'test');

    List<SkillEvent> eventsList = [testEventModel];
    testSessionMap = {'session': testSession1, 'events': eventsList};
  });

  test('test bloc initial state is correct', () {
    expect(sut.initialState, equals(InitialSchedulerState()));
  });

  test('test that daysSessions returns correct list of sessions', () {
    sut.sessionsForRange = [testSession1, testSession2, testSession3];
    sut.selectedDay = testSession2.date;

    final matcher = [testSession2, testSession3];
    expect(sut.daysSessions, matcher);
  });

  test('test that sessionDates returns correct list of DateTimes', () {
    sut.sessionsForRange = [testSession1, testSession2, testSession3];
    final matcher = [DateTime(2019, 12, 1), DateTime(2019, 12, 2)];
    final result = sut.sessionDates;
    expect(result, matcher);
  });

  group('DaySelectedEvent', () {
    test(
        'test that bloc emits [DaySelectedState] when DaySelectedEvent is added',
        () async {
      final expected = [
        InitialSchedulerState(),
        DaySelectedState(date: testSession2.date, sessions: sut.daysSessions)
      ];
      sut.add(DaySelectedEvent(testSession2.date));
      expect(sut, emitsInOrder(expected));
    });
  });

  group('GetSessionsInDateRange', () {
    test(
        'test that GetSessionsInDateRange usecase is called when date range changes in Month mode',
        () async {
      when(mockGetSessionsInDateRange(SessionsInDateRangeParams(testDateRange)))
          .thenAnswer((_) async => Right(testList));

      sut.add(VisibleDateRangeChangeEvent(testDateRange));
      await untilCalled(
          mockGetSessionsInDateRange(SessionsInDateRangeParams(testDateRange)));
      verify(
          mockGetSessionsInDateRange(SessionsInDateRangeParams(testDateRange)));
    });

    test(
        'test that bloc emits [SessionsForRangeReturnedState] when VisibleDateRangeChangeEvent event occurs in Month mode',
        () async {
      when(mockGetSessionsInDateRange(SessionsInDateRangeParams(testDateRange)))
          .thenAnswer((_) async => Right(testList));

      final expected = [
        InitialSchedulerState(),
        // GettingSessionsForDateRangeState(),
        SessionsForRangeReturnedState(testList)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(VisibleDateRangeChangeEvent(testDateRange));
    });

    test(
        'test that bloc emits [SchedulerErrorState] when VisibleDateRangeChangeEvent event occurs in Month mode and results in a failure',
        () async {
      when(mockGetSessionsInDateRange(SessionsInDateRangeParams(testDateRange)))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        InitialSchedulerState(),
        // GettingSessionsForDateRangeState(),
        SchedulerErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(VisibleDateRangeChangeEvent(testDateRange));
    });
  });

  group('GetSessionMapsInDateRange', () {
    test(
        'test that GetSessionMapsInDateRange is called when VisibleDateRangeChangeEvent event occurs in Week mode ',
        () async {
      List<Map> testMaps = [testSessionMap];
      sut.calendarControl.currentMode = CalendarMode.week;
      when(mockGetMapsForSessionsInDateRange(
              SessionsInDateRangeParams(testDateRange)))
          .thenAnswer((_) async => Right(testMaps));

      sut.add(VisibleDateRangeChangeEvent(testDateRange));
      await untilCalled(mockGetMapsForSessionsInDateRange(
          SessionsInDateRangeParams(testDateRange)));
      verify(mockGetMapsForSessionsInDateRange(
          SessionsInDateRangeParams(testDateRange)));
    });

    test(
        'test that GetSessionMapsInDateRange is called when VisibleDateRangeChangeEvent event occurs in Day mode ',
        () async {
      List<Map> testMaps = [testSessionMap];
      sut.calendarControl.currentMode = CalendarMode.day;
      when(mockGetMapsForSessionsInDateRange(
              SessionsInDateRangeParams(testDateRange)))
          .thenAnswer((_) async => Right(testMaps));

      sut.add(VisibleDateRangeChangeEvent(testDateRange));
      await untilCalled(mockGetMapsForSessionsInDateRange(
          SessionsInDateRangeParams(testDateRange)));
      verify(mockGetMapsForSessionsInDateRange(
          SessionsInDateRangeParams(testDateRange)));
    });

    test(
        'test that test that GetSessionMapsInDateRange returns [SessionsForRangeReturnedState] on successful call',
        () async {
      List<Map> testMaps = [testSessionMap];
      sut.calendarControl.currentMode = CalendarMode.day;
      when(mockGetMapsForSessionsInDateRange(
              SessionsInDateRangeParams(testDateRange)))
          .thenAnswer((_) async => Right(testMaps));
      final expected = [
        InitialSchedulerState(),
        SessionsForRangeReturnedState(testMaps)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(VisibleDateRangeChangeEvent(testDateRange));
    });

    test(
        'test that test that GetSessionMapsInDateRange returns [SchedulerErrorState] on successful call',
        () async {
      sut.calendarControl.currentMode = CalendarMode.day;
      when(mockGetMapsForSessionsInDateRange(
              SessionsInDateRangeParams(testDateRange)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        InitialSchedulerState(),
        SchedulerErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(VisibleDateRangeChangeEvent(testDateRange));
    });
  });
}
