part of 'activityeditor_bloc.dart';

abstract class ActivityEditorState extends Equatable {
  const ActivityEditorState();
}

class ActivityEditorInitial extends ActivityEditorState {
  @override
  List<Object> get props => [];
}

class ActivityEditorCrudInProgressState extends ActivityEditorState {
  @override
  List<Object> get props => [];
}

class ActivityEditorUpdateCompleteState extends ActivityEditorState {
  @override
  List<Object> get props => [];
}

class ActivityEditorErrorState extends ActivityEditorState {
  final String message;

  ActivityEditorErrorState(this.message);

  @override
  List<Object> get props => [message];
}
