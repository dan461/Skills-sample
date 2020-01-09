import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
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
  int eventDuration;

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
      // pendingEventMapsForListView.add(map);
    }
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
      // Get Events
      final eventMapsOrFailure = await getEventMapsForSession(
          SessionByIdParams(sessionId: sessionForEdit.sessionId));
      eventMapsOrFailure.fold((failure) => SessionEditorErrorState(CACHE_FAILURE_MESSAGE), (maps) {
        eventMapsForListView = maps;
      });
      yield EditingSessionState();
    }

    // Update Session
    else if (event is UpdateSessionEvent) {
      yield SessionEditorCrudInProgressState();
      final updateOrFailure = await updateSessionWithId(SessionUpdateParams(
          sessionId: sessionForEdit.sessionId, changeMap: changeMap));
      yield updateOrFailure.fold(
          errorStateResponse, (result) => SessionUpdatedState());

      // Delete Session
    } else if (event is DeleteSessionWithIdEvent) {
      yield SessionEditorCrudInProgressState();
      final deleteOrFailure = await deleteSessionWithId(
          SessionDeleteParams(sessionId: sessionForEdit.sessionId));
      yield deleteOrFailure.fold(
          errorStateResponse, (response) => SessionDeletedState());

      // Create Events for Session
    } else if (event is EventsCreationForExistingSessionEvent) {
      yield SessionEditorCrudInProgressState();
      final eventsOrFailure = await insertEventsForSession(
          SkillEventMultiInsertParams(
              events: event.events, newSessionId: sessionForEdit.sessionId));
      yield eventsOrFailure.fold(
          errorStateResponse, ((results) => NewEventsCreatedState()));

      // Delete an Event
    } else if (event is DeleteEventFromSessionEvent) {
      yield SessionEditorCrudInProgressState();
      final deleteOrFailure = await deleteEventByIdUC(
          SkillEventGetOrDeleteParams(eventId: event.eventId));
      yield deleteOrFailure.fold(
          errorStateResponse, (reply) => EventDeletedFromSessionState());
    }
  }
}
