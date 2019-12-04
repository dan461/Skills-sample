import 'package:equatable/equatable.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';

abstract class SkillEditorEvent extends Equatable {
  const SkillEditorEvent();
}

class InsertNewSkillEvent extends SkillEditorEvent {
  final Skill newSkill;

  InsertNewSkillEvent(this.newSkill);

  @override
  List<Object> get props => [newSkill];
}

class UpdateSkillEvent extends SkillEditorEvent {
  final Skill skill;

  UpdateSkillEvent(this.skill);

  @override
  List<Object> get props => [skill];
}
