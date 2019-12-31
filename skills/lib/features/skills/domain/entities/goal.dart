import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class Goal extends Equatable {
  final int id;
  final int skillId;
  final DateTime fromDate;
  final DateTime toDate;
  final bool isComplete;
  final bool timeBased;
  final int goalTime;
  final int timeRemaining;
  final String desc;

  Goal(
      {this.id,
      @required this.skillId,
      @required this.fromDate,
      @required this.toDate,
      @required this.isComplete,
      @required this.timeBased,
      @required this.goalTime,
      this.timeRemaining,
      this.desc})
      : super();

  @override
  List<Object> get props => [
        id,
        skillId,
        fromDate,
        toDate,
        isComplete,
        timeBased,
        goalTime,
        timeRemaining,
        desc
      ];
}
