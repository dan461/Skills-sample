import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/widgets/CalendarWidgets/calendarControl.dart';
import 'package:skills/service_locator.dart';
import './bloc.dart';
import 'package:skills/core/tickTock.dart';

class SchedulerBloc extends Bloc<SchedulerEvent, SchedulerState>
    implements CalendarDataSource {
  final GetSessionsInDateRange getSessionsInDateRange;
  final GetSessionMapsInDateRange getInfoForWeekDayMode;
  final GetEventsForSession getEventsForSession;

  @override
  List calendarEvents;

  @override
  void dateRangeCallback(List<DateTime> dateRange) async {
    add(VisibleDateRangeChangeEvent(calendarControl.dateRange));
  }

  @override
  void daySelectedCallback(DateTime date){
    add(DaySelectedEvent(date));
  }

  List<Map> sessionMaps;

  static DateTime activeMonth =
      DateTime(DateTime.now().year, DateTime.now().month, 1, 0);

  static DateTime today = TickTock.today();

  CalendarControl calendarControl = CalendarControl(
      currentMode: CalendarMode.month, keyDate: today, focusDay: today);

  SchedulerBloc(
      {this.getSessionsInDateRange,
      this.getEventsForSession,
      this.getInfoForWeekDayMode}) {
    calendarControl.dataSource = this;
    calendarEvents = sessionsForRange;
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
      // yield GettingSessionsForDateRangeState();

      if (calendarControl.currentMode == CalendarMode.month) {
        final failureOrSessions = await getSessionsInDateRange(
            SessionsInDateRangeParams(event.dateRange));
        yield failureOrSessions
            .fold((failure) => SchedulerErrorState(CACHE_FAILURE_MESSAGE),
                (sessions) {
          sessionsForRange = sessions;

          calendarControl.events = sessionsForRange;
          calendarControl.eventDates = sessionDates;
          return SessionsForRangeReturnedState(sessionsForRange);
        });
      } else {
        final failureOrMaps = await getInfoForWeekDayMode(
            SessionsInDateRangeParams(event.dateRange));
        yield failureOrMaps
            .fold((failure) => SchedulerErrorState(CACHE_FAILURE_MESSAGE),
                (sessionMaps) {
          calendarControl.events = sessionMaps;
          sessionsForRange = [];
          calendarControl.eventDates = sessionDates;
          return SessionsForRangeReturnedState(sessionMaps);
        });
      }
    }

    // Calendar mode changed
    else if (event is CalendarModeChangedEvent) {
    }
    // Day selected
    else if (event is DaySelectedEvent) {
      selectedDay = event.date;
      sessionMaps = await _makeSessionMaps(daysSessions);
      yield DaySelectedState(
          date: event.date, sessions: daysSessions, maps: sessionMaps);
    }
  }

  void _calendarDateChanged(List<DateTime> dateRange) {
    add(VisibleDateRangeChangeEvent(calendarControl.dateRange));
  }

  void _calendarModeChanged(CalendarMode mode) {
    add(VisibleDateRangeChangeEvent(calendarControl.dateRange));
    // add(CalendarModeChangedEvent(mode));
  }

  Future<List<Map>> _makeSessionMaps(List<Session> sessions) async {
    List<Map> sessionMaps = [];
    for (var session in sessions) {
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
