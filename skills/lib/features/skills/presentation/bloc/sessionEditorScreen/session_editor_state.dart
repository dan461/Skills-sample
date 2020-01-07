import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/presentation/bloc/sessionEditorScreen/bloc.dart';

abstract class SessionEditorState extends Equatable {
  const SessionEditorState();
}

class InitialSessionEditorState extends SessionEditorState {
  @override
  List<Object> get props => [];
}

class EditingSessionState extends SessionEditorState {
  final Session session;
  final List<Map> eventMaps;

  EditingSessionState(this.session, this.eventMaps);
  @override
  List<Object> get props => [session];
}

class SessionUpdatedState extends SessionEditorState {
  @override
  List<Object> get props => [];
}

class SessionDeletedState extends SessionEditorState {
  @override
  List<Object> get props => [];
}

class SkillSelectedForSessionEditorState extends SessionEditorState {
  final Skill skill;

  SkillSelectedForSessionEditorState({@required this.skill});
  @override
  List<Object> get props => [skill];
}

class EventCreatedForSessionEditorState extends SessionEditorState {
  final SkillEvent event;

  EventCreatedForSessionEditorState({@required this.event});
  @override
  List<Object> get props => [event];
}

class SessionEditorCrudInProgressState extends SessionEditorState {
  @override
  List<Object> get props => [];
}

class SessionEditorErrorState extends SessionEditorState {
  final String message;

  SessionEditorErrorState(this.message);

  @override
  List<Object> get props => [message];
}
