import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class Skill extends Equatable {
  final int id;
  final String name;
  final String source;
  final int startDate;
  final int totalTime;
  final int currentGoalId;
  final String goalText;

  Skill({
    this.id,
    @required this.name,
    @required this.source,
    this.startDate,
    this.totalTime,
    this.currentGoalId,
    this.goalText
  }) : super();

  @override
  List<Object> get props => [id,name,source,startDate,totalTime, currentGoalId, goalText];

//  Skill({int id, String name, String source}) {
//    this.id = id;
//    this.name = name;
//    this.source = source;
//  }
}
