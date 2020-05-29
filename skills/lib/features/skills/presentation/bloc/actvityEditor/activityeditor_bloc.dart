import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';

part 'activityeditor_event.dart';
part 'activityeditor_state.dart';

class ActivityEditorBloc
    extends Bloc<ActivityeditorEvent, ActivityEditorState> {
  Activity activity;

  @override
  ActivityEditorState get initialState => ActivityEditorInitial();

  Skill selectedSkill;
  int selectedDuration;
  String selectedNotes;

 

  bool get hasValidChanges {
    selectedSkill ??= activity.skill;
    selectedDuration ??= activity.duration;
    selectedNotes ??= activity.notes;

    if (selectedDuration != activity.duration ||
        selectedNotes != activity.notes || selectedSkill != activity.skill)
      return selectedDuration >= 5;
    else
      return false;
  }

  @override
  Stream<ActivityEditorState> mapEventToState(
    ActivityeditorEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
