part of 'activesession_bloc.dart';

abstract class ActiveSessionState extends SessionState {
  const ActiveSessionState();
}

class ActiveSessionInitial extends ActiveSessionState {
  ActiveSessionInitial();
  @override
  List<Object> get props => [];
}

class ActiveSessionInfoLoadedState extends ActiveSessionState {
  final int duration;
  final List<Map> activityMaps;

  ActiveSessionInfoLoadedState(
      {@required this.duration, @required this.activityMaps});
  @override
  List<Object> get props => [duration, activityMaps];
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
