import 'package:equatable/equatable.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';

abstract class SkillsState extends Equatable {
  const SkillsState();
}

class InitialSkillsState extends SkillsState {
  @override
  List<Object> get props => [];
}

class AllSkillsLoading extends SkillsState {
  @override
  List<Object> get props => [];
  
}

class AllSkillsLoaded extends SkillsState {
  final List<Skill> skills;

  AllSkillsLoaded(this.skills);
  @override
  List<Object> get props => [skills];
  
}

class AllSkillsError extends SkillsState {
  final String message;

  AllSkillsError(this.message);

  @override
  List<Object> get props => [message];
  
}
