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

  @override
  ActiveSessionState get initialState => ActiveSessionInitial();

  // int get completedActivitiesCount {
  //   int count = 0;
  //   for (var map in activityMapsForListView) {
  //     Activity event = map['activity'];
  //     if (event.isComplete) count++;
  //   }
  //   return count;
  // }

  // int get availableTime {
  //   var time = session.duration ?? 0;
  //   for (var map in activityMapsForListView) {
  //     var event = map['activity'];
  //     time -= event.duration;
  //   }
  //   return time;
  // }

  // void createActivity(int activityDuration, Skill skill) {
  //   final newActivity = Activity(
  //       skillId: skill.skillId,
  //       sessionId: session.sessionId,
  //       date: session.date,
  //       duration: activityDuration,
  //       isComplete: false,
  //       skillString: skill.name);
  //   add(InsertActivityForSessionEvent(newActivity));
  // }

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
  }
}
