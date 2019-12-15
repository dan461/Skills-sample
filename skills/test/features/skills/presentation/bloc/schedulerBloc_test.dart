import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/flutter_test.dart' as prefix0;
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/bloc.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/scheduler_bloc.dart';
import '../../mockClasses.dart';

void main() {
  SchedulerBloc sut;

  MockGetSessionsInMonthUC mockGetSessionsInMonthUC;
  Session testSession;
  Session testSession1;
  Session testSession2;
  Session testSession3;

  setUp(() {
    mockGetSessionsInMonthUC = MockGetSessionsInMonthUC();
    sut = SchedulerBloc(getSessionInMonth: mockGetSessionsInMonthUC);
    testSession = Session(
        date: 1,
        startTime: 1,
        endTime: 1,
        isCompleted: false,
        isScheduled: true);

    testSession1 = Session(
        date: DateTime(2019, 12, 1).millisecondsSinceEpoch,
        startTime: 1,
        endTime: 1,
        isCompleted: false,
        isScheduled: true);

    testSession2 = Session(
        date: DateTime(2019, 12, 2).millisecondsSinceEpoch,
        startTime: 1,
        endTime: 1,
        isCompleted: false,
        isScheduled: true);

    testSession3 = Session(
        date: DateTime(2019, 12, 2).millisecondsSinceEpoch,
        startTime: 1,
        endTime: 1,
        isCompleted: false,
        isScheduled: true);
  });

  test('test bloc initial state is correct', () {
    expect(sut.initialState, equals(InitialSchedulerState()));
  });

  test('test that findDaysSession() returns correct list of sessions', () {
    sut.sessionsForMonth = [testSession1, testSession2, testSession3];
    final result = sut.findDaysSessions(DateTime(2019, 12, 2));
    final matcher = [testSession2, testSession3];
    expect(result, matcher);
  });

  test('test that sessionDates returns correct list of DateTimes', () {
    sut.sessionsForMonth = [testSession1, testSession2, testSession3];
    final matcher = [DateTime(2019, 12, 1), DateTime(2019, 12, 2)];
    final result = sut.sessionDates;
    expect(result, matcher);
  });

  test('test that bloc emits [DaySelectedState] when DaySelectedEvent occurs',
      () async {
    // TODO - intentionally bad test, finish this
    final expected = [InitialSchedulerState(), DaySelectedState()];
    expectLater(sut, emitsInOrder(expected));
    sut.add(DaySelectedEvent(DateTime.now()));
  });

  group('GetSessionsInMonth', () {
    final testList = [testSession];
    final testMonth = DateTime(2019, 12);
    test('test that GetSessionsInMonth usecase is called', () async {
      when(mockGetSessionsInMonthUC(SessionInMonthParams(testMonth)))
          .thenAnswer((_) async => Right(testList));
      sut.add(MonthSelectedEvent(testMonth));
      await untilCalled(
          mockGetSessionsInMonthUC(SessionInMonthParams(testMonth)));
      verify(mockGetSessionsInMonthUC(SessionInMonthParams(testMonth)));
    });

    test(
        'test that bloc emits [GettingSessionForMonthState, SessionsForMonthReturnedState] when MonthSelectedEvent event occurs',
        () async {
      when(mockGetSessionsInMonthUC(SessionInMonthParams(testMonth)))
          .thenAnswer((_) async => Right(testList));

      final expected = [
        InitialSchedulerState(),
        GettingSessionForMonthState(),
        SessionsForMonthReturnedState(testList)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(MonthSelectedEvent(testMonth));
    });
  });
}
