import 'package:equatable/equatable.dart';
import 'package:skills/features/skills/domain/entities/session.dart';

abstract class NewSessionEvent extends Equatable {
  const NewSessionEvent();
}

class InsertNewSessionEvent extends NewSessionEvent {
  final Session newSession;

  InsertNewSessionEvent(this.newSession);
  @override
  List<Object> get props => [newSession];
  
}


