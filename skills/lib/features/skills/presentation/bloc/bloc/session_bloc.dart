import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/bloc/sessionDataScreen/sessiondata_bloc.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  List<Map> activityMapsForListView = [];
  Session session;

  int get completedActivitiesCount {
    int count = 0;
    for (var map in activityMapsForListView) {
      Activity activity = map['activity'];
      if (activity.isComplete) count++;
    }
    return count;
  }

  int get availableTime {
    var time = session.duration ?? 0;
    for (var map in activityMapsForListView) {
      var activity = map['activity'];
      time -= activity.duration;
    }
    return time;
  }

  void createActivity(int activityDuration, Skill skill, DateTime date) {
    final newActivity = Activity(
        skillId: skill.skillId,
        sessionId: session.sessionId,
        date: date,
        duration: activityDuration,
        isComplete: false,
        skillString: skill.name);
    add(InsertActivityForSessionEvent(newActivity));
  }

  @override
  SessionState get initialState => null;

  @override
  Stream<SessionState> mapEventToState(SessionEvent event) {
    return null;
  }
}
