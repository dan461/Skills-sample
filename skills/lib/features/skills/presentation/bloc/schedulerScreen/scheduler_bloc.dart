import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/usecases/sessionsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import './bloc.dart';
import 'package:skills/core/aboutTime.dart';

class SchedulerBloc extends Bloc<SchedulerEvent, SchedulerState> {
  final GetSessionsInMonth getSessionInMonth;

  DateTime activeMonth = DateTime(DateTime.now().year, DateTime.now().month);

  SchedulerBloc({this.getSessionInMonth});

  List<Session> sessionsForMonth = [];
  DateTime selectedDay;

  List<DateTime> get sessionDates {
    List<DateTime> dates = [];
    for (var session in sessionsForMonth) {
      if (dates.indexOf(session.date) == -1) {
        dates.add(session.date);
      }
    }

    return dates;
  }

  List<Session> get daysSessions {
    List<Session> found = [];
    for (var session in sessionsForMonth) {
      if (session.date == selectedDay) {
        found.add(session);
      }
    }
    return found;
  }

  @override
  SchedulerState get initialState => InitialSchedulerState();

  @override
  void onTransition(Transition<SchedulerEvent, SchedulerState> transition) {
    print(transition);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
  }

  @override
  Stream<SchedulerState> mapEventToState(
    SchedulerEvent event,
  ) async* {
    if (event is MonthSelectedEvent) {
      activeMonth = AboutTime.changeMonth(activeMonth, event.change);
      // _changeMonth(event.change);
      yield GettingSessionsForMonthState();
    } else if (event is GetSessionsForMonthEvent) {
      final failureOrSessions =
          await getSessionInMonth(SessionInMonthParams(activeMonth));
      yield failureOrSessions.fold(
          (failure) => SchedulerErrorState(CACHE_FAILURE_MESSAGE), (sessions) {
        sessionsForMonth = sessions;
        return SessionsForMonthReturnedState(sessions);
      });
    } else if (event is DaySelectedEvent) {
      selectedDay = event.date;
      yield DaySelectedState(date: event.date, sessions: daysSessions);
    }
  }
}
