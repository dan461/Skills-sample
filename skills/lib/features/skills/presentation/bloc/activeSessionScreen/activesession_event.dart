part of 'activesession_bloc.dart';

abstract class ActiveSessionEvent extends SessionEvent {
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

class ActivitySelectedForTimerEvent extends ActiveSessionEvent {
  final Map<String, dynamic> selectedMap;

  ActivitySelectedForTimerEvent({@required this.selectedMap});

  @override
  List<Object> get props => [selectedMap];
}

class ActivityTimerStoppedEvent extends ActiveSessionEvent {
  @override
  List<Object> get props => null;
}

class CurrentActivityFinishedEvent extends ActiveSessionEvent {
  final int time;

  CurrentActivityFinishedEvent({@required this.time});

  @override
  List<Object> get props => null;
}

class SkillSelectedForActiveSessionEvent extends ActiveSessionEvent {
  final Skill skill;

  SkillSelectedForActiveSessionEvent({@required this.skill});

  @override
  List<Object> get props => [skill];
}
