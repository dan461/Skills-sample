import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';

abstract class BlocEvent extends Equatable {
  const BlocEvent();
}

abstract class SessionEditorEvent extends BlocEvent {
  const SessionEditorEvent();
}

class BeginSessionEditingEvent extends SessionEditorEvent {
  final Session session;

  BeginSessionEditingEvent({@required this.session});

  @override
  List<Object> get props => [session];
}

class UpdateSessionEvent extends SessionEditorEvent {
  final Map<String, dynamic> changeMap;

  UpdateSessionEvent(this.changeMap);

  @override
  List<Object> get props => [changeMap];
}

class DeleteSessionWithIdEvent extends SessionEditorEvent {
  final int id;

  DeleteSessionWithIdEvent({@required this.id});

  @override
  List<Object> get props => [id];
}

class SkillSelectedForExistingSessionEvent extends SessionEditorEvent {
  final Skill skill;

  SkillSelectedForExistingSessionEvent({@required this.skill});

  @override
  List<Object> get props => null;
}

class InsertEventForSessionEvnt extends SessionEditorEvent {
  final SkillEvent event;

  InsertEventForSessionEvnt(this.event);

  @override
  List<Object> get props => [event];
}

class RefreshEventsListEvnt extends SessionEditorEvent {
  @override
  List<Object> get props => [];
}

class EventsCreationForExistingSessionEvent extends SessionEditorEvent {
  final List<SkillEvent> events;

  EventsCreationForExistingSessionEvent({@required this.events});

  @override
  List<Object> get props => [events];
}

class DeleteEventFromSessionEvent extends SessionEditorEvent {
  final int eventId;

  DeleteEventFromSessionEvent(this.eventId);
  @override
  List<Object> get props => null;
}
