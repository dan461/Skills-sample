import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/usecases/sessionsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import './bloc.dart';

class SchedulerBloc extends Bloc<SchedulerEvent, SchedulerState> {
  // List<Session> sessions;
  final GetSessionsInMonth getSessionInMonth;
  List<Session> daysSessions;

  SchedulerBloc({this.getSessionInMonth});
  // List<Session> sessionsList;
  List<Session> sessionsForMonth;

  List<DateTime> get sessionDates {
    List<DateTime> dates = [];
    for (var session in sessionsForMonth) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(session.date);
      if (dates.indexOf(date) == -1) {
        dates.add(date);
      }
    }

    return dates;
  }

  @override
  SchedulerState get initialState => InitialSchedulerState();

  List<Session> findDaysSessions(DateTime day) {
    List<Session> found = [];
    for (var session in sessionsForMonth) {
      if (session.date == day.millisecondsSinceEpoch) {
        found.add(session);
      }
    }
    return found;
  }

  @override
  Stream<SchedulerState> mapEventToState(
    SchedulerEvent event,
  ) async* {
    if (event is MonthSelectedEvent) {
      yield GettingSessionForMonthState();
      final failureOrSessions =
          await getSessionInMonth(SessionInMonthParams(event.month));
      yield failureOrSessions.fold(
          (failure) => SchedulerErrorState(CACHE_FAILURE_MESSAGE), (sessions) {
        sessionsForMonth = sessions;
        return SessionsForMonthReturnedState(sessions);
      });
    } else if (event is DaySelectedEvent) {
      daysSessions = findDaysSessions(event.date);
      yield DaySelectedState(date: event.date, sessions: daysSessions);
    }
  }
}
