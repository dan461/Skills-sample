import 'package:equatable/equatable.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';

abstract class NewSkillEvent extends Equatable {
  const NewSkillEvent();
}

class InsertNewSkillEvent extends NewSkillEvent {
  final Skill newSkill;

  InsertNewSkillEvent(this.newSkill);

  @override
  List<Object> get props => [newSkill];
}

class GetNewSkillByIdEvent extends NewSkillEvent {
  final int id;

  GetNewSkillByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateNewSkillEvent extends NewSkillEvent {
  final int skillId;
  final Map changeMap;

  UpdateNewSkillEvent({this.skillId, this.changeMap});

  @override
  List<Object> get props => [skillId, changeMap];
}
