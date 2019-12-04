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
    int currentGoalId,
    String goalText,
  }) : super(
            id: id,
            name: name,
            source: source,
            startDate: startDate,
            totalTime: totalTime,
            currentGoalId: currentGoalId,
            goalText: goalText);

  factory SkillModel.fromMap(Map<String, dynamic> map) {
    return SkillModel(
        id: map['id'],
        name: map['name'],
        source: map['source'],
        startDate: map['startDate'],
        totalTime: map['totalTime'],
        currentGoalId: map['currentGoalId'],
        goalText: map['goalText']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'source': source,
      'startDate': startDate,
      'totalTime': totalTime,
      'currentGoalId': currentGoalId,
      'goalText': goalText
    };
  }

  @override
  List<Object> get props => [id, name, source, startDate, totalTime, currentGoalId, goalText];
}
