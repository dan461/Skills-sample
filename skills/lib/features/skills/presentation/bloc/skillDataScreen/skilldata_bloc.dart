import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

part 'skilldata_event.dart';
part 'skilldata_state.dart';

class SkillDataBloc extends Bloc<SkillDataEvent, SkillDataState> {
  final GetCompletedEventsForSkill getCompletedEventsForSkill;
  Skill skill;
  List<SkillEvent> completedActivities;

  SkillDataBloc({this.getCompletedEventsForSkill});

  @override
  SkillDataState get initialState => SkillDataInitialState();

  @override
  Stream<SkillDataState> mapEventToState(
    SkillDataEvent event,
  ) async* {
    if (event is GetEventsForSkillEvent) {
      yield SkillDataGettingEventsState();
      final eventsOrFail =
          await getCompletedEventsForSkill(GetSkillParams(id: event.skillId));
      yield eventsOrFail
          .fold((failure) => SkillDataErrorState(CACHE_FAILURE_MESSAGE),
              (activities) {
        completedActivities = activities;
        return SkillDataEventsLoadedState();
      });
    }

    else if (event is UpdateExistingSkillEvent){
      
    }
  }
}
