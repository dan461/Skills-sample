import 'package:equatable/equatable.dart';
import 'package:skills/features/skills/presentation/bloc/newSkillScreen/new_skill_bloc.dart';

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

class NewSkillUpdatedState extends NewSkillState {
  final int updates;

  NewSkillUpdatedState(this.updates);

  @override
  List<Object> get props => [updates];
}

class NewSkillErrorState extends NewSkillState {
  final String message;

  NewSkillErrorState(this.message);
  @override
  List<Object> get props => [message];
}
