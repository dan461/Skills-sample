import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';

part 'liveSessionScreen_event.dart';
part 'liveSessionScreen_state.dart';

class LiveSessionScreenBloc extends Bloc<LiveSessionScreenEvent, LiveSessionScreenState> {
  @override
  LiveSessionScreenState get initialState => LiveSessionScreenInitial();

  @override
  Stream<LiveSessionScreenState> mapEventToState(
    LiveSessionScreenEvent event,
  ) async* {
    
  }
}
