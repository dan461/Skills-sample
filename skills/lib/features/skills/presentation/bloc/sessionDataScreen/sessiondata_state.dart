part of 'sessiondata_bloc.dart';

abstract class SessiondataState extends Equatable {
  const SessiondataState();
}

class SessiondataInitial extends SessiondataState {
  @override
  List<Object> get props => [];
}

class SessionDataCrudInProgressState extends SessiondataState {
  @override
  List<Object> get props => null;
}

class SessionDataEventsLoadedState extends SessiondataState {
  @override
  List<Object> get props => null;
}

class SessionDataErrorState extends SessiondataState {
  final String message;

  SessionDataErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class SessionCompletedState extends SessiondataState {
  @override
  List<Object> get props => null;
}

class SessionUpdatedState extends SessiondataState {
  @override
  List<Object> get props => null;
}

class NewActivityCreatedState extends SessiondataState {
  @override
  List<Object> get props => null;
}

class ActivityRemovedFromSessionState extends SessiondataState {
  @override
  List<Object> get props => null;
}
