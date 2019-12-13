import 'package:equatable/equatable.dart';
import 'package:skills/features/skills/domain/entities/session.dart';

abstract class NewSessionState extends Equatable {
  const NewSessionState();
}

class InitialNewSessionState extends NewSessionState {
  @override
  List<Object> get props => [];
}

class NewSessionInsertingState extends NewSessionState {
  @override
  List<Object> get props => [];
}

class NewSessionInsertedState extends NewSessionState {
  final Session newSession;

  NewSessionInsertedState(this.newSession);

  @override
  List<Object> get props => [newSession];
}

class NewSessionErrorState extends NewSessionState {
  final String message;

  NewSessionErrorState(this.message);

  @override
  List<Object> get props => [message];
}
