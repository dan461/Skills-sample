part of 'activesession_bloc.dart';

abstract class ActiveSessionState extends SessionState {
  const ActiveSessionState();
}

class ActiveSessionInitial extends ActiveSessionState {
  ActiveSessionInitial();
  @override
  List<Object> get props => [];
}

class ActiveSessionProcessingState extends ActiveSessionState {
  @override
  List<Object> get props => null;
}

class ActiveSessionErrorState extends ActiveSessionState {
  final String message;

  ActiveSessionErrorState(this.message);

  @override
  List<Object> get props => null;
}

class ActiveSessionInfoLoadedState extends ActiveSessionState {
  final int duration;
  final List<Activity> activities;

  ActiveSessionInfoLoadedState(
      {@required this.duration, @required this.activities});
  @override
  List<Object> get props => [duration, activities];
}

class ActivityReadyState extends ActiveSessionState {
  final Activity activity;

  ActivityReadyState({@required this.activity});

  @override
  List<Object> get props => [activity];
}

class ActivityTimerStoppedState extends ActiveSessionState {
  @override
  List<Object> get props => null;
}

class CurrentActivityFinishedState extends ActiveSessionState {
  @override
  List<Object> get props => null;
}

class ActiveSessionActivitiesRefreshedState extends ActiveSessionState {
  final List<Activity> activities;

  ActiveSessionActivitiesRefreshedState(this.activities);

  @override
  List<Object> get props => [activities];
}

class ActiveSessionCompletedState extends ActiveSessionState {
  @override
  List<Object> get props => null;
}
