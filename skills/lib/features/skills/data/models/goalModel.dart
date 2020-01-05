import 'package:flutter/material.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';

class GoalModel extends Goal {
  GoalModel(
      {int goalId,
      @required int skillId,
      @required DateTime fromDate,
      @required DateTime toDate,
      @required bool timeBased,
      @required bool isComplete,
      @required int goalTime,
      int timeRemaining,
      String desc})
      : super(
            goalId: goalId,
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
        goalId: map['goalId'],
        skillId: map['skillId'],
        fromDate: DateTime.fromMillisecondsSinceEpoch(map['fromDate']),
        toDate: DateTime.fromMillisecondsSinceEpoch(map['toDate']),
        timeBased: map['timeBased'] == 0 ? false : true,
        isComplete: map['isComplete'] == 0 ? false : true,
        goalTime: map['goalTime'],
        timeRemaining: map['timeRemaining'],
        desc: map['desc']);
  }

  Map<String, dynamic> toMap() {
    return {
      'goalId': goalId,
      'skillId': skillId,
      'fromDate': fromDate.millisecondsSinceEpoch,
      'toDate': toDate.millisecondsSinceEpoch,
      'isComplete': isComplete,
      'timeBased': timeBased,
      'goalTime': goalTime,
      'timeRemaining': timeRemaining,
      'desc': desc
    };
  }

  @override
  List<Object> get props => [
        goalId,
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
