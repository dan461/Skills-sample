import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/new_session/bloc.dart';
import './bloc.dart';

class SessionEditorBloc extends Bloc<SessionEditorEvent, SessionEditorState> {
  final UpdateSessionWithId updateSessionWithId;
  final DeleteSessionWithId deleteSessionWithId;
  final InsertEventsForSessionUC insertEventsForSession;

  SessionEditorBloc(
      {this.updateSessionWithId,
      this.deleteSessionWithId,
      this.insertEventsForSession});

  TimeOfDay selectedStartTime;
  TimeOfDay selectedFinishTime;
  DateTime sessionDate;

  Session sessionForEdit;
  Skill selectedSkill;
  Goal currentGoal;
  var pendingEvents = <SkillEvent>[];

  int eventDuration;
  Map<String, dynamic> changeMap = {};

  int get sessionDuration {
    int minutes;
    if (selectedStartTime == null || selectedFinishTime == null)
      minutes = 0;
    else {
      int hours = selectedFinishTime.hour - selectedStartTime.hour;
      minutes =
          selectedFinishTime.minute - selectedStartTime.minute + hours * 60;
    }
    return minutes;
  }

  void createEvent(DateTime date) {
    final newEvent = SkillEvent(
        skillId: selectedSkill.skillId,
        sessionId: 0,
        date: date,
        duration: eventDuration,
        isComplete: false,
        skillString: selectedSkill.name);

    pendingEvents.add(newEvent);

    if (sessionForEdit == null) {
      Map<String, dynamic> map = {
        'event': newEvent,
        'skill': selectedSkill,
        'goal': currentGoal
      };
      // pendingEventMapsForListView.add(map);
    }
  }

  @override
  SessionEditorState get initialState => InitialSessionEditorState();

  @override
  Stream<SessionEditorState> mapEventToState(
    SessionEditorEvent event,
  ) async* {
    if (event is UpdateSessionEvent) {
      yield SessionEditorCrudInProgressState();

      final updateOrFailure = await updateSessionWithId(SessionUpdateParams(
          sessionId: sessionForEdit.sessionId, changeMap: changeMap));

     yield updateOrFailure.fold(
          (failure) => SessionEditorErrorState(CACHE_FAILURE_MESSAGE),
          (result) => SessionUpdatedState());
    }
  }
}
