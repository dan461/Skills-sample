part of 'sessiondata_bloc.dart';

abstract class SessiondataState extends Equatable {
  const SessiondataState();
}

class SessiondataInitial extends SessiondataState {
  @override
  List<Object> get props => [];
}

class SessionEditingState extends SessiondataState {
  @override
  List<Object> get props => null;
}

class SessionViewingState extends SessiondataState {
  @override
  List<Object> get props => null;
}

class SessionDataCrudInProgressState extends SessiondataState {
  @override
  List<Object> get props => null;
}

class SessionDataActivitesLoadedState extends SessiondataState {
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

class SessionUpdatedAndRefreshedState extends SessiondataState {
  final Session session;

  SessionUpdatedAndRefreshedState(this.session);
  @override
  List<Object> get props => null;
}

class SessionWasDeletedState extends SessiondataState {
  @override
  List<Object> get props => null;
}

class SkillSelectedForSessionState extends SessiondataState {
  final Skill skill;

  SkillSelectedForSessionState(this.skill);
  
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
