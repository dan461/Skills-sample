import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';

abstract class EventEditorEvent extends Equatable {
  const EventEditorEvent();
}

class EventSkillSelectedEvent extends EventEditorEvent {
  final Skill skill;

  EventSkillSelectedEvent({@required this.skill});
  @override
  List<Object> get props => [skill];
}

class NewEventCreationEvent extends EventEditorEvent {
  final Activity event;

  NewEventCreationEvent({@required this.event});

  @override
  List<Object> get props => [event];
}
