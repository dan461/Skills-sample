import 'package:flutter/material.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';

class GoalModel extends Goal {
  GoalModel(
      {int id,
      @required int skillId,
      @required int fromDate,
      @required int toDate,
      @required bool timeBased,
      @required bool isComplete,
      @required int goalTime,
      int timeRemaining,
      String desc})
      : super(
            id: id,
            skillId: skillId,
            fromDate: fromDate,
            toDate: toDate,
            isComplete: isComplete,
            timeBased: timeBased,
            goalTime: goalTime,
            timeRemaining: timeRemaining,
            desc: desc);

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
        id: map['id'],
        skillId: map['skillId'],
        fromDate: map['fromDate'],
        toDate: map['toDate'],
        isComplete: map['isComplete'] == 0 ? false : true,
        timeBased: map['timeBased'] == 0 ? false : true,
        goalTime: map['goalTime'],
        timeRemaining: map['timeRemaining'],
        desc: map['desc']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'skillId': skillId,
      'fromDate': fromDate,
      'toDate': toDate,
      'isComplete': isComplete,
      'timeBased': timeBased,
      'goalTime': goalTime,
      'timeRemaining': timeRemaining,
      'desc': desc
    };
  }

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
