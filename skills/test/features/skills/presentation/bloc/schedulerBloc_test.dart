import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/bloc.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/scheduler_bloc.dart';
import '../../mockClasses.dart';

void main() {
  SchedulerBloc sut;

  MockGetSessionsInDateRange mockGetSessionsInDateRange;
  MockCalendarControl mockCalendarControl;
  Session testSession;
  Session testSession1;
  Session testSession2;
  Session testSession3;
  final testMonth = DateTime(2019, 12);
  final testDateRange = [DateTime(2019, 12, 29), DateTime(2020, 1, 1)];

  setUp(() {
    mockGetSessionsInDateRange = MockGetSessionsInDateRange();
    mockCalendarControl = MockCalendarControl();

    sut = SchedulerBloc(getSessionsInDateRange: mockGetSessionsInDateRange);
    sut.calendarControl = mockCalendarControl;
    // sut.activeMonth = testMonth;
    testSession = Session(
        date: DateTime.now(),
        startTime: TimeOfDay(hour: 12, minute: 0),
        endTime: TimeOfDay(hour: 12, minute: 0),
        isComplete: false,
        isScheduled: true);

    testSession1 = Session(
        date: DateTime(2019, 12, 1),
        startTime: TimeOfDay(hour: 12, minute: 0),
        endTime: TimeOfDay(hour: 12, minute: 0),
        isComplete: false,
        isScheduled: true);

    testSession2 = Session(
        date: DateTime(2019, 12, 2),
        startTime: TimeOfDay(hour: 12, minute: 0),
        endTime: TimeOfDay(hour: 12, minute: 0),
        isComplete: false,
        isScheduled: true);

    testSession3 = Session(
        date: DateTime(2019, 12, 2),
        startTime: TimeOfDay(hour: 12, minute: 0),
        endTime: TimeOfDay(hour: 12, minute: 0),
        isComplete: false,
        isScheduled: true);
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

  // test(
  //     'test that bloc emits [GettingSessionsForMonthState] when MonthSelectedEvent is added',
  //     () async {
  //   sut.add(MonthSelectedEvent(change: 0));

  //   final expected = [InitialSchedulerState(), GettingSessionsForMonthState()];
  //   expect(sut, emitsInOrder(expected));
  // });

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
    final testList = [testSession];

    test('test that GetSessionsInDateRange usecase is called', () async {
      when(mockGetSessionsInDateRange(SessionsInDateRangeParams(testDateRange)))
          .thenAnswer((_) async => Right(testList));

      sut.add(VisibleDateRangeChangeEvent(testDateRange));
      await untilCalled(
          mockGetSessionsInDateRange(SessionsInDateRangeParams(testDateRange)));
      verify(mockGetSessionsInDateRange(SessionsInDateRangeParams(testDateRange)));
    });

    test(
        'test that bloc emits [GettingSessionsForDateRangeState, SessionsForRangeReturnedState] when VisibleDateRangeChangeEvent event occurs',
        () async {
      when(mockGetSessionsInDateRange(SessionsInDateRangeParams(testDateRange)))
          .thenAnswer((_) async => Right(testList));

      final expected = [
        InitialSchedulerState(),
        GettingSessionsForDateRangeState(),
        SessionsForRangeReturnedState(testList)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(VisibleDateRangeChangeEvent(testDateRange));
    });
  });
}
