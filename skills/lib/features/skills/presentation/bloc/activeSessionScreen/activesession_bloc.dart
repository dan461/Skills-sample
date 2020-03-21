import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/usecases/activityUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/bloc/session_bloc.dart';

part 'activesession_event.dart';
part 'activesession_state.dart';

class ActiveSessionBloc extends SessionBloc {
  final CompleteActivityUC completeActivityUC;
  final GetActivitiesWithSkillsForSession getActivitiesWithSkillsForSessionUC;

  Session session;

  Activity selectedActivity;

  ActiveSessionBloc(
      {@required this.completeActivityUC,
      @required this.getActivitiesWithSkillsForSessionUC});

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
      yield ActivityTimerStoppedState();
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
  }
}
