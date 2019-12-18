import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class Session extends Equatable {
  final int sessionId;
  final DateTime date;
  final int startTime;
  final int endTime;
  final int duration;
  final int timeRemaining;
  final bool isScheduled;
  final bool isCompleted;

  Session(
      {this.sessionId,
      @required this.date,
      @required this.startTime,
      @required this.endTime,
      this.duration,
      this.timeRemaining,
      @required this.isScheduled,
      @required this.isCompleted})
      : super();

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
