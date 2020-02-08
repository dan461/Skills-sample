import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:skills/features/skills/presentation/widgets/CalendarWidgets/calendar.dart';
import 'package:skills/features/skills/presentation/widgets/CalendarWidgets/weekSessionBox.dart';

class Session extends Equatable implements CalendarEvent {
  final int sessionId;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int duration;
  final int timeRemaining;
  final bool isScheduled;
  final bool isComplete;
  Widget eventView; // ignored by sqlite/SessionModel

  int get sessionduration {
    int minutes;
    if (startTime == null || endTime == null)
      minutes = 0;
    else {
      int hours = endTime.hour - startTime.hour;
      minutes = endTime.minute - startTime.minute + hours * 60;
    }
    return minutes;
  }

  Session(
      {this.sessionId,
      @required this.date,
      @required this.startTime,
      @required this.endTime,
      this.duration,
      this.timeRemaining,
      @required this.isScheduled,
      @required this.isComplete,
      this.eventView})
      : super();

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

  // @override
  // Widget eventView;
}
