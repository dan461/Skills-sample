import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class Goal extends Equatable {
  final int goalId;
  final int skillId;
  final DateTime fromDate;
  final DateTime toDate;
  final bool isComplete;
  final bool timeBased;
  final int goalTime;
  final String goalText;
  final int timeRemaining;
  final String desc;

  Goal(
      {this.goalId,
      @required this.skillId,
      @required this.fromDate,
      @required this.toDate,
      @required this.isComplete,
      @required this.timeBased,
      @required this.goalTime,
      this.goalText,
      this.timeRemaining,
      this.desc})
      : super();

  @override
  List<Object> get props => [
        goalId,
        skillId,
        fromDate,
        toDate,
        isComplete,
        timeBased,
        goalTime,
        goalText,
        timeRemaining,
        desc
      ];
}
