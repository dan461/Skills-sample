import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      String goalText,
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
            goalText: goalText,
            timeRemaining: timeRemaining,
            desc: desc);

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
        goalId: map['goalId'],
        skillId: map['skillId'],
        fromDate: DateTime.fromMillisecondsSinceEpoch(map['fromDate']).toUtc(),
        toDate: DateTime.fromMillisecondsSinceEpoch(map['toDate']).toUtc(),
        timeBased: map['timeBased'] == 0 ? false : true,
        isComplete: map['isComplete'] == 0 ? false : true,
        goalTime: map['goalTime'],
        goalText: map['goalText'],
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
      'goalText': goalText,
      'timeRemaining': timeRemaining,
      'desc': desc
    };
  }

  static String translateGoal(Goal goal) {
    String translation;
    final durationString = createDurationString(goal.fromDate, goal.toDate);

    if (goal.timeBased) {
      final timeString = createGoalTimeString(goal.goalTime);
      translation = 'Goal: $timeString $durationString.';
    } else {
      var desc = goal.desc;
      translation = 'Goal: $desc $durationString.';
    }

    return translation;
  }

  static String createGoalTimeString(int time) {
    String timeString;

    String hours;
    String min;
    if (time < 60) {
      min = time.toString();
      timeString = '$min minutes';
    } else if (time == 60) {
      timeString = '1 hour';
    } else {
      hours = (time / 60).floor().toString();
      timeString = '$hours hrs';
      if (time % 60 != 0) {
        min = (time % 60).toString();
        timeString = '$hours hrs $min min';
      }
    }

    return timeString;
  }

  static String createDurationString(DateTime from, DateTime to) {
    String durationString;

    // final fromDate = DateTime.fromMillisecondsSinceEpoch(from);
    final fromString = DateFormat.MMMd().format(from);
    if (from == to) {
      durationString = 'on $fromString';
    } else {
      final toString = DateFormat.MMMd().format(to);
      durationString = 'between $fromString and $toString';
    }
    return durationString;
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
        goalText,
        timeRemaining,
        desc
      ];
}
