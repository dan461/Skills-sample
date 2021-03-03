import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/usecases/activityUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

part 'activityeditor_event.dart';
part 'activityeditor_state.dart';

class ActivityEditorBloc
    extends Bloc<ActivityeditorEvent, ActivityEditorState> {
  Activity activity;
  final UpdateActivityUC updateActivityUC;

  ActivityEditorBloc({this.updateActivityUC}) : super(ActivityEditorInitial());

  Skill selectedSkill;
  int selectedDuration;
  String selectedNotes;

  bool get hasValidChanges {
    selectedSkill ??= activity.skill;
    selectedDuration ??= activity.duration;
    selectedNotes ??= activity.notes;

    if (selectedDuration != activity.duration ||
        selectedNotes != activity.notes ||
        selectedSkill != activity.skill)
      return selectedDuration >= 5;
    else
      return false;
  }

  @override
  Stream<ActivityEditorState> mapEventToState(
    ActivityeditorEvent event,
  ) async* {
    if (event is ActivityEditorSaveEvent) {
      yield ActivityEditorCrudInProgressState();
      final updateOrFailure = await updateActivityUC(ActivityUpdateParams(
          changeMap: getChangeMap(), activityId: activity.eventId));
      yield updateOrFailure.fold(
          (failure) => ActivityEditorErrorState(CACHE_FAILURE_MESSAGE),
          (update) => ActivityEditorUpdateCompleteState());
    }
  }

  Map<String, dynamic> getChangeMap() {
    Map<String, dynamic> map = {};

    if (selectedDuration != activity.duration) {
      map['duration'] = selectedDuration;
    }

    if (selectedSkill != activity.skill) {
      map['skillId'] = selectedSkill.skillId;
    }

    if (selectedNotes != activity.notes) {
      map['notes'] = selectedNotes;
    }

    return map;
  }
}
