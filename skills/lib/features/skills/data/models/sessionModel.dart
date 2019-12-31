import 'package:flutter/material.dart';
import 'package:skills/features/skills/domain/entities/session.dart';

class SessionModel extends Session {
  SessionModel(
      {int sessionId,
      @required DateTime date,
      @required TimeOfDay startTime,
      @required TimeOfDay endTime,
      int duration,
      int timeRemaining,
      @required bool isScheduled,
      @required bool isCompleted})
      : super(
            sessionId: sessionId,
            date: date,
            startTime: startTime,
            endTime: endTime,
            duration: duration,
            timeRemaining: timeRemaining,
            isScheduled: isScheduled,
            isCompleted: isCompleted);

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
        sessionId: map['sessionId'],
        date: DateTime.fromMillisecondsSinceEpoch(map['date']),
        startTime: TimeOfDay(
            hour: DateTime.fromMillisecondsSinceEpoch(map['startTime']).hour,
            minute:
                DateTime.fromMillisecondsSinceEpoch(map['startTime']).minute),
        endTime: TimeOfDay(
            hour: DateTime.fromMillisecondsSinceEpoch(map['endTime']).hour,
            minute: DateTime.fromMillisecondsSinceEpoch(map['endTime']).minute),
        duration: map['duration'],
        timeRemaining: map['timeRemaining'],
        isScheduled: map['isScheduled'] == 0 ? false : true,
        isCompleted: map['isCompleted'] == 0 ? false : true);
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'date': date.millisecondsSinceEpoch,
      'startTime': timeToInt(date, startTime),
      'endTime': timeToInt(date, endTime),
      'duration': duration,
      'timeRemaining': timeRemaining,
      'isScheduled': isScheduled,
      'isCompleted': isCompleted
    };
  }

  TimeOfDay intToTimeOfDay(int dateInt) {
    var date = DateTime.fromMillisecondsSinceEpoch(dateInt);
    return TimeOfDay(hour: date.hour, minute: date.minute);
  }

  int timeToInt(DateTime date, TimeOfDay timeOfDay) {
    return DateTime(
            date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute)
        .millisecondsSinceEpoch;
  }

  @override
  List<Object> get props => [
        sessionId,
        date,
        startTime,
        endTime,
        duration,
        timeRemaining,
        isCompleted,
        isScheduled
      ];
}
