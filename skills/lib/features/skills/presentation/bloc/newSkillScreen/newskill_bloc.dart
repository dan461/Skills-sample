import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/usecases/skillUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

part 'newskill_event.dart';
part 'newskill_state.dart';

class NewskillBloc extends Bloc<NewskillEvent, NewSkillState> {
  final InsertNewSkill insertNewSkillUC;

  NewskillBloc({this.insertNewSkillUC}) : super(InitialNewSkillState());

  Skill newSkill;

  @override
  Stream<NewSkillState> mapEventToState(
    NewskillEvent event,
  ) async* {
    if (event is CreateNewSkillEvent) {
      yield CreatingNewSkillState();
      final failureOrNewId = await insertNewSkillUC(
          SkillInsertOrUpdateParams(skill: event.newSkill));
      yield failureOrNewId.fold(
          (failure) => NewSkillErrorState(CACHE_FAILURE_MESSAGE),
          (newSkill) => NewSkillInsertedState());
    }
  }
}
