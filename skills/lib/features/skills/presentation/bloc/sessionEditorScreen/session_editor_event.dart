import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/features/skills/domain/entities/session.dart';

abstract class SessionEditorEvent extends Equatable {
  const SessionEditorEvent();
}

class BeginSessionEditingEvent extends SessionEditorEvent {
  final Session session;

  BeginSessionEditingEvent({@required this.session});

  @override
  List<Object> get props => [session];
}

class UpdateSessionEvent extends SessionEditorEvent {
  final Map<String, dynamic> changeMap;

  UpdateSessionEvent(this.changeMap);

  @override
  List<Object> get props => [changeMap];
}

class DeleteSessionWithIdEvent extends SessionEditorEvent {
  final int id;

  DeleteSessionWithIdEvent({@required this.id});

  @override
  List<Object> get props => [id];
}
