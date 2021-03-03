import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/tickTock.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

part 'liveSessionScreen_event.dart';
part 'liveSessionScreen_state.dart';

class LiveSessionScreenBloc
    extends Bloc<LiveSessionScreenEvent, LiveSessionScreenState> {
  final SaveLiveSessionWithActivities saveLiveSessionWithActivitiesUC;

  LiveSessionScreenBloc({@required this.saveLiveSessionWithActivitiesUC})
      : super(LiveSessionScreenInitial());

  Skill selectedSkill;
  List<Activity> activities = [];
  DateTime date = TickTock.today();
  TimeOfDay startTime = TimeOfDay.now();
  int sessionDuration = 0;

  @override
  Stream<LiveSessionScreenState> mapEventToState(
    LiveSessionScreenEvent event,
  ) async* {
    if (event is LiveSessionSkillSelectedEvent) {
      selectedSkill = event.skill;
      yield LiveSessionReadyState();
    }

    // activity finished
    else if (event is LiveSessionActivityFinishedEvent) {
      Activity activity = Activity(
          skillId: selectedSkill.skillId,
          sessionId: 0,
          date: date,
          duration: event.elapsedTime,
          isComplete: true,
          skillString: selectedSkill.name,
          notes: event.notes,
          skill: selectedSkill);

      activities.add(activity);
      sessionDuration += event.elapsedTime;
      yield LiveSessionSelectOrFinishState();
    }

    // activity cancelled
    else if (event is LiveSessionActivityCancelledEvent) {
      selectedSkill = null;
      yield LiveSessionSelectOrFinishState();
    }

    // session finished
    else if (event is LiveSessionFinishedEvent) {
      yield LiveSessionProcessingState();
      Session session = Session(
          date: date,
          duration: sessionDuration,
          isComplete: true,
          isScheduled: true,
          startTime: startTime,
          timeRemaining: 0);
      final sessionIdOrFailure = await saveLiveSessionWithActivitiesUC(
          LiveSessionParams(session: session, activities: activities));
      yield sessionIdOrFailure.fold(
          (failure) => LiveSessionScreenErrorState(CACHE_FAILURE_MESSAGE),
          (id) => LiveSessionFinishedState());
    }
  }
}
