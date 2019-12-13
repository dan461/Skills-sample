import 'package:equatable/equatable.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/presentation/bloc/newGoalScreen/bloc.dart';

abstract class NewSessionState extends Equatable {
  const NewSessionState();
}

class InitialNewSessionState extends NewSessionState {
  @override
  List<Object> get props => [];
}

class NewSessionInsertingState extends NewgoalState {
  @override
  List<Object> get props => [];
}

class NewSessionInsertedState extends NewgoalState {
  final Session newSession;

  NewSessionInsertedState(this.newSession);

  @override
  List<Object> get props => [newSession];
}

class NewSessionErrorState extends NewgoalState {
  final String message;

  NewSessionErrorState(this.message);

  @override
  List<Object> get props => [message];
}
