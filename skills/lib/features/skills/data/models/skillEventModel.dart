import 'package:flutter/material.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';

class SkillEventModel extends SkillEvent {
  SkillEventModel(
      {@required int eventId,
      @required int skillId,
      @required int sessionId,
      @required DateTime date,
      @required int duration,
      @required bool isComplete,
      @required String skillString})
      : super(
            eventId: eventId,
            skillId: skillId,
            sessionId: sessionId,
            date: date,
            duration: duration,
            isComplete: isComplete,
            skillString: skillString);

  factory SkillEventModel.fromMap(Map<String, dynamic> map) {
    return SkillEventModel(
      eventId: map['eventId'],
      skillId: map['skillId'],
      sessionId: map['sessionId'],
      date: DateTime.fromMicrosecondsSinceEpoch(map['date']),
      duration: map['duration'],
      isComplete: map['isComplete'] == 0 ? false : true,
      skillString: map['skillString'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'skillId': skillId,
      'sessionId': sessionId,
      'date': date.millisecondsSinceEpoch,
      'duration': duration,
      'isComplete': isComplete,
      'skillString': skillString
    };
  }

  List<Object> get props =>
      [eventId, skillId, sessionId, date, duration, isComplete, skillString];
}
