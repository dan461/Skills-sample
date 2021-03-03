import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class EventEditorBloc extends Bloc<EventEditorEvent, EventEditorState> {
  EventEditorBloc() : super(InitialEventEditorState());

  @override
  Stream<EventEditorState> mapEventToState(
    EventEditorEvent event,
  ) async* {
    if (event is EventSkillSelectedEvent) {
    } else if (event is NewEventCreationEvent) {}
  }
}
