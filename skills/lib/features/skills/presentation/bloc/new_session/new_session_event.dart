import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/features/skills/domain/entities/session.dart';

abstract class NewSessionEvent extends Equatable {
  const NewSessionEvent();
}

class InsertNewSessionEvent extends NewSessionEvent {
  final Session newSession;

  InsertNewSessionEvent({@required this.newSession});
  @override
  List<Object> get props => [newSession];
  
}

class GetSessionWithIdEvent extends NewSessionEvent {
  final int id;

  GetSessionWithIdEvent({@required this.id});

  @override
  List<Object> get props => [id];
}

class DeleteSessionWithIdEvent extends NewSessionEvent {
  final int id;

  DeleteSessionWithIdEvent({@required this.id});

  @override
  List<Object> get props => [id];
}


