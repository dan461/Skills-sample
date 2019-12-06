import 'package:equatable/equatable.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';

abstract class SkillEditorState extends Equatable {
  const SkillEditorState();
}

class InitialSkillEditorState extends SkillEditorState {
  @override
  List<Object> get props => [];
}

class SkillEditorCrudInProgressState extends SkillEditorState {
  @override
  List<Object> get props => [];
}

class CreatingNewSkillState extends SkillEditorState {
  @override
  List<Object> get props => [];
}

class EditingSkillState extends SkillEditorState {
  final Skill skill;

  EditingSkillState(this.skill);
  @override
  List<Object> get props => [skill];
}

class SkillRetrievedForEditingState extends SkillEditorState {
  final Skill skill;

  SkillRetrievedForEditingState(this.skill);

  @override
  List<Object> get props => [skill];
}

class NewSkillInsertingState extends SkillEditorState {
  @override
  List<Object> get props => [];
}

// class NewSkillInsertedState extends SkillEditorState {
//   final int newId;

//   NewSkillInsertedState(this.newId);
//   @override
//   List<Object> get props => [newId];
// }

class DeletingSkillWithIdState extends SkillEditorState {
  @override
  List<Object> get props => [];
}

class DeletedSkillWithIdState extends SkillEditorState {
  @override
  List<Object> get props => [];
}

class UpdatingSkillState extends SkillEditorState {
  @override
  List<Object> get props => [];
}

class UpdatedSkillState extends SkillEditorState {
  @override
  List<Object> get props => [];
}

class SkillEditorErrorState extends SkillEditorState {
  final String message;

  SkillEditorErrorState(this.message);
  @override
  List<Object> get props => [message];
}
