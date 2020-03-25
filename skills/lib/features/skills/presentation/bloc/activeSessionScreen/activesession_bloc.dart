import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/usecases/activityUseCases.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/bloc/session_bloc.dart';

part 'activesession_event.dart';
part 'activesession_state.dart';

class ActiveSessionBloc extends SessionBloc {
  final CompleteActivityUC completeActivityUC;
  final GetActivitiesWithSkillsForSession getActivitiesWithSkillsForSessionUC;
  final UpdateSessionWithId updateSessionWithId;

  Session session;

  Activity selectedActivity;
  int updatedSessionDuration;

  ActiveSessionBloc(
      {@required this.completeActivityUC,
      @required this.getActivitiesWithSkillsForSessionUC,
      @required this.updateSessionWithId});

  @override
  ActiveSessionState get initialState => ActiveSessionInitial();

  @override
  Stream<ActiveSessionState> mapEventToState(
    SessionEvent event,
  ) async* {
    if (event is ActiveSessionLoadInfoEvent) {
      activitiesForSession = event.activities;
      session = event.session;
      yield ActiveSessionInfoLoadedState(
          duration: session.duration, activities: activitiesForSession);
    }

    // Activity selected
    else if (event is ActivitySelectedForTimerEvent) {
      selectedActivity = event.selectedActivity;
      yield ActivityReadyState(activity: event.selectedActivity);
    }

    // Timer stopped
    else if (event is ActivityTimerStoppedEvent) {
      yield ActiveSessionInfoLoadedState(
          duration: session.duration, activities: activitiesForSession);
    }

    // Activity finished
    else if (event is CurrentActivityFinishedEvent) {
      yield ActiveSessionProcessingState();

      final updateOrFailure = await completeActivityUC(ActivityCompleteParams(
          event.activity.eventId,
          event.activity.date,
          event.elapsedTime,
          event.activity.skillId));
      yield updateOrFailure.fold(
          (failure) => ActiveSessionErrorState(CACHE_FAILURE_MESSAGE),
          (update) => CurrentActivityFinishedState());
      // yield CurrentActivityFinishedState();
    }

    // Refresh activities
    else if (event is ActiveSessionRefreshActivitiesEvent) {
      yield ActiveSessionProcessingState();

      final refreshOrFailure = await getActivitiesWithSkillsForSessionUC(
          SessionByIdParams(sessionId: session.sessionId));
      yield refreshOrFailure
          .fold((failure) => ActiveSessionErrorState(CACHE_FAILURE_MESSAGE),
              (activities) {
        activitiesForSession = activities;
        return ActiveSessionActivitiesRefreshedState(
            duration: session.duration, activities: activities);
      });
    }

    // Complete Session
    else if (event is CompleteActiveSessionEvent) {
      yield ActiveSessionProcessingState();
      int time = updatedSessionDuration != null
          ? updatedSessionDuration
          : session.duration;
      Map<String, dynamic> changeMap = {'isComplete': true, 'duration': time};
      final updateOrFailure = await updateSessionWithId(SessionUpdateParams(
          sessionId: session.sessionId, changeMap: changeMap));
      yield updateOrFailure.fold(
          (failure) => ActiveSessionErrorState(CACHE_FAILURE_MESSAGE),
          (update) => ActiveSessionCompletedState());
    }
  }
}
