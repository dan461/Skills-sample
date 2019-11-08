import 'package:equatable/equatable.dart';

abstract class NewSkillState extends Equatable {
  const NewSkillState();
}

class EmptyNewSkillState extends NewSkillState {
  @override
  List<Object> get props => [];
}

class NewSkillInsertingState extends NewSkillState {
  @override
  List<Object> get props => [];
}

class NewSkillInsertedState extends NewSkillState {
  final int newSkillId;
  NewSkillInsertedState(this.newSkillId);
  @override
  List<Object> get props => [newSkillId];
}

class NewSkillErrorState extends NewSkillState {
  final String message;

  NewSkillErrorState(this.message);
  @override
  List<Object> get props => [message];
}

