import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class SkillEvent extends Equatable {
  final int eventId;
  final int skillId;
  final int sessionId;
  final DateTime date;
  final int duration;
  final bool isComplete;
  final String skillString;

  SkillEvent(
      {@required this.eventId,
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
