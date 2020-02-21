import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';



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
  // final String goalText;
  final int priority;
  final int proficiency;

  Skill({
    this.skillId,
    @required this.name,
    @required this.type,
    this.source,
    this.instrument,
    @required this.startDate,
    this.totalTime,
    this.lastPracDate,
    this.currentGoalId,
    // this.goalText,
    this.priority,
    this.proficiency,
  }) : super();

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
        // goalText,
        priority,
        proficiency
      ];
}
