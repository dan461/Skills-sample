import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';

abstract class EventEditorState extends Equatable {
  const EventEditorState();
}

class InitialEventEditorState extends EventEditorState {
  @override
  List<Object> get props => [];
}

// class SkillSelectedForEventState extends EventEditorState {
//   final Skill skill;

//   SkillSelectedForEventState({@required this.skill});
//   @override
//   List<Object> get props => [skill];
// }

class CreatingSkillEventState extends EventEditorState {
  @override
  List<Object> get props => [];
}

// class SkillEventCreatedState extends EventEditorState {
//   final SkillEvent event;

//   SkillEventCreatedState({@required this.event});
//   @override
//   List<Object> get props => [event];
// }
