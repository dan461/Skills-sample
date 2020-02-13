import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';

abstract class SkillEditorEvent extends Equatable {
  const SkillEditorEvent();
}

class EditSkillEvent extends SkillEditorEvent {
  final Skill skill;

  EditSkillEvent(this.skill);
  @override
  List<Object> get props => [skill];
}

class CreateSkillEvent extends SkillEditorEvent {
  @override
  List<Object> get props => [];
}

class GetSkillByIdEvent extends SkillEditorEvent {
  final int id;

  GetSkillByIdEvent({@required this.id});

  @override
  List<Object> get props => [id];
}

// class InsertNewSkillEvent extends SkillEditorEvent {
//   final Skill newSkill;

//   InsertNewSkillEvent(this.newSkill);

//   @override
//   List<Object> get props => [newSkill];
// }

class DeleteSkillWithIdEvent extends SkillEditorEvent {
  final int skillId;

  DeleteSkillWithIdEvent({@required this.skillId});

  @override
  List<Object> get props => [skillId];
}

class UpdateSkillEvent extends SkillEditorEvent {
  final Skill skill;

  UpdateSkillEvent({@required this.skill});

  @override
  List<Object> get props => [skill];
}
