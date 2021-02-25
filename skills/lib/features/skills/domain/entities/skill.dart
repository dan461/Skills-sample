import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:skills/core/tickTock.dart';

import 'goal.dart';

class Skill extends Equatable {
  final int skillId;
  final String name;
  final String type;
  final String source;
  final String instrument;
  final DateTime startDate;
  final int totalTime;
  final DateTime lastPracDate;
  final int currentGoalId;
  final int priority;
  final double proficiency;
  Goal goal;

  Skill(
      {this.skillId,
      @required this.name,
      @required this.type,
      this.source,
      this.instrument,
      @required this.startDate,
      this.totalTime,
      this.lastPracDate,
      this.currentGoalId,
      this.priority,
      this.proficiency,
      this.goal})
      : super();

  int get elapsedDays {
    int days = -1;
    if (lastPracDate.millisecondsSinceEpoch != 0) {
      days = (TickTock.today().millisecondsSinceEpoch -
              lastPracDate.millisecondsSinceEpoch) ~/
          86400000;
    }
    return days;
  }

  @override
  List<Object> get props => [
        skillId,
        name,
        type,
        source,
        instrument,
        startDate,
        totalTime,
        lastPracDate,
        currentGoalId,
        priority,
        proficiency,
        goal
      ];
}
