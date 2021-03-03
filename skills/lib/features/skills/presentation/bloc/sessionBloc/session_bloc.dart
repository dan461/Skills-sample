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
  List<Activity> activitiesForSession = [];
  Session session;

  SessionBloc() : super(SessionInitial());

  int get completedActivitiesCount {
    int count = 0;
    for (var activity in activitiesForSession) {
      if (activity.isComplete) count++;
    }
    return count;
  }

  int get availableTime {
    var time = session.duration ?? 0;
    for (var activity in activitiesForSession) {
      time -= activity.duration;
    }
    return time;
  }

  void createActivity(
      int activityDuration, String notes, Skill skill, DateTime date) {
    final newActivity = Activity(
        skillId: skill.skillId,
        sessionId: session.sessionId,
        date: date,
        duration: activityDuration,
        isComplete: false,
        skillString: skill.name,
        notes: notes);
    add(InsertActivityForSessionEvent(newActivity));
  }

  @override
  Stream<SessionState> mapEventToState(SessionEvent event) {
    return null;
  }
}
