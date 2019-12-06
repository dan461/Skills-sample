import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';

abstract class GoalEditorEvent extends Equatable {
  const GoalEditorEvent();
}

class InsertNewGoalEvent extends GoalEditorEvent {
  final Goal newGoal;

  InsertNewGoalEvent(this.newGoal);

  @override
  List<Object> get props => [newGoal];
}

class UpdateGoalEvent extends GoalEditorEvent {
  final Goal newGoal;

  UpdateGoalEvent(this.newGoal);

  @override
  List<Object> get props => [newGoal];
}

class AddGoalToSkillEvent extends GoalEditorEvent {
  final int goalId;
  final int skillId;
  final String goalText;

  AddGoalToSkillEvent({@required this.goalText, @required this.goalId, @required this.skillId});

  @override
  List<Object> get props => [goalId, skillId];
}


