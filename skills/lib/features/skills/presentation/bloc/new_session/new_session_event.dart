import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';



abstract class NewSessionEvent extends Equatable {
  const NewSessionEvent();
}

class InsertNewSessionEvent extends NewSessionEvent {
  final Session newSession;

  InsertNewSessionEvent({@required this.newSession});
  @override
  List<Object> get props => [newSession];
}

class GetSessionWithIdEvent extends NewSessionEvent {
  final int id;

  GetSessionWithIdEvent({@required this.id});

  @override
  List<Object> get props => [id];
}

class SkillSelectedForSessionEvent extends NewSessionEvent {
  final Skill skill;

  SkillSelectedForSessionEvent({@required this.skill});

  @override
  List<Object> get props => null;
}

class EventsForSessionCreationEvent extends NewSessionEvent {
  final List<SkillEvent> events;
  final Session session;

  EventsForSessionCreationEvent({@required this.events, this.session});

  @override
  List<Object> get props => [events, session];
}

class EventCreationEvent extends NewSessionEvent {
  final SkillEvent event;

  EventCreationEvent({@required this.event});

  @override
  List<Object> get props => [event];
}


