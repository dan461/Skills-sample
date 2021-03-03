import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/activityUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/widgets/CalendarWidgets/calendarControl.dart';
import './bloc.dart';
import 'package:skills/core/tickTock.dart';

class SchedulerBloc extends Bloc<SchedulerEvent, SchedulerState>
    implements CalendarDataSource {
  final GetSessionsInDateRange getSessionsInDateRange;
  final GetMapsForSessionsInDateRange getMapsForSessionsInDateRange;
  final GetActivitiesForSession getActiviesForSession;

  @override
  List calendarEvents;

  // CalendarDataSource
  @override
  void dateRangeCallback(List<DateTime> dateRange) async {
    // TODO - Optimize with conditional db calls only when new dateRange is outside of existing range
    add(VisibleDateRangeChangeEvent(calendarControl.dateRange));
  }

  // CalendarDataSource
  @override
  void daySelectedCallback(DateTime date) {
    add(DaySelectedEvent(date));
  }

  List<Map> sessionMaps;

  // static DateTime activeMonth =
  //     DateTime(DateTime.now().year, DateTime.now().month, 1, 0);

  static DateTime today = TickTock.today();

  CalendarControl calendarControl = CalendarControl(
      currentMode: CalendarMode.month, keyDate: today, focusDay: today);

  SchedulerBloc(
      {this.getSessionsInDateRange,
      this.getActiviesForSession,
      this.getMapsForSessionsInDateRange})
      : super(InitialSchedulerState()) {
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
        final failureOrMaps = await getMapsForSessionsInDateRange(
            SessionsInDateRangeParams(event.dateRange));
        yield failureOrMaps
            .fold((failure) => SchedulerErrorState(CACHE_FAILURE_MESSAGE),
                (sessionMaps) {
          calendarControl.events =
              _sessionsFromMaps(sessionMaps, calendarControl.currentMode);
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

  // void _calendarDateChanged(List<DateTime> dateRange) {
  //   add(VisibleDateRangeChangeEvent(calendarControl.dateRange));
  // }

  // void _calendarModeChanged(CalendarMode mode) {
  //   add(VisibleDateRangeChangeEvent(calendarControl.dateRange));
  //   // add(CalendarModeChangedEvent(mode));
  // }

  List<Session> _sessionsFromMaps(List<Map> sessionMaps, CalendarMode mode) {
    List<Session> sessions = [];
    for (var map in sessionMaps) {
      Session thisSession = map['session'];
      // if (mode == CalendarMode.week)
      thisSession.weekView = _makeWeekView(map);
      // else if (mode == CalendarMode.day)
      thisSession.dayView = _makeDaySessionView(map);

      sessions.add(thisSession);
    }
    return sessions;
  }

  Container _makeWeekView(Map sessionMap) {
    var session = sessionMap['session'];
    var activities = sessionMap['activities'];

    return Container(
      padding: EdgeInsets.only(left: 2, right: 6),
      margin: EdgeInsets.all(2),
      color: Colors.amber[200],
      child: Builder(
        builder: (BuildContext context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(session.startTime.format(context),
                      style: Theme.of(context).textTheme.bodyText1)
                ],
              ),
              Text('${session.duration} min',
                  style: Theme.of(context).textTheme.bodyText2),
              Text('${activities.length} actvities',
                  style: Theme.of(context).textTheme.bodyText2),
              Text('${session.timeRemaining} min. open',
                  style: Theme.of(context).textTheme.bodyText2)
            ],
          );
        },
      ),
    );
  }

  Container _makeDaySessionView(Map sessionMap) {
    // Session session = sessionMap['session'];
    List activities = sessionMap['activities'];

    List<Row> rows = [_infoRow(sessionMap)];
    for (var event in activities) {
      rows.add(_activityRow(event));
    }

    return Container(child: Column(children: rows));
  }

  Row _infoRow(Map event) {
    Session session = event['session'];
    List activities = event['activities'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('${session.duration}min'),
        Text('${session.timeRemaining}min open'),
        Text('${activities.length} activities'),
      ],
    );
  }

  Row _activityRow(Activity event) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text('${event.skillString}'),
        Text('${event.duration} min.')
      ],
    );
  }

  Future<List<Map>> _makeSessionMaps(List<Session> sessions) async {
    List<Map> sessionMaps = [];
    for (var session in sessions) {
      List<Activity> activities = [];
      var activitiesOrFail = await getActiviesForSession(
          SessionByIdParams(sessionId: session.sessionId));
      activitiesOrFail.fold(
          (failure) => SchedulerErrorState(CACHE_FAILURE_MESSAGE), (result) {
        activities = result;
      });
      Map<String, dynamic> sessionMap = {
        'session': session,
        'activities': activities
      };
      sessionMaps.add(sessionMap);
    }

    return sessionMaps;
  }
}
