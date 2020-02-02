import 'package:equatable/equatable.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/scheduler_event.dart';
import 'package:skills/features/skills/presentation/widgets/CalendarWidgets/calendarControl.dart';

abstract class SchedulerState extends Equatable {
  const SchedulerState();
}

class InitialSchedulerState extends SchedulerState {
  @override
  List<Object> get props => [];
}

class DaySelectedState extends SchedulerState {
  final DateTime date;
  final List<Session> sessions;
  final List<Map> maps;

  DaySelectedState({this.date, this.sessions, this.maps});

  @override
  List<Object> get props => [date];
}

class GettingSessionsForDateRangeState extends SchedulerState {
  @override
  List<Object> get props => [null];
}

class SessionsForMonthReturnedState extends SchedulerState {
  final List<Session> sessionsList;

  SessionsForMonthReturnedState(this.sessionsList);

  @override
  List<Object> get props => [sessionsList];
}

class SessionsForRangeReturnedState extends SchedulerState {
  final List<Session> sessionsList;

  SessionsForRangeReturnedState(this.sessionsList);

  @override
  List<Object> get props => [sessionsList];
}

class SchedulerErrorState extends SchedulerState {
  final String message;

  SchedulerErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class NewCalendarModeState extends SchedulerState {
  final CalendarMode newMode;

  NewCalendarModeState(this.newMode);

  @override
  List<Object> get props => [newMode];
}
