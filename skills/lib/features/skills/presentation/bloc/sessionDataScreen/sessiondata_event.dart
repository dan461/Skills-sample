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

class DeleteSessionWithIdEvent extends SessiondataEvent {
  final int id;

  DeleteSessionWithIdEvent({@required this.id});

  @override
  List<Object> get props => [id];
}


