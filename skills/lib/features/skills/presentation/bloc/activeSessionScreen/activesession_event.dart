part of 'activesession_bloc.dart';

abstract class ActiveSessionEvent extends Equatable {
  const ActiveSessionEvent();
}

class ActiveSessionLoadInfoEvent extends ActiveSessionEvent {
  final Session session;
  final List<Map> activityMaps;

  ActiveSessionLoadInfoEvent(
      {@required this.session, @required this.activityMaps});

  @override
  List<Object> get props => null;
}
