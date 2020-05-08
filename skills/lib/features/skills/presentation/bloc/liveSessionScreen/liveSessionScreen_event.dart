part of 'liveSessionScreen_bloc.dart';

abstract class LiveSessionScreenEvent extends Equatable {
  const LiveSessionScreenEvent();
}

// may not need this
class StartLiveSessionEvent extends LiveSessionScreenEvent {
  @override
  List<Object> get props => null;
}

class LiveSessionSkillSelectedEvent extends LiveSessionScreenEvent {
  final Skill skill;

  LiveSessionSkillSelectedEvent({@required this.skill});

  @override
  List<Object> get props => [skill];
}

class LiveSessionActivityFinishedEvent extends LiveSessionScreenEvent {
  final int elapsedTime;
  final String notes;

  LiveSessionActivityFinishedEvent({@required this.elapsedTime, @required this.notes});

  @override
  List<Object> get props => [elapsedTime, notes];
}

class LiveSessionActivityCancelledEvent extends LiveSessionScreenEvent {
  @override
  List<Object> get props => null;
}

class LiveSessionActivityRemovedEvent extends LiveSessionScreenEvent {
  final Activity activity;

  LiveSessionActivityRemovedEvent({@required this.activity});

  @override
  List<Object> get props => [activity];
}

class LiveSessionFinishedEvent extends LiveSessionScreenEvent {
  LiveSessionFinishedEvent();

  @override
  List<Object> get props => null;
}

class LiveSessionCancelledEvent extends LiveSessionScreenEvent {
  LiveSessionCancelledEvent();

  @override
  List<Object> get props => null;
}
