part of 'liveSessionScreen_bloc.dart';

abstract class LiveSessionScreenState extends Equatable {
  const LiveSessionScreenState();
}

class LiveSessionScreenInitial extends LiveSessionScreenState {
  @override
  List<Object> get props => [];
}

class LiveSessionActivitySelectedState extends LiveSessionScreenState {
  final Activity activity;

  LiveSessionActivitySelectedState({@required this.activity});

  @override
  List<Object> get props => [activity];
}

class LiveSessionProcessingState extends LiveSessionScreenState {
  @override
  List<Object> get props => null;
}

class LiveSessionSelectOrFinishState extends LiveSessionScreenState {
  @override
  List<Object> get props => null;
}

class LiveSessionReadyState extends LiveSessionScreenState {
  LiveSessionReadyState();

  @override
  List<Object> get props => null;
}

class LiveSessionFinishedState extends LiveSessionScreenState {
  LiveSessionFinishedState();

  @override
  List<Object> get props => null;
}

class LiveSessionScreenErrorState extends LiveSessionScreenState {
  final String message;

  LiveSessionScreenErrorState(this.message);

  @override
  List<Object> get props => [message];
}
