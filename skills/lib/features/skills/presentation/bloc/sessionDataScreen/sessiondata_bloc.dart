import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/activityUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/sessionBloc/session_bloc.dart';

part 'sessiondata_event.dart';
part 'sessiondata_state.dart';

class SessiondataBloc extends SessionBloc {
  final UpdateAndRefreshSessionWithId updateAndRefreshSessionWithId;
  final DeleteSessionWithId deleteSessionWithId;
  final GetSessionAndActivities getSessionAndActivities;
  final GetActivitiesWithSkillsForSession getActivitiesWithSkillsForSession;
  final InsertActivityForSessionUC insertActivitiesForSession;
  
  final DeleteActivityByIdUC deleteActivityByIdUC;

  SessiondataBloc(
      {this.updateAndRefreshSessionWithId,
      this.deleteSessionWithId,
      this.getSessionAndActivities,
      this.getActivitiesWithSkillsForSession,
      this.insertActivitiesForSession,
      
      this.deleteActivityByIdUC});

  @override
  SessiondataState get initialState => SessiondataInitial();

  Session session;
  DateTime sessionDate;
  TimeOfDay selectedStartTime;

  // List<Map> activityMapsForListView = [];
  List<Activity> activitiesForSession = [];

  bool get canBeginSession {
    return completedActivitiesCount < activitiesForSession.length;
  }

  @override
  Stream<SessionState> mapEventToState(
    SessionEvent event,
  ) async* {
    // Get Session or refresh after returning from ActiveSessionScreen
    if (event is GetSessionAndActivitiesEvent) {
      yield SessionDataCrudInProgressState();
      final sessionOrFailure = await getSessionAndActivities(
          SessionByIdParams(sessionId: event.sessionId));
      yield sessionOrFailure.fold(
          (failure) => SessionDataErrorState(CACHE_FAILURE_MESSAGE), (ses) {
        session = ses;
        sessionDate ??= session.date;
        selectedStartTime ??= session.startTime;
        activitiesForSession = session.activities;
        session.openTime = availableTime;
        return SessionDataInfoLoadedState();
      });
    }

    // Refresh Activities for list
    else if (event is GetActivitiesForSessionEvent) {
      yield SessionDataCrudInProgressState();

      final activitiesOrFailure = await getActivitiesWithSkillsForSession(
          SessionByIdParams(sessionId: session.sessionId));
      yield activitiesOrFailure
          .fold((failure) => SessionDataErrorState(CACHE_FAILURE_MESSAGE),
              (activities) {
        activitiesForSession = activities;
        session.openTime = availableTime;
        return SessionDataActivitesLoadedState();
      });
    }

    // Insert an Activity
    else if (event is InsertActivityForSessionEvent) {
      yield SessionDataCrudInProgressState();
      final activitiesOrFailure = await insertActivitiesForSession(
          ActivityMultiInsertParams(
              activities: [event.activity], newSessionId: session.sessionId));

      yield activitiesOrFailure.fold(
          (failure) => SessionDataErrorState(CACHE_FAILURE_MESSAGE), (results) {
        add(GetActivitiesForSessionEvent(session));
        return NewActivityCreatedState();
      });
    }

    // Remove an Activity
    else if (event is RemoveActivityFromSessionEvent) {
      yield SessionDataCrudInProgressState();
      final removedOrFailure = await deleteActivityByIdUC(
          ActivityGetOrDeleteParams(activityId: event.eventId));
      yield removedOrFailure.fold(
          (failure) => SessionDataErrorState(CACHE_FAILURE_MESSAGE), (id) {
        add(GetActivitiesForSessionEvent(session));
        return ActivityRemovedFromSessionState();
      });
    }

    // Start Editing
    else if (event is BeginSessionEditingEvent) {
      yield SessionEditingState();
    }
    // cancel editing or cancel adding an activity
    else if (event is CancelSessionEditingEvent ||
        event is CancelSkillForSessionEvent) {
      yield SessionViewingState();
    }
    // Skill selected for the Session
    else if (event is SkillSelectedForSessionEvent) {
      yield SkillSelectedForSessionState(event.skill);
    }

    // Update Session and refresh after editing
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
        session.openTime = availableTime;
        selectedStartTime = refreshedSession.startTime;

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
          (response) => SessionWasDeletedState());
    }
  }
}
