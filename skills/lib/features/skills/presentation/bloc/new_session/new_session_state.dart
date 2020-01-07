import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';

abstract class NewSessionState extends Equatable {
  const NewSessionState();
}

class InitialNewSessionState extends NewSessionState {
  @override
  List<Object> get props => [];
}

// class NewSessionInsertingState extends NewSessionState {
//   @override
//   List<Object> get props => [];
// }

class EventsCreatedForSessionState extends NewSessionState {
  @override
  List<Object> get props => [null];
}

class NewSessionInsertedState extends NewSessionState {
  final Session newSession;
  final List<SkillEvent> events;

  NewSessionInsertedState({@required this.newSession, @required this.events});

  @override
  List<Object> get props => [newSession];
}

class NewSessionErrorState extends NewSessionState {
  final String message;

  NewSessionErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class SkillSelectedForEventState extends NewSessionState {
  final Skill skill;

  SkillSelectedForEventState({@required this.skill});
  @override
  List<Object> get props => [skill];
}

class NewSessionCrudInProgressState extends NewSessionState {
  @override
  List<Object> get props => [];
}

class SkillEventCreatedState extends NewSessionState {
  final SkillEvent event;

  SkillEventCreatedState({@required this.event});
  @override
  List<Object> get props => [event];
}


