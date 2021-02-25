import 'package:flutter/material.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';

import 'package:skills/features/skills/domain/entities/skill.dart';

class SkillModel extends Skill {
  SkillModel(
      {int skillId,
      @required String name,
      @required String type,
      String source,
      String instrument,
      DateTime startDate,
      int totalTime,
      DateTime lastPracDate,
      int currentGoalId,
      int priority,
      double proficiency,
      Goal goal})
      : super(
            skillId: skillId,
            name: name,
            type: type,
            source: source,
            instrument: instrument,
            startDate: startDate,
            totalTime: totalTime,
            lastPracDate: lastPracDate,
            currentGoalId: currentGoalId,
            priority: priority,
            proficiency: proficiency,
            goal: goal);

  factory SkillModel.fromMap(Map<String, dynamic> map) {
    return SkillModel(
      skillId: map['skillId'],
      name: map['name'],
      type: map['type'],
      source: map['source'],
      instrument: map['instrument'],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']).toUtc(),
      totalTime: map['totalTime'],
      lastPracDate: map['lastPracDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastPracDate']).toUtc()
          : DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
      currentGoalId: map['goalId'],
      priority: map['priority'],
      proficiency: map['proficiency'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'skillId': skillId,
      'name': name,
      'type': type,
      'source': source,
      'instrument': instrument,
      'startDate': startDate.millisecondsSinceEpoch,
      'totalTime': totalTime,
      'lastPracDate': lastPracDate.millisecondsSinceEpoch,
      'goalId': currentGoalId,
      'priority': priority,
      'proficiency': proficiency
    };
  }

  @override
  List<Object> get props => [
        skillId,
        name,
        type,
        source,
        instrument,
        startDate,
        totalTime,
        lastPracDate,
        currentGoalId,
        priority,
        proficiency,
        goal
      ];
}
