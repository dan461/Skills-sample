part of 'newskill_bloc.dart';

abstract class NewSkillState extends Equatable {
  const NewSkillState();
}

class InitialNewSkillState extends NewSkillState {
  @override
  List<Object> get props => [];
}

class CreatingNewSkillState extends NewSkillState {
  @override
  List<Object> get props => [];
}

class NewSkillInsertedState extends NewSkillState {
  @override
  List<Object> get props => [];
}

class NewSkillErrorState extends NewSkillState {
  final String message;

  NewSkillErrorState(this.message);
  @override
  List<Object> get props => [message];
}
