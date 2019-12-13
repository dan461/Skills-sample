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
