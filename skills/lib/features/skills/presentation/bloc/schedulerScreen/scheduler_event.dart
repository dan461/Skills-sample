import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

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

class GetSessionsForMonthEvent extends SchedulerEvent {
  // final DateTime month;

  GetSessionsForMonthEvent();

  @override
  List<Object> get props => [];
}
