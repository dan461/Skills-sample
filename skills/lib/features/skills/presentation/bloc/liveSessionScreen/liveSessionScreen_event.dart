part of 'liveSessionScreen_bloc.dart';

abstract class LiveSessionScreenEvent extends Equatable {
  const LiveSessionScreenEvent();
}

// may not need this
class StartLiveSessionEvent extends LiveSessionScreenEvent {
  @override
  List<Object> get props => null;
}

class LiveSessionActivitySelectedEvent extends LiveSessionScreenEvent {
  final Activity activity;

  LiveSessionActivitySelectedEvent({@required this.activity});

  @override
  List<Object> get props => [activity];
}

class LiveSessionActivityFinishedEvent extends LiveSessionScreenEvent {
  final Activity activity;
  final int elapsedTime;

  LiveSessionActivityFinishedEvent(
      {@required this.activity, @required this.elapsedTime});

  @override
  List<Object> get props => [activity, elapsedTime];
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
