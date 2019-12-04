import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/features/skills/domain/usecases/insertNewSkill.dart';
import 'package:skills/features/skills/domain/usecases/updateSkill.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_bloc.dart';
import './bloc.dart';

class SkillEditorBloc extends Bloc<SkillEditorEvent, SkillEditorState> {
  final InsertNewSkill insertNewSkillUC;
  final UpdateSkill updateSkill;

  SkillEditorBloc(
      {@required this.insertNewSkillUC, @required this.updateSkill});

  @override
  SkillEditorState get initialState => InitialSkillEditorState();

  @override
  Stream<SkillEditorState> mapEventToState(
    SkillEditorEvent event,
  ) async* {
    if (event is InsertNewSkillEvent) {
      yield NewSkillInsertingState();
      final failureOrNewId = await insertNewSkillUC(
          SkillInsertOrUpdateParams(skill: event.newSkill));
      yield failureOrNewId.fold(
          (failure) => SkillEditorErrorState(CACHE_FAILURE_MESSAGE),
          (newId) => NewSkillInsertedState(newId));
    } else if (event is CreateSkillEvent) {
      yield CreatingNewSkillState();
    } else if (event is EditSkillEvent) {
      yield EditingSkillState(event.skill);
    }
  }
}
