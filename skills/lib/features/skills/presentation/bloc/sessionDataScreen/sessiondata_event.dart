part of 'sessiondata_bloc.dart';

abstract class SessiondataEvent extends Equatable {
  const SessiondataEvent();
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

class InsertActivityForSessionEvent extends SessiondataEvent {
  final SkillEvent activity;

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
