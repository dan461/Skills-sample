import 'package:flutter/material.dart';
import 'package:skills/features/skills/domain/entities/session.dart';

class SessionChangeMonitor {
  final Session session;

  SessionChangeMonitor(this.session) {
    if (session != null) {
      nameText = 'name';
      date = session.date;
      startTime = session.startTime;
      duration = session.duration;
      isComplete = session.isComplete;
    }
  }

  String nameText;
  DateTime date;
  TimeOfDay startTime;
  int duration;
  bool isComplete;

  bool get hasChanged {
    if (nameText != 'name' ||
        !date.isAtSameMomentAs(session.date) ||
        startTime != session.startTime ||
        duration != session.duration ||
        isComplete != session.isComplete)
      return true;
    else
      return false;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    if (nameText != 'name') map['name'] = nameText;

    if (!date.isAtSameMomentAs(session.date)) map['date'] = date;

    if (startTime != session.startTime) map['startTime'] = startTime;

    if (duration != session.duration) map['duration'] = duration;

    if (isComplete != session.isComplete) map['isComplete'] = isComplete;

    return map;
  }
}
