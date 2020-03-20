part of 'activesession_bloc.dart';

abstract class ActiveSessionEvent extends SessionEvent {
  const ActiveSessionEvent();
}

class ActiveSessionLoadInfoEvent extends ActiveSessionEvent {
  final Session session;
  final List<Activity> activities;

  ActiveSessionLoadInfoEvent(
      {@required this.session, @required this.activities});

  @override
  List<Object> get props => [activities];
}

class ActivitySelectedForTimerEvent extends ActiveSessionEvent {
  final Activity selectedActivity;

  ActivitySelectedForTimerEvent({@required this.selectedActivity});

  @override
  List<Object> get props => [selectedActivity];
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
