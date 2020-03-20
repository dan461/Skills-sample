import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/bloc/bloc/session_bloc.dart';

part 'activesession_event.dart';
part 'activesession_state.dart';

class ActiveSessionBloc extends SessionBloc {
  Session session;
  
  Activity selectedActivity;

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
      yield CurrentActivityFinishedState();
    }
  }
}
