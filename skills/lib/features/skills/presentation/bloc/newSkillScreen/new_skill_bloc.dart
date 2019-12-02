import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/usecases/getSkillById.dart';
import 'package:skills/features/skills/domain/usecases/insertNewSkill.dart';
import 'package:skills/features/skills/domain/usecases/updateSkill.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_bloc.dart';
import './bloc.dart';

class NewSkillBloc extends Bloc<NewSkillEvent, NewSkillState> {
  final InsertNewSkill insertNewSkillUC;
  final UpdateSkill updateSkill;

  NewSkillBloc({@required this.insertNewSkillUC, @required this.updateSkill});

  @override
  NewSkillState get initialState => EmptyNewSkillState();

  @override
  Stream<NewSkillState> mapEventToState(
    NewSkillEvent event,
  ) async* {
    
    if (event is InsertNewSkillEvent) {
      yield NewSkillInsertingState();
      final failureOrNewId =
          await insertNewSkillUC(InsertParams(skill: event.newSkill));
      yield failureOrNewId.fold(
          (failure) => NewSkillErrorState(CACHE_FAILURE_MESSAGE),
          (newId) => NewSkillInsertedState(newId));
    } else if (event is UpdateNewSkillEvent) {
      
      final failureOrUpdates = await updateSkill(SkillUpdateParams(
          skillId: event.skillId, changeMap: event.changeMap));
      yield failureOrUpdates.fold(
          (failure) => NewSkillErrorState(CACHE_FAILURE_MESSAGE),
          (updates) => NewSkillUpdatedState(updates));
    }
  }
}
