import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/usecases/insertNewSession.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import './bloc.dart';

class NewSessionBloc extends Bloc<NewSessionEvent, NewSessionState> {
  final InsertNewSession insertNewSession;

  NewSessionBloc({this.insertNewSession});

  @override
  NewSessionState get initialState => InitialNewSessionState();

  @override
  Stream<NewSessionState> mapEventToState(
    NewSessionEvent event,
  ) async* {
    if (event is InsertNewSessionEvent) {
      yield NewSessionInsertingState();
      final failureOrNewSession = await insertNewSession(
          SessionInsertOrUpdateParams(session: event.newSession));
      yield failureOrNewSession.fold(
          (failure) => NewSessionErrorState(CACHE_FAILURE_MESSAGE),
          (session) => NewSessionInsertedState(session));
    }
  }
}
