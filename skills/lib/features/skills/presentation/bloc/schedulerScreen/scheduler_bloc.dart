import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/widgets/CalendarWidgets/calendarControl.dart';
import './bloc.dart';
import 'package:skills/core/tickTock.dart';

class SchedulerBloc extends Bloc<SchedulerEvent, SchedulerState> {
  final GetSessionsInDateRange getSessionsInDateRange;
  final GetEventsForSession getEventsForSession;

  static DateTime activeMonth =
      DateTime(DateTime.now().year, DateTime.now().month, 1, 0);

  static DateTime today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0)
          .toLocal();

  CalendarControl calendarControl = CalendarControl(
      currentMode: CalendarMode.month, keyDate: activeMonth, focusDay: today);

  SchedulerBloc({this.getSessionsInDateRange, this.getEventsForSession}) {
    calendarControl.modeChangeCallback = _calendarModeChanged;
    calendarControl.keyDateChangeCallback = _calendarDateChanged;
  }

  List<Session> sessionsForRange = [];
  DateTime selectedDay;

  List<DateTime> get sessionDates {
    List<DateTime> dates = [];
    for (var session in sessionsForRange) {
      if (dates.indexOf(session.date) == -1) {
        dates.add(session.date);
      }
    }

    return dates;
  }

  List<Session> get daysSessions {
    List<Session> found = [];
    for (var session in sessionsForRange) {
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
    // Handle change of keyDate in calendar, new month, week, day
    if (event is VisibleDateRangeChangeEvent) {
      yield GettingSessionsForDateRangeState();
      final failureOrSessions = await getSessionsInDateRange(
          SessionsInDateRangeParams(event.dateRange));
      yield failureOrSessions.fold(
          (failure) => SchedulerErrorState(CACHE_FAILURE_MESSAGE), (sessions) {
        sessionsForRange = sessions;
        calendarControl.events = sessionsForRange;
        calendarControl.eventDates = sessionDates;
        return SessionsForRangeReturnedState(sessionsForRange);
      });
    }

    // Calendar mode changed
    else if (event is CalendarModeChangedEvent) {
      // get sessions based on mode

      // yield mode changed state so widget can redraw for new mode/layout
    }
    // Day selected
    else if (event is DaySelectedEvent) {
      selectedDay = event.date;
      List<Map> sessionMaps = await _makeSessionMaps(daysSessions);
      yield DaySelectedState(
          date: event.date, sessions: daysSessions, maps: sessionMaps);
    }
  }

  void _calendarDateChanged(int change, CalendarMode mode) {
    add(VisibleDateRangeChangeEvent(calendarControl.dateRange));
  }

  void _calendarModeChanged(CalendarMode mode) {
    add(VisibleDateRangeChangeEvent(calendarControl.dateRange));
    // add(CalendarModeChangedEvent(mode));
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
