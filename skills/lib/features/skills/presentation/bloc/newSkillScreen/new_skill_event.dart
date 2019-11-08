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
