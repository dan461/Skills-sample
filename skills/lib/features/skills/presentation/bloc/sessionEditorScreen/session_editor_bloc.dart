import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:skills/core/tickTock.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/goalUseCases.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import '../../../../../service_locator.dart';
import './bloc.dart';

class SessionEditorBloc extends Bloc<SessionEditorEvent, SessionEditorState> {
  final UpdateSessionWithId updateSessionWithId;
  final DeleteSessionWithId deleteSessionWithId;
  final GetEventMapsForSession getEventMapsForSession;
  final InsertEventsForSessionUC insertEventsForSession;
  final DeleteEventByIdUC deleteEventByIdUC;

  SessionEditorBloc(
      {this.updateSessionWithId,
      this.deleteSessionWithId,
      this.getEventMapsForSession,
      this.insertEventsForSession,
      this.deleteEventByIdUC});

  TimeOfDay selectedStartTime;
  TimeOfDay selectedFinishTime;
  DateTime sessionDate;

  Session sessionForEdit;
  Skill selectedSkill;
  Goal currentGoal;
  var pendingEvents = <SkillEvent>[];
  List<Map> eventMapsForListView = [];

  Map<String, dynamic> changeMap = {};

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

  int completedEventsCount = 0;

  void _countCompletedEvents() {
    int count = 0;
    for (var map in eventMapsForListView) {
      SkillEvent event = map['event'];
      if (event.isComplete) count++;
    }
    completedEventsCount = count;
  }

  void changeDate(DateTime newDate) {
    sessionDate = newDate;
    if (sessionForEdit.date.compareTo(sessionDate) != 0) {
      changeMap.addAll({'date': sessionDate.millisecondsSinceEpoch});
    } else {
      changeMap.remove('date');
    }

    print(changeMap);
  }

  void changeStartTime(TimeOfDay newTime) {
    // if changing back to original start time
    if (TickTock.timesAreEqual(newTime, sessionForEdit.startTime)) {
      changeMap.remove('startTime');
    } else {
      int startInt = TickTock.timeToInt(newTime);
      changeMap.addAll({'startTime': startInt});
    }

    selectedStartTime = newTime;
  }

  void changeFinishTime(TimeOfDay newTime) {
    if (TickTock.timesAreEqual(newTime, sessionForEdit.endTime)) {
      changeMap.remove('endTime');
    } else {
      int endInt = TickTock.timeToInt(newTime);
      changeMap.addAll({'endTime': endInt});
    }

    selectedFinishTime = newTime;
  }

  void updateSession() {
    if (changeMap.isNotEmpty) {
      add(UpdateSessionEvent(changeMap));
    } else {
      add(SessionEditorFinishedEvent());
    }
  }

  void markSessionComplete(){
    changeMap.addAll({'isComplete' : 1});
  }

  void deleteSession() {
    add(DeleteSessionWithIdEvent(id:sessionForEdit.sessionId));
  }

  void createEvent(int eventDuration) {
    final newEvent = SkillEvent(
        skillId: selectedSkill.skillId,
        sessionId: sessionForEdit.sessionId,
        date: sessionDate,
        duration: eventDuration,
        isComplete: false,
        skillString: selectedSkill.name);
    add(InsertEventForSessionEvnt(newEvent));

    selectedSkill = null;
  }

  void deleteEvent(Map<String, dynamic> eventMap) {
    SkillEvent event = eventMap['event'];
    if (event.eventId == null) {
      eventMapsForListView.remove(eventMap);
      pendingEvents.remove(eventMap['event']);
    } else {
      // delete cached Event
      add(DeleteEventFromSessionEvent(event.eventId));
    }
  }

  @override
  void onTransition(
      Transition<SessionEditorEvent, SessionEditorState> transition) {
    super.onTransition(transition);
  }

  @override
  SessionEditorState get initialState => InitialSessionEditorState();

  Function errorStateResponse =
      (failure) => SessionEditorErrorState(CACHE_FAILURE_MESSAGE);

  @override
  Stream<SessionEditorState> mapEventToState(
    SessionEditorEvent event,
  ) async* {
    // Begin editing
    if (event is BeginSessionEditingEvent) {
      sessionForEdit = event.session;
      selectedStartTime = sessionForEdit.startTime;
      selectedFinishTime = sessionForEdit.endTime;
      sessionDate = sessionForEdit.date;
      yield SessionEditorCrudInProgressState();

      // Get Events - RefreshList
      // add(RefreshEventsListEvnt());
      final eventMapsOrFailure = await getEventMapsForSession(
          SessionByIdParams(sessionId: sessionForEdit.sessionId));

      yield eventMapsOrFailure.fold(
          (failure) => SessionEditorErrorState(CACHE_FAILURE_MESSAGE), (maps) {
        eventMapsForListView = maps;
        _countCompletedEvents();
        return EditingSessionState();
      });
    }

    // Update Session
    else if (event is UpdateSessionEvent) {
      yield SessionEditorCrudInProgressState();
      final updateOrFailure = await updateSessionWithId(SessionUpdateParams(
          sessionId: sessionForEdit.sessionId, changeMap: changeMap));
      yield updateOrFailure.fold(
          errorStateResponse, (result) => SessionUpdatedState());
    }

    // Delete Session
    else if (event is DeleteSessionWithIdEvent) {
      yield SessionEditorCrudInProgressState();
      final deleteOrFailure = await deleteSessionWithId(
          SessionDeleteParams(sessionId: sessionForEdit.sessionId));
      yield deleteOrFailure.fold(
          errorStateResponse, (response) => SessionDeletedState());
    }

    // Skill selected for new event
    else if (event is SkillSelectedForExistingSessionEvent) {
      selectedSkill = event.skill;
      if (selectedSkill.currentGoalId != 0) {
        var getGoal = locator<GetGoalById>();
        final goalOrFail =
            await getGoal(GoalCrudParams(id: selectedSkill.currentGoalId));
        yield goalOrFail
            .fold((failure) => SessionEditorErrorState(CACHE_FAILURE_MESSAGE),
                (goal) {
          currentGoal = goal;
          return SkillSelectedForSessionEditorState(skill: selectedSkill);
        });
      } else {
        yield SkillSelectedForSessionEditorState(skill: selectedSkill);
      }
    }

    // Create new SkillEvent for Session
    else if (event is InsertEventForSessionEvnt) {
      final eventsOrFailure = await insertEventsForSession(
          SkillEventMultiInsertParams(
              events: [event.event], newSessionId: sessionForEdit.sessionId));

      yield eventsOrFailure.fold(
          (failure) => SessionEditorErrorState(CACHE_FAILURE_MESSAGE),
          (results) => NewEventsCreatedState());
    }

    // Delete an Event
    else if (event is DeleteEventFromSessionEvent) {
      yield SessionEditorCrudInProgressState();
      final deleteOrFailure = await deleteEventByIdUC(
          SkillEventGetOrDeleteParams(eventId: event.eventId));
      yield deleteOrFailure.fold(
          errorStateResponse, (reply) => EventDeletedFromSessionState());
    }

    // Refresh Events List
    else if (event is RefreshEventsListEvnt) {
      yield SessionEditorCrudInProgressState();
      final eventMapsOrFailure = await getEventMapsForSession(
          SessionByIdParams(sessionId: sessionForEdit.sessionId));
      yield eventMapsOrFailure.fold(
          (failure) => SessionEditorErrorState(CACHE_FAILURE_MESSAGE), (maps) {
        eventMapsForListView = maps;
        _countCompletedEvents();
        return EditingSessionState();
      });
    }

    // Finished Editing with no changes to save
    else if (event is SessionEditorFinishedEvent) {
      yield SessionEditorFinishedEditingState();
    }
  }
}
