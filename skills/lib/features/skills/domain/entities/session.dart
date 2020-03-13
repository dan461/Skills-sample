import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:skills/features/skills/presentation/widgets/CalendarWidgets/calendar.dart';

class Session extends Equatable implements CalendarEvent {
  final int sessionId;
  final DateTime date;
  final TimeOfDay startTime;

  final int duration;
  final int timeRemaining;
  final bool isScheduled;
  final bool isComplete;
  Widget weekView; // ignored by sqlite/SessionModel
  Widget dayView; // ignored by sqlite/SessionModel
  int openTime; // ignored by sqlite/SessionModel

  int get sessionduration {
    int minutes;
    if (startTime == null)
      minutes = 0;
    else {
      minutes = startTime.minute + startTime.hour * 60;
    }
    return minutes;
  }

  Session(
      {this.sessionId,
      @required this.date,
      @required this.startTime,
      this.duration,
      this.timeRemaining,
      @required this.isScheduled,
      @required this.isComplete,
      this.weekView,
      this.dayView,
      this.openTime})
      : super();

  @override
  List<Object> get props => [
        sessionId,
        date,
        startTime,
        duration,
        timeRemaining,
        isComplete,
        isScheduled
      ];

  // @override
  // Widget eventView;
}
