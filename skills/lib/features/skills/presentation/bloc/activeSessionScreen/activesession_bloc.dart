import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/presentation/pages/activeSessionScreen.dart';

part 'activesession_event.dart';
part 'activesession_state.dart';

class ActiveSessionBloc extends Bloc<ActiveSessionEvent, ActiveSessionState> {
  Session session;
  List<Map> activityMapsForListView = [];

  @override
  ActiveSessionState get initialState => ActiveSessionInitial();

  @override
  Stream<ActiveSessionState> mapEventToState(
    ActiveSessionEvent event,
  ) async* {
    if (event is ActiveSessionLoadInfoEvent) {
      activityMapsForListView = event.activityMaps;
      session = event.session;
      yield ActiveSessionInfoLoadedState(
          duration: session.duration, activityMaps: activityMapsForListView);
    }
  }
}
