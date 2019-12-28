import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/sessionsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import './bloc.dart';

class NewSessionBloc extends Bloc<NewSessionEvent, NewSessionState> {
  final InsertNewSession insertNewSession;
  // final InsertNewSkillEventUC insertNewSkillEventUC;
  final InsertEventsForSessionUC insertEventsForSessionUC;
  TimeOfDay selectedStartTime;
  TimeOfDay selectedFinishTime;
  DateTime sessionDate;
  Skill selectedSkill;
  Session _currentSession;
  List<SkillEvent> _pendingEvents = [];

  int eventDuration;

  int get sessionDuration {
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

  NewSessionBloc({this.insertNewSession, this.insertEventsForSessionUC});

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
      duration: sessionDuration,
      timeRemaining: sessionDuration,
      isCompleted: false,
      isScheduled: false,
    );
    add(InsertNewSessionEvent(newSession: newSession));
  }

  void createEvent(DateTime date) {
    final newEvent = SkillEvent(
        skillId: selectedSkill.id,
        sessionId: 0,
        date: date,
        duration: eventDuration,
        isComplete: false,
        skillString: selectedSkill.name);

    _pendingEvents.add(newEvent);
  }

  @override
  void onTransition(Transition<NewSessionEvent, NewSessionState> transition) {
    super.onTransition(transition);
  }

  @override
  NewSessionState get initialState => InitialNewSessionState();

  @override
  Stream<NewSessionState> mapEventToState(
    NewSessionEvent event,
  ) async* {
    // New Session
    if (event is InsertNewSessionEvent) {
      yield NewSessionCrudInProgressState();
      final failureOrNewSession = await insertNewSession(
          SessionInsertOrUpdateParams(session: event.newSession));
      yield failureOrNewSession.fold(
          (failure) => NewSessionErrorState(CACHE_FAILURE_MESSAGE), (session) {
        _currentSession = session;
        return NewSessionInsertedState(
            newSession: session, events: _pendingEvents);
      });
      //Skill selected
    } else if (event is SkillSelectedForSessionEvent) {
      selectedSkill = event.skill;
      yield SkillSelectedForEventState(skill: event.skill);
      // Creating events after Session is created
    } else if (event is EventsForSessionCreationEvent) {
      yield NewSessionCrudInProgressState();
      final failureOrNewEvents = await insertEventsForSessionUC(
          SkillEventMultiInsertParams(
              events: event.events, newSessionId: event.session.sessionId));
      yield failureOrNewEvents.fold(
          (failure) => NewSessionErrorState(CACHE_FAILURE_MESSAGE),
          (ints) => EventsCreatedForSessionState());
    }

    // else if (event is EventCreationEvent) {
    //   yield NewSessionCrudInProgressState();
    //   // final failureOrNewEvent = await insertNewSkillEventUC(
    //   //     SkillEventInsertOrUpdateParams(event: event.event));
    //   // yield failureOrNewEvent.fold(
    //   //     (failure) => NewSessionErrorState(CACHE_FAILURE_MESSAGE),
    //   //     (newEvent) => SkillEventCreatedState(event: newEvent));
    // }
  }
}
