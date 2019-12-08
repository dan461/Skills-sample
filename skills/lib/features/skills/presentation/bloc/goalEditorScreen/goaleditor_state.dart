import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';

abstract class GoalEditorState extends Equatable {
  const GoalEditorState();
}

class EmptyGoalEditorState extends GoalEditorState {
  @override
  List<Object> get props => [];
}

class GoalEditorCreatingState extends GoalEditorState {
  @override
  List<Object> get props => [];
}

class GoalEditorEditingState extends GoalEditorState {
  final Goal goal;

  GoalEditorEditingState({@required this.goal});
  @override
  List<Object> get props => [goal];
}

class GoalCrudInProgressState extends GoalEditorState {
  @override
  List<Object> get props => [];
}

class NewGoalInsertingState extends GoalEditorState {
  @override
  List<Object> get props => [];
}

class NewGoalInsertedState extends GoalEditorState {
  final Goal newGoal;
  NewGoalInsertedState(this.newGoal);
  @override
  List<Object> get props => [newGoal];
}

class GoalEditorErrorState extends GoalEditorState {
  final String message;

  GoalEditorErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class GoalUpdatingState extends GoalEditorState {
  @override
  List<Object> get props => [];
}

class GoalUpdatedState extends GoalEditorState {
  final int updates;
  GoalUpdatedState(this.updates);
  @override
  List<Object> get props => [];
}

class GoalDeletedState extends GoalEditorState {
  final int result;
  GoalDeletedState(this.result);
  @override
  List<Object> get props => [result];
}

class AddingGoalToSkillState extends GoalEditorState {
  @override
  List<Object> get props => [];
}

class GoalAddedToSkillState extends GoalEditorState {
  final int newId;
  final String goalText;
  GoalAddedToSkillState({@required this.newId, @required this.goalText});

  @override
  List<Object> get props => [];
}

// inserting, updating, adding to skill, finished
