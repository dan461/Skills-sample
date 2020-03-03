import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

part 'sessiondata_event.dart';
part 'sessiondata_state.dart';

class SessiondataBloc extends Bloc<SessiondataEvent, SessiondataState> {
  final UpdateSessionWithId updateSessionWithId;
  final DeleteSessionWithId deleteSessionWithId;
  final GetEventMapsForSession getEventMapsForSession;
  final InsertEventsForSessionUC insertEventsForSession;
  final CompleteSessionAndEvents completeSessionAndEvents;
  final DeleteEventByIdUC deleteEventByIdUC;

  SessiondataBloc(
      {this.updateSessionWithId,
      this.deleteSessionWithId,
      this.getEventMapsForSession,
      this.insertEventsForSession,
      this.completeSessionAndEvents,
      this.deleteEventByIdUC});

  @override
  SessiondataState get initialState => SessiondataInitial();

  Session session;
  DateTime sessionDate;
  TimeOfDay selectedStartTime;

  List<Map> eventMapsForListView = [];

  int completedEventsCount = 0;

  int get availableTime {
    var time = session.duration ?? 0;
    for (var map in eventMapsForListView) {
      var event = map['event'];
      time -= event.duration;
    }
    return time;
  }

  @override
  Stream<SessiondataState> mapEventToState(
    SessiondataEvent event,
  ) async* {
    if (event is GetActivitiesForSessionEvent) {
      session = event.session;
      sessionDate = session.date;
      selectedStartTime = session.startTime;
      yield SessionDataCrudInProgressState();

      final eventMapsOrFailure = await getEventMapsForSession(
          SessionByIdParams(sessionId: session.sessionId));
      yield eventMapsOrFailure.fold(
          (failure) => SessionDataErrorState(CACHE_FAILURE_MESSAGE), (maps) {
        eventMapsForListView = maps;
        _countCompletedEvents();
        return SessionDataEventsLoadedState();
      });    

     
    }
  }

  void _countCompletedEvents() {
    int count = 0;
    for (var map in eventMapsForListView) {
      SkillEvent event = map['event'];
      if (event.isComplete) count++;
    }
    completedEventsCount = count;
  }
}
