import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/bloc/bloc/session_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/sessionDataScreen/sessiondata_bloc.dart';
import 'package:skills/features/skills/presentation/pages/activeSessionScreen.dart';

part 'activesession_event.dart';
part 'activesession_state.dart';

class ActiveSessionBloc extends SessionBloc {
  Session session;
  List<Map> activityMapsForListView = [];
  Map<String, dynamic> selectedMap;

  @override
  ActiveSessionState get initialState => ActiveSessionInitial();

  @override
  Stream<ActiveSessionState> mapEventToState(
    SessionEvent event,
  ) async* {
    if (event is ActiveSessionLoadInfoEvent) {
      activityMapsForListView = event.activityMaps;
      session = event.session;
      yield ActiveSessionInfoLoadedState(
          duration: session.duration, activityMaps: activityMapsForListView);
    }

    // Activity selected
    else if (event is ActivitySelectedForTimerEvent) {
      selectedMap = event.selectedMap;
      yield ActivityReadyState(activity: event.selectedMap['activity']);
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
