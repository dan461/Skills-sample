import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';

part 'activityeditor_event.dart';
part 'activityeditor_state.dart';

class ActivityEditorBloc extends Bloc<ActivityeditorEvent, ActivityEditorState> {
  Activity activity;


  @override
  ActivityEditorState get initialState => ActivityEditorInitial();

  @override
  Stream<ActivityEditorState> mapEventToState(
    ActivityeditorEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
