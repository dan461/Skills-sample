import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class SkillEvent extends Equatable {
  final int eventId;
  final int skillId;
  final int sessionId;
  final DateTime date;
  final int duration;
  final bool isComplete;
  // this string will be useful if a Skill has been deleted and
  // there are still past events for that Skill that need to be shown in Sessions,
  // or maybe don't actually delete Skills, just make them inactive
  final String skillString;

  SkillEvent(
      {this.eventId,
      @required this.skillId,
      @required this.sessionId,
      @required this.date,
      @required this.duration,
      @required this.isComplete,
      @required this.skillString});

  @override
  List<Object> get props =>
      [eventId, skillId, sessionId, date, duration, isComplete, skillString];
}
