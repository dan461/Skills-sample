import 'package:flutter/material.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';

class SkillModel extends Skill {
//  int id;
//  String name;
//  String source;
//  int startDate;
//  int totalTime;

  SkillModel({
    int skillId,
    @required String name,
    @required String source,
    DateTime startDate,
    int totalTime,
    DateTime lastPracDate,
    int currentGoalId,
    String goalText,
  }) : super(
            skillId: skillId,
            name: name,
            source: source,
            startDate: startDate,
            totalTime: totalTime,
            lastPracDate: lastPracDate,
            currentGoalId: currentGoalId,
            goalText: goalText);

  factory SkillModel.fromMap(Map<String, dynamic> map) {
    return SkillModel(
        skillId: map['skillId'],
        name: map['name'],
        source: map['source'],
        startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']).toUtc() ,
        totalTime: map['totalTime'],
        lastPracDate: map['lastPracDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['lastPracDate']).toUtc() : DateTime.fromMillisecondsSinceEpoch(map['startDate']).toUtc(),
        currentGoalId: map['goalId'],
        goalText: map['goalText']);
  }

  Map<String, dynamic> toMap() {
    return {
      'skillId': skillId,
      'name': name,
      'source': source,
      'startDate': startDate.millisecondsSinceEpoch,
      'totalTime': totalTime,
      'lastPracDate': lastPracDate.millisecondsSinceEpoch,
      'goalId': currentGoalId,
      'goalText': goalText
    };
  }

  @override
  List<Object> get props => [skillId, name, source, startDate, totalTime, lastPracDate, currentGoalId, goalText];
}
