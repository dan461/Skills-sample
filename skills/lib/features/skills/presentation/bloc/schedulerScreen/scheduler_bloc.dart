import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import './bloc.dart';

class SchedulerBloc extends Bloc<SchedulerEvent, SchedulerState> {
List<Session> sessions;

  @override
  SchedulerState get initialState => InitialSchedulerState();

  @override
  Stream<SchedulerState> mapEventToState(
    SchedulerEvent event,
  ) async* {
    if (event is DaySelectedEvent){
      sessions = [];
      yield DaySelectedState(date: event.date, sessions: sessions);
    }
  }
}
