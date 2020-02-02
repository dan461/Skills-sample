import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/features/skills/presentation/widgets/CalendarWidgets/calendarControl.dart';

abstract class SchedulerEvent extends Equatable {
  const SchedulerEvent();
}

class DaySelectedEvent extends SchedulerEvent {
  final DateTime date;

  DaySelectedEvent(this.date);

  @override
  List<Object> get props => [date];
}

class MonthSelectedEvent extends SchedulerEvent {
  // final DateTime month;
  final int change;

  MonthSelectedEvent({@required this.change});

  @override
  List<Object> get props => [change];
}

class VisibleDateRangeChangeEvent extends SchedulerEvent {
  final List<DateTime> dateRange;

  VisibleDateRangeChangeEvent(this.dateRange);
  
  @override
  List<Object> get props => null;
  
}

class GetSessionsForMonthEvent extends SchedulerEvent {
  // final DateTime month;

  GetSessionsForMonthEvent();

  @override
  List<Object> get props => [];
}

class CalendarModeChangedEvent extends SchedulerEvent {
  final CalendarMode newMode;

  CalendarModeChangedEvent(this.newMode);

  @override
  List<Object> get props => [newMode];
}
