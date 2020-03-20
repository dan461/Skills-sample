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

class SkillSelectedForActiveSessionEvent extends ActiveSessionEvent {
  final Skill skill;

  SkillSelectedForActiveSessionEvent({@required this.skill});

  @override
  List<Object> get props => [skill];
}
