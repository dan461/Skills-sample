import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

part 'sessiondata_event.dart';
part 'sessiondata_state.dart';

class SessiondataBloc extends Bloc<SessiondataEvent, SessiondataState> {
  final UpdateAndRefreshSessionWithId updateAndRefreshSessionWithId;
  final DeleteSessionWithId deleteSessionWithId;
  final GetEventMapsForSession getEventMapsForSession;
  final InsertEventsForSessionUC insertEventsForSession;
  final CompleteSessionAndEvents completeSessionAndEvents;
  final DeleteEventByIdUC deleteEventByIdUC;

  SessiondataBloc(
      {this.updateAndRefreshSessionWithId,
      this.deleteSessionWithId,
      this.getEventMapsForSession,
      this.insertEventsForSession,
      this.completeSessionAndEvents,
      this.deleteEventByIdUC});

  @override
  SessiondataState get initialState => SessiondataInitial();

  Session session;
  DateTime sessionDate;
  TimeOfDay selectedStartTime;

  List<Map> activityMapsForListView = [];

  int get completedActivitiesCount {
    int count = 0;
    for (var map in activityMapsForListView) {
      SkillEvent event = map['event'];
      if (event.isComplete) count++;
    }
    return count;
  }

  int get availableTime {
    var time = session.duration ?? 0;
    for (var map in activityMapsForListView) {
      var event = map['event'];
      time -= event.duration;
    }
    return time;
  }

  bool isEditing = false;

  @override
  Stream<SessiondataState> mapEventToState(
    SessiondataEvent event,
  ) async* {
    // Get or refresh Activities for list
    if (event is GetActivitiesForSessionEvent) {
      session ??= event.session;
      sessionDate ??= session.date;
      selectedStartTime ??= session.startTime;
      yield SessionDataCrudInProgressState();

      final eventMapsOrFailure = await getEventMapsForSession(
          SessionByIdParams(sessionId: session.sessionId));
      yield eventMapsOrFailure.fold(
          (failure) => SessionDataErrorState(CACHE_FAILURE_MESSAGE), (maps) {
        activityMapsForListView = maps;
        session.openTime = availableTime;
        return SessionDataEventsLoadedState();
      });
    }

    // Insert an Activity
    else if (event is InsertActivityForSessionEvent) {
      yield SessionDataCrudInProgressState();
      final eventsOrFailure = await insertEventsForSession(
          SkillEventMultiInsertParams(
              events: [event.activity], newSessionId: session.sessionId));

      yield eventsOrFailure.fold(
          (failure) => SessionDataErrorState(CACHE_FAILURE_MESSAGE),
          (results) => NewActivityCreatedState());
    }

    // Remove an Activity
    else if (event is RemoveActivityFromSessionEvent) {
      yield SessionDataCrudInProgressState();
      final removedOrFailure = await deleteEventByIdUC(
          SkillEventGetOrDeleteParams(eventId: event.eventId));
      yield removedOrFailure.fold(
          (failure) => SessionDataErrorState(CACHE_FAILURE_MESSAGE),
          (id) => ActivityRemovedFromSessionState());
    }

    // Complete Session
    else if (event is CompleteSessionEvent) {
      yield SessionDataCrudInProgressState();
      final completedOrFailure = await completeSessionAndEvents(
          SessionCompleteParams(session.sessionId, session.date));
      yield completedOrFailure.fold(
          (failure) => SessionDataErrorState(CACHE_FAILURE_MESSAGE),
          (response) => SessionCompletedState());
    }

    // Update Session
    else if (event is UpdateSessionEvent) {
      yield SessionDataCrudInProgressState();
      final updateOrFailure = await updateAndRefreshSessionWithId(
          SessionUpdateParams(
              sessionId: session.sessionId, changeMap: event.changeMap));
      yield updateOrFailure
          .fold((failure) => SessionDataErrorState(CACHE_FAILURE_MESSAGE),
              (refreshedSession) {
        session = refreshedSession;
        sessionDate = refreshedSession.date;
        selectedStartTime = refreshedSession.startTime;
        isEditing = false;
        return SessionUpdatedAndRefreshedState(session);
      });
    }

    // Delete Session
    else if (event is DeleteSessionWithIdEvent) {
      yield SessionDataCrudInProgressState();
      final deleteOrFailure = await deleteSessionWithId(
          SessionDeleteParams(sessionId: session.sessionId));
      yield deleteOrFailure.fold(
          (failure) => SessionDataErrorState(CACHE_FAILURE_MESSAGE),
          (response) => SessionDeletedState());
    }
  }
}
