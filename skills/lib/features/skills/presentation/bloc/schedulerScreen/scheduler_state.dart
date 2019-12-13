import 'package:equatable/equatable.dart';

abstract class SchedulerState extends Equatable {
  const SchedulerState();
}

class InitialSchedulerState extends SchedulerState {
  @override
  List<Object> get props => [];
}
