import 'package:flutter/material.dart';
import 'package:skills/core/TickTock.dart';
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
        date: DateTime.fromMillisecondsSinceEpoch(map['date']).toUtc(),
        startTime: TickTock.timeFromInt(map['startTime']),
        endTime: TickTock.timeFromInt(map['endTime']),
        duration: map['duration'],
        timeRemaining: map['timeRemaining'],
        isScheduled: map['isScheduled'] == 0 ? false : true,
        isCompleted: map['isCompleted'] == 0 ? false : true);
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'date': date.millisecondsSinceEpoch,
      'startTime': TickTock.timeToInt(startTime),
      'endTime': TickTock.timeToInt(endTime),
      'duration': duration,
      'timeRemaining': timeRemaining,
      'isScheduled': isScheduled,
      'isCompleted': isCompleted
    };
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
