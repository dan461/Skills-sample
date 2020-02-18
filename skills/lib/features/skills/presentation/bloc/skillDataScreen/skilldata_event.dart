part of 'skilldata_bloc.dart';

abstract class SkillDataEvent extends Equatable {
  const SkillDataEvent();
}

class GetEventsForSkillEvent extends SkillDataEvent {
  final int skillId;

  GetEventsForSkillEvent({@required this.skillId});

  @override
  List<Object> get props => null;
}

class UpdateExistingSkillEvent extends SkillDataEvent {
  final Skill skill;

  UpdateExistingSkillEvent({@required this.skill});

  @override
  List<Object> get props => [skill];
}
