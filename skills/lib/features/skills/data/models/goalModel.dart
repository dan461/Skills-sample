import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';

class GoalModel extends Goal {
  GoalModel(
      {int id,
      @required int fromDate,
      @required int toDate,
      @required bool timeBased,
      int goalTime,
      String desc})
      : super(
            fromDate: fromDate,
            toDate: toDate,
            timeBased: timeBased,
            goalTime: goalTime,
            desc: desc);

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
        fromDate: map['fromDate'],
        toDate: map['toDate'],
        timeBased: map['timeBased'],
        goalTime: map['goalTime'],
        desc: map['desc']);
  }

  Map<String, dynamic> toMap() {
    return {
      'fromDate': fromDate,
      'toDate': toDate,
      'timeBased': timeBased,
      'goalTime' : goalTime,
      'desc': desc
    };
  }

  @override
  List<Object> get props => [id, fromDate, toDate, timeBased, goalTime, desc];
}
