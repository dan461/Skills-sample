import 'package:equatable/equatable.dart';
import 'package:skills/features/skills/domain/entities/session.dart';

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

  DaySelectedState({this.date, this.sessions});

  @override
  List<Object> get props => [date];
}
