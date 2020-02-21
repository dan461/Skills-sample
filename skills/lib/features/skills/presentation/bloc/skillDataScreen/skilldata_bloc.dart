import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/skillUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

part 'skilldata_event.dart';
part 'skilldata_state.dart';

class SkillDataBloc extends Bloc<SkillDataEvent, SkillDataState> {
  final GetCompletedEventsForSkill getCompletedEventsForSkill;
  final UpdateSkill updateSkill;
  final GetSkillById getSkillById;

  Skill skill;
  List<SkillEvent> completedActivities;

  SkillDataBloc(
      {this.getCompletedEventsForSkill, this.updateSkill, this.getSkillById});

  @override
  SkillDataState get initialState => SkillDataInitialState();

  @override
  Stream<SkillDataState> mapEventToState(
    SkillDataEvent event,
  ) async* {
    if (event is GetEventsForSkillEvent) {
      yield SkillDataCrudProcessingState();
      final eventsOrFail =
          await getCompletedEventsForSkill(GetSkillParams(id: event.skillId));
      yield eventsOrFail
          .fold((failure) => SkillDataErrorState(CACHE_FAILURE_MESSAGE),
              (activities) {
        completedActivities = activities;
        return SkillDataEventsLoadedState();
      });
    }
    // Update Skill
    else if (event is UpdateExistingSkillEvent) {
      yield SkillDataCrudProcessingState();
      final updateOrFail =
          await updateSkill(SkillInsertOrUpdateParams(skill: event.skill));
      yield updateOrFail.fold(
          (failure) => SkillDataErrorState(CACHE_FAILURE_MESSAGE),
          (updateId) => UpdatedExistingSkillState());
    }
    // Refresh skill from cache
    else if (event is RefreshSkillByIdEvent) {
      yield SkillDataCrudProcessingState();
      final skillOrFail = await getSkillById(GetSkillParams(id: event.skillId));
      yield skillOrFail
          .fold((failure) => SkillDataErrorState(CACHE_FAILURE_MESSAGE),
              (freshSkill) {
        skill = freshSkill;
        return SkillRefreshedState();
      });
    }
  }
}
