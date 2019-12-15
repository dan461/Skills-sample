import 'package:equatable/equatable.dart';

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
  final DateTime month;

  MonthSelectedEvent(this.month);

  @override
  List<Object> get props => [month];
}
