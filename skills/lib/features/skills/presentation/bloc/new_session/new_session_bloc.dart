import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/usecases/insertNewSession.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import './bloc.dart';

class NewSessionBloc extends Bloc<NewSessionEvent, NewSessionState> {
  final InsertNewSession insertNewSession;
  TimeOfDay selectedStartTime;
  TimeOfDay selectedFinishTime;
  DateTime sessionDate;

  int get duration {
    int minutes;
    if (selectedStartTime == null || selectedFinishTime == null)
      minutes = 0;
    else {
      int hours = selectedFinishTime.hour - selectedStartTime.hour;
      minutes =
          selectedFinishTime.minute - selectedStartTime.minute + hours * 60;
    }
    return minutes;
  }

  NewSessionBloc({this.insertNewSession});

  int timeToInt(DateTime date, TimeOfDay timeOfDay) {
    return DateTime(
            date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute)
        .millisecondsSinceEpoch;
  }

  void createSession(DateTime date) {
    Session newSession = Session(
      date: date.millisecondsSinceEpoch,
      startTime: timeToInt(date, selectedStartTime),
      endTime: timeToInt(date, selectedFinishTime),
      duration: duration,
      timeRemaining: duration,
      isCompleted: false,
      isScheduled: false,
    );
    add(InsertNewSessionEvent(newSession: newSession));
  }

  @override
  NewSessionState get initialState => InitialNewSessionState();

  @override
  Stream<NewSessionState> mapEventToState(
    NewSessionEvent event,
  ) async* {
    if (event is InsertNewSessionEvent) {
      yield NewSessionInsertingState();
      final failureOrNewSession = await insertNewSession(
          SessionInsertOrUpdateParams(session: event.newSession));
      yield failureOrNewSession.fold(
          (failure) => NewSessionErrorState(CACHE_FAILURE_MESSAGE),
          (session) => NewSessionInsertedState(session));
    }
  }
}
