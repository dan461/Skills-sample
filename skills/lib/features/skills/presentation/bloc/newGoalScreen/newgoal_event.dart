import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';

abstract class NewgoalEvent extends Equatable {
  const NewgoalEvent();
}

class CreateNewGoalEvent extends NewgoalEvent {
  @override
  List<Object> get props => [];
}

class InsertNewGoalEvent extends NewgoalEvent {
  final Goal newGoal;

  InsertNewGoalEvent(this.newGoal);

  @override
  List<Object> get props => [newGoal];
}

class AddGoalToSkillEvent extends NewgoalEvent {
  final int goalId;
  final int skillId;
  final String goalText;

  AddGoalToSkillEvent(
      {@required this.goalText, @required this.goalId, @required this.skillId});

  @override
  List<Object> get props => [goalId, skillId];
}
