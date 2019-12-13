import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class NewSessionBloc extends Bloc<NewSessionEvent, NewSessionState> {
  @override
  NewSessionState get initialState => InitialNewSessionState();

  @override
  Stream<NewSessionState> mapEventToState(
    NewSessionEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
