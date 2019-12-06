import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class Skill extends Equatable {
  final int id;
  final String name;
  final String source;
  final int startDate;
  final int totalTime;
  final int lastPracDate;
  final int currentGoalId;
  final String goalText;

  Skill(
      {this.id,
      @required this.name,
      @required this.source,
      this.startDate,
      this.totalTime,
      this.lastPracDate,
      this.currentGoalId,
      this.goalText})
      : super();

  @override
  List<Object> get props => [
        id,
        name,
        source,
        startDate,
        totalTime,
        lastPracDate,
        currentGoalId,
        goalText
      ];
}
