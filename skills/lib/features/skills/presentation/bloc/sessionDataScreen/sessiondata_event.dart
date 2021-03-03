part of 'sessiondata_bloc.dart';

abstract class SessiondataEvent extends SessionEvent {
  const SessiondataEvent();
}

class GetSessionAndActivitiesEvent extends SessiondataEvent {
  final int sessionId;

  GetSessionAndActivitiesEvent({@required this.sessionId});

  @override
  List<Object> get props => [sessionId];
}

class GetActivitiesForSessionEvent extends SessiondataEvent {
  final Session session;

  GetActivitiesForSessionEvent(this.session);

  @override
  List<Object> get props => [session];
}

class BeginSessionEditingEvent extends SessiondataEvent {
  @override
  List<Object> get props => null;
}

class CancelSessionEditingEvent extends SessiondataEvent {
  @override
  List<Object> get props => null;
}

class UpdateSessionEvent extends SessiondataEvent {
  final Map<String, dynamic> changeMap;

  UpdateSessionEvent(this.changeMap);

  @override
  List<Object> get props => [changeMap];
}

class CompleteSessionEvent extends SessiondataEvent {
  @override
  List<Object> get props => [];
}

class RefreshSessionFromCacheEvent extends SessiondataEvent {
  @override
  List<Object> get props => [];
}

class DeleteSessionWithIdEvent extends SessiondataEvent {
  final int id;

  DeleteSessionWithIdEvent({@required this.id});

  @override
  List<Object> get props => [id];
}

class SkillSelectedForSessionEvent extends SessiondataEvent {
  final Skill skill;

  SkillSelectedForSessionEvent({@required this.skill});

  @override
  List<Object> get props => [skill];
}

class CancelSkillForSessionEvent extends SessiondataEvent {
  @override
  List<Object> get props => null;
}

class InsertActivityForSessionEvent extends SessiondataEvent {
  final Activity activity;

  InsertActivityForSessionEvent(this.activity);

  @override
  List<Object> get props => [activity];
}

class RemoveActivityFromSessionEvent extends SessiondataEvent {
  final int eventId;

  RemoveActivityFromSessionEvent(this.eventId);

  @override
  List<Object> get props => [eventId];
}

class RefreshActivitiesListEvent extends SessiondataEvent {
  @override
  List<Object> get props => null;
}
