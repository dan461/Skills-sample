import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';

abstract class NewgoalState extends Equatable {
  const NewgoalState();
}

class InitialNewgoalState extends NewgoalState {
  @override
  List<Object> get props => [];
}

class NewGoalInsertingState extends NewgoalState {
  @override
  List<Object> get props => [];
}

class NewGoalInsertedState extends NewgoalState {
  final Goal newGoal;
  NewGoalInsertedState(this.newGoal);
  @override
  List<Object> get props => [newGoal];
}

class NewGoalErrorState extends NewgoalState {
  final String message;

  NewGoalErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class AddingGoalToSkillState extends NewgoalState {
  @override
  List<Object> get props => [];
}

class GoalAddedToSkillState extends NewgoalState {
  final int newId;
  final String goalText;
  GoalAddedToSkillState({@required this.newId, @required this.goalText});

  @override
  List<Object> get props => [];
}
