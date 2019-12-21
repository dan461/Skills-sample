import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/usecases/sessionsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import './bloc.dart';

class NewSessionBloc extends Bloc<NewSessionEvent, NewSessionState> {
  final InsertNewSession insertNewSession;
  final InsertNewSkillEventUC insertNewSkillEventUC;
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

  NewSessionBloc({this.insertNewSession, this.insertNewSkillEventUC});

// TODO - should entities and models use DateTime and TimeOfDay and convert to/from ints in toMap/fromMap?
  int timeToInt(DateTime date, TimeOfDay timeOfDay) {
    return DateTime(
            date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute)
        .millisecondsSinceEpoch;
  }

  void createSession(DateTime date) {
    Session newSession = Session(
      date: date,
      startTime: selectedStartTime,
      endTime: selectedFinishTime,
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
    } else if (event is SkillSelectedForSessionEvent) {
      yield SkillSelectedForEventState(skill: event.skill);
    } else if (event is EventCreationEvent) {
      yield NewSessionCrudInProgressState();
      final failureOrNewEvent = await insertNewSkillEventUC(
          SkillEventInsertOrUpdateParams(event: event.event));
      yield failureOrNewEvent.fold(
          (failure) => NewSessionErrorState(CACHE_FAILURE_MESSAGE),
          (newEvent) => SkillEventCreatedState(event: newEvent));
    }
  }
}
