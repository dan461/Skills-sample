import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:skills/features/skills/domain/usecases/insertNewSkill.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_bloc.dart';
import './bloc.dart';

class NewSkillBloc extends Bloc<NewSkillEvent, NewSkillState> {

final InsertNewSkill insertNewSkillUC;

  NewSkillBloc({@required this.insertNewSkillUC});

  @override
  NewSkillState get initialState => EmptyNewSkillState();

  @override
  Stream<NewSkillState> mapEventToState(
    NewSkillEvent event,
  ) async* {
    if (event is InsertNewSkillEvent){
      yield NewSkillInsertingState();
      final failureOrNewId = await insertNewSkillUC(InsertParams(skill: event.newSkill));
      yield failureOrNewId.fold(
        (failure) => NewSkillErrorState(CACHE_FAILURE_MESSAGE), 
        (newId) => NewSkillInsertedState(newId));
    }
  }
}
