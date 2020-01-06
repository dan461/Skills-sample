import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/goalUseCases.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/service_locator.dart';
import './bloc.dart';

class NewSessionBloc extends Bloc<NewSessionEvent, NewSessionState> {
  final InsertNewSession insertNewSession;
  // final InsertNewSkillEventUC insertNewSkillEventUC;
  final InsertEventsForSessionUC insertEventsForSessionUC;
  final GetEventsForSession getEventsForSession;
  final GetEventMapsForSession getEventMapsForSession;

  NewSessionBloc(
      {this.insertNewSession,
      this.insertEventsForSessionUC,
      this.getEventsForSession,
      this.getEventMapsForSession});

  TimeOfDay selectedStartTime;
  TimeOfDay selectedFinishTime;
  DateTime sessionDate;
  Skill selectedSkill;
  Goal currentGoal;
  Session sessionForEdit;
  var pendingEvents = <SkillEvent>[];
  var pendingEventMapsForListView = <Map>[];
  var eventMapsForSession = <Map>[];

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

  void updateSession() {
    /* possible changes 
      - new date
      - new start time
      - new end time
      - new duration (should probably be a computed property of Session)
      - isCompleted status changed to true
    */

    Map<String, dynamic> changeMap = {'sessionId': sessionForEdit.sessionId};

    if (sessionDate != sessionForEdit.date)
      

    if (selectedStartTime != sessionForEdit.startTime)
      changeMap.addEntries([MapEntry('startTime', selectedStartTime)]);

    if (selectedFinishTime != sessionForEdit.endTime)
      changeMap.addEntries([MapEntry('endTime', selectedFinishTime)]);

    if (changeMap.isNotEmpty){}
      // add(UpdateSessionEvent())
  }

  void createEvent(DateTime date) {
    final newEvent = SkillEvent(
        skillId: selectedSkill.skillId,
        sessionId: 0,
        date: date,
        duration: eventDuration,
        isComplete: false,
        skillString: selectedSkill.name);

    pendingEvents.add(newEvent);

    if (sessionForEdit == null) {
      Map<String, dynamic> map = {
        'event': newEvent,
        'skill': selectedSkill,
        'goal': currentGoal
      };
      pendingEventMapsForListView.add(map);
    }
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
    if (event is BeginSessionEditingEvent) {
      sessionForEdit = event.session;
      selectedStartTime = sessionForEdit.startTime;
      selectedFinishTime = sessionForEdit.endTime;
      sessionDate = sessionForEdit.date;
      // get session's events
      final infoMapsOrFailure = await getEventMapsForSession(
          SessionByIdParams(sessionId: event.session.sessionId));
      yield infoMapsOrFailure.fold(
          (failure) => NewSessionErrorState(CACHE_FAILURE_MESSAGE), (maps) {
        eventMapsForSession = maps;
        return EditingSessionState(event.session, maps);
      });
    }
    // Cache New Session
    else if (event is InsertNewSessionEvent) {
      yield NewSessionCrudInProgressState();
      final failureOrNewSession = await insertNewSession(
          SessionInsertOrUpdateParams(session: event.newSession));
      yield failureOrNewSession.fold(
          (failure) => NewSessionErrorState(CACHE_FAILURE_MESSAGE), (session) {
        // _currentSession = session;
        return NewSessionInsertedState(
            newSession: session, events: pendingEvents);
      });
    }
    // Update Session
    else if (event is UpdateSessionEvent) {
      // use changeMap to update session
      // create UpdateSession UC
    }
    //Skill selected
    else if (event is SkillSelectedForSessionEvent) {
      selectedSkill = event.skill;
      if (selectedSkill.currentGoalId != 0) {
        var getGoal = locator<GetGoalById>();
        final goalOrFail =
            await getGoal(GoalCrudParams(id: selectedSkill.currentGoalId));
        yield goalOrFail.fold(
            (failure) => NewSessionErrorState(CACHE_FAILURE_MESSAGE), (goal) {
          currentGoal = goal;
          return SkillSelectedForEventState(skill: selectedSkill);
        });
      } else
        yield SkillSelectedForEventState(skill: selectedSkill);

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
  }
}
