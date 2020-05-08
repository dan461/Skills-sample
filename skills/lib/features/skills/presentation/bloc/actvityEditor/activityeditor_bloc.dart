import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'activityeditor_event.dart';
part 'activityeditor_state.dart';

class ActivityEditorBloc extends Bloc<ActivityeditorEvent, ActivityEditorState> {
  @override
  ActivityEditorState get initialState => ActivityEditorInitial();

  @override
  Stream<ActivityEditorState> mapEventToState(
    ActivityeditorEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
