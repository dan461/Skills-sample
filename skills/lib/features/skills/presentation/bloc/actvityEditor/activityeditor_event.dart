part of 'activityeditor_bloc.dart';

abstract class ActivityeditorEvent extends Equatable {
  const ActivityeditorEvent();
}

class ActivityEditorSaveEvent extends ActivityeditorEvent {
  // final Map<String, dynamic> changeMap;

  ActivityEditorSaveEvent();

  @override
  List<Object> get props => null;
  
}
