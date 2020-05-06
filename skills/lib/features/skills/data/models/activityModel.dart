import 'package:flutter/material.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';

class ActivityModel extends Activity {
  ActivityModel(
      {int eventId,
      @required int skillId,
      @required int sessionId,
      @required DateTime date,
      @required int duration,
      @required bool isComplete,
      @required String skillString,
      String notes})
      : super(
            eventId: eventId,
            skillId: skillId,
            sessionId: sessionId,
            date: date,
            duration: duration,
            isComplete: isComplete,
            skillString: skillString,
            notes: notes);

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      eventId: map['eventId'],
      skillId: map['skillId'],
      sessionId: map['sessionId'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']).toUtc(),
      duration: map['duration'],
      isComplete: map['isComplete'] == 0 ? false : true,
      skillString: map['skillString'],
      notes: map['notes']
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
      'skillString': skillString,
      'notes' : notes == null ? '' : notes
    };
  }

  List<Object> get props =>
      [eventId, skillId, sessionId, date, duration, isComplete, skillString, notes];
}
