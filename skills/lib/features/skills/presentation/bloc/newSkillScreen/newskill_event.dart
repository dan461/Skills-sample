part of 'newskill_bloc.dart';

abstract class NewskillEvent extends Equatable {
  const NewskillEvent();
}

class CreateNewSkillEvent extends NewskillEvent {
  final Skill newSkill;

  CreateNewSkillEvent(this.newSkill);
  @override
  List<Object> get props => [newSkill];
}

// class InsertNewSkillEvent extends NewskillEvent {
//   final Skill newSkill;

//   InsertNewSkillEvent(this.newSkill);

//   @override
//   List<Object> get props => [newSkill];
// }
