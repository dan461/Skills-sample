import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';

part 'skilldata_event.dart';
part 'skilldata_state.dart';

class SkillDataBloc extends Bloc<SkillDataEvent, SkillDataState> {

  Skill skill;

  @override
  SkillDataState get initialState => SkillDataInitial();

  @override
  Stream<SkillDataState> mapEventToState(
    SkillDataEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
