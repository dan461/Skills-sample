import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/widgets/calendarControl.dart';
import './bloc.dart';
import 'package:skills/core/tickTock.dart';

class SchedulerBloc extends Bloc<SchedulerEvent, SchedulerState> {
  final GetSessionsInMonth getSessionInMonth;
  final GetEventsForSession getEventsForSession;

  static DateTime activeMonth =
      DateTime(DateTime.now().year, DateTime.now().month);

  static DateTime today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toLocal();

  CalendarControl calendarControl = CalendarControl(
      currentMode: CalendarMode.month,
      keyDate: activeMonth,
      focusDay: today,
      modeChangeCallback: _calendarModeChanged,
      keyDateChangeCallback: _calendarDateChanged);

  SchedulerBloc({this.getSessionInMonth, this.getEventsForSession});

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

    // Month selected
    // change to handle change of keyDate in calendar, new month, week, day
    if (event is MonthSelectedEvent) {
      activeMonth = TickTock.changeMonth(activeMonth, event.change);
      yield GettingSessionsForMonthState();
    } 
    
    // Get sessions for month
    else if (event is GetSessionsForMonthEvent) {
      final failureOrSessions =
          await getSessionInMonth(SessionInMonthParams(activeMonth));
      yield failureOrSessions.fold(
          (failure) => SchedulerErrorState(CACHE_FAILURE_MESSAGE), (sessions) {
        sessionsForMonth = sessions;
        calendarControl.eventDates = sessionDates;
        return SessionsForMonthReturnedState(sessions);
      });
    } 

    // Get sessions for week

    // Calendar mode changed
    
    // Day selected
    else if (event is DaySelectedEvent) {
      selectedDay = event.date;
      List<Map> sessionMaps = await _makeSessionMaps(daysSessions);
      yield DaySelectedState(
          date: event.date, sessions: daysSessions, maps: sessionMaps);
    }
  }

  static void _calendarDateChanged(int change) {
    print(change);
  }

  static void _calendarModeChanged(CalendarMode mode) {

  }

  Future<List<Map>> _makeSessionMaps(List<Session> sessions) async {
    List<Map> sessionMaps = [];
    for (var session in daysSessions) {
      List<SkillEvent> events = [];
      var eventsOrFail = await getEventsForSession(
          SessionByIdParams(sessionId: session.sessionId));
      eventsOrFail.fold((failure) => SchedulerErrorState(CACHE_FAILURE_MESSAGE),
          (result) {
        events = result;
      });
      Map<String, dynamic> sessionMap = {'session': session, 'events': events};
      sessionMaps.add(sessionMap);
    }

    return sessionMaps;
  }
}
