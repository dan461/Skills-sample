import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class GoalEditorState extends Equatable {
  const GoalEditorState();
}

class EmptyGoalEditorState extends GoalEditorState {
  @override
  List<Object> get props => [];
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
  final int newGoalId;
  NewGoalInsertedState(this.newGoalId);
  @override
  List<Object> get props => [];
}

class NewGoalErrorState extends GoalEditorState {
  final String message;

  NewGoalErrorState(this.message);
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
