import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/usecases/skillUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import './bloc.dart';

class SkillEditorBloc extends Bloc<SkillEditorEvent, SkillEditorState> {
  
  final UpdateSkill updateSkill;
  final GetSkillById getSkillById;
  final DeleteSkillWithId deleteSkillWithId;

  Skill skill;

  SkillEditorBloc(
      {
      @required this.updateSkill,
      @required this.getSkillById,
      @required this.deleteSkillWithId});

  @override
  SkillEditorState get initialState => InitialSkillEditorState();

  @override
  Stream<SkillEditorState> mapEventToState(
    SkillEditorEvent event,
  ) async* {
    if (event is EditSkillEvent) {
      skill = event.skill;
      yield EditingSkillState(event.skill);
    } 
    
    else if (event is GetSkillByIdEvent) {
      yield SkillEditorCrudInProgressState();
      final failureOrSkill = await getSkillById(GetSkillParams(id: event.id));
      yield failureOrSkill.fold(
          (failure) => SkillEditorErrorState(CACHE_FAILURE_MESSAGE),
          (skill) => SkillRetrievedForEditingState(skill));
    } 
    
    else if (event is UpdateSkillEvent) {
      yield UpdatingSkillState();
      final failureOrUpdates =
          await updateSkill(SkillInsertOrUpdateParams(skill: event.skill));
      yield failureOrUpdates.fold(
          (failure) => SkillEditorErrorState(CACHE_FAILURE_MESSAGE),
          (updates) => UpdatedSkillState());
    } 
    
    else if (event is DeleteSkillWithIdEvent) {
      yield DeletingSkillWithIdState();
      final failureOrResponse =
          await deleteSkillWithId(SkillDeleteParams(skillId: event.skillId));
      yield failureOrResponse.fold(
          (failure) => SkillEditorErrorState(CACHE_FAILURE_MESSAGE),
          (response) => DeletedSkillWithIdState());
    }
  }
}
