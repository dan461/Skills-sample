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
      @required bool isComplete})
      : super(
            sessionId: sessionId,
            date: date,
            startTime: startTime,
            endTime: endTime,
            duration: duration,
            timeRemaining: timeRemaining,
            isScheduled: isScheduled,
            isComplete: isComplete);

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    // TODO - just in case a Session was made with an hour value not zero
    DateTime date = DateTime.fromMillisecondsSinceEpoch(map['date']).toUtc();
    if (date.hour != 0)
    {
      date = date.subtract(Duration(hours:date.hour)); 
    }

    return SessionModel(
        sessionId: map['sessionId'],
        date: date,
        startTime: TickTock.timeFromInt(map['startTime']),
        endTime: TickTock.timeFromInt(map['endTime']),
        duration: map['duration'],
        timeRemaining: map['timeRemaining'],
        isScheduled: map['isScheduled'] == 0 ? false : true,
        isComplete: map['isComplete'] == 0 ? false : true);
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
      'isComplete': isComplete
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
        isComplete,
        isScheduled
      ];
}
