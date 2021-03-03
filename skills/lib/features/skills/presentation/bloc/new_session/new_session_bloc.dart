import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import './bloc.dart';

class NewSessionBloc extends Bloc<NewSessionEvent, NewSessionState> {
  final InsertNewSession insertNewSession;

  NewSessionBloc({
    this.insertNewSession,
  }) : super(InitialNewSessionState());

  TimeOfDay selectedStartTime;
  TimeOfDay selectedFinishTime;
  DateTime sessionDate;
  Skill selectedSkill;
  Goal currentGoal;
  Session sessionForEdit;
  var pendingEvents = <Activity>[];
  var pendingEventMapsForListView = <Map>[];
  var eventMapsForSession = <Map>[];

  int eventDuration;

  @override
  void onTransition(Transition<NewSessionEvent, NewSessionState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<NewSessionState> mapEventToState(
    NewSessionEvent event,
  ) async* {
    // Cache New Session
    if (event is InsertNewSessionEvent) {
      yield NewSessionCrudInProgressState();
      final failureOrNewSession = await insertNewSession(
          SessionInsertOrUpdateParams(session: event.newSession));
      yield failureOrNewSession.fold(
          (failure) => NewSessionErrorState(CACHE_FAILURE_MESSAGE), (session) {
        return NewSessionInsertedState(newSession: session);
      });
    }
  }
}
