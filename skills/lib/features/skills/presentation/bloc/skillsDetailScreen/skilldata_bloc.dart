import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/usecases/activityUseCases.dart';
import 'package:skills/features/skills/domain/usecases/skillUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

part 'skilldata_event.dart';
part 'skilldata_state.dart';

class SkillDataBloc extends Bloc<SkillDataEvent, SkillDataState> {
  final GetCompletedActivitiesForSkill getCompletedEventsForSkill;
  final UpdateSkill updateSkill;
  final GetSkillById getSkillById;
  final GetSkillGoalMapById getSkillGoalMapById;

  Skill skill;
  Goal goal;
  List<Activity> completedActivities;

  SkillDataBloc(
      {this.getCompletedEventsForSkill,
      this.updateSkill,
      this.getSkillById,
      this.getSkillGoalMapById})
      : super(SkillDataInitialState());

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
      final updateOrFail = await updateSkill(SkillUpdateParams(
          skillId: event.skillId, changeMap: event.changeMap));
      yield updateOrFail.fold(
          (failure) => SkillDataErrorState(CACHE_FAILURE_MESSAGE),
          (updateId) => UpdatedExistingSkillState());
    }
    // Refresh skill from cache
    else if (event is RefreshSkillByIdEvent) {
      yield SkillDataCrudProcessingState();
      final skillMapOrFail =
          await getSkillGoalMapById(GetSkillParams(id: event.skillId));
      yield skillMapOrFail.fold(
          (failure) => SkillDataErrorState(CACHE_FAILURE_MESSAGE), (skillMap) {
        skill = skillMap['skill'];
        goal = skillMap['goal'];
        return SkillRefreshedState();
      });
    }
  }
}
