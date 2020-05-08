part of 'activityeditor_bloc.dart';

abstract class ActivityEditorState extends Equatable {
  const ActivityEditorState();
}

class ActivityEditorInitial extends ActivityEditorState {
  @override
  List<Object> get props => [];
}
