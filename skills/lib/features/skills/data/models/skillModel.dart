import 'package:flutter/material.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';

class SkillModel extends Skill {
//  int id;
//  String name;
//  String source;
//  int startDate;
//  int totalTime;

  SkillModel({
    int id,
    @required String name,
    @required String source,
    int startDate,
    int totalTime,
    int lastPracDate,
    int currentGoalId,
    String goalText,
  }) : super(
            id: id,
            name: name,
            source: source,
            startDate: startDate,
            totalTime: totalTime,
            lastPracDate: lastPracDate,
            currentGoalId: currentGoalId,
            goalText: goalText);

  factory SkillModel.fromMap(Map<String, dynamic> map) {
    return SkillModel(
        id: map['skillId'],
        name: map['name'],
        source: map['source'],
        startDate: map['startDate'],
        totalTime: map['totalTime'],
        lastPracDate: map['lastPracDate'],
        currentGoalId: map['currentGoalId'],
        goalText: map['goalText']);
  }

  Map<String, dynamic> toMap() {
    return {
      'skillId': id,
      'name': name,
      'source': source,
      'startDate': startDate,
      'totalTime': totalTime,
      'lastPracDate': lastPracDate,
      'currentGoalId': currentGoalId,
      'goalText': goalText
    };
  }

  @override
  List<Object> get props => [id, name, source, startDate, totalTime, lastPracDate, currentGoalId, goalText];
}
