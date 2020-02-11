import 'package:flutter/foundation.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';

class GoalCrudParams extends Params {
  final int id;
  final Goal goal;

  GoalCrudParams({this.id, this.goal}) : super();
}

class AddGoalToSkillParams extends Params {
  final int skillId;
  final int goalId;
  final String goalText;

  AddGoalToSkillParams(
      {@required this.skillId, @required this.goalId, @required this.goalText});
}

class GetSkillParams extends Params {
  final int id;

  GetSkillParams({@required this.id}) : super();

  @override
  List<Object> get props => [id];
}

class SkillInsertOrUpdateParams extends Params {
  final Skill skill;

  SkillInsertOrUpdateParams({@required this.skill}) : super();

  @override
  List<Object> get props => [skill];
}

class SkillDeleteParams extends Params {
  final int skillId;

  SkillDeleteParams({@required this.skillId});

  @override
  List<Object> get props => [skillId];
}

class SkillUpdateParams extends Params {
  final int skillId;
  final Map changeMap;

  SkillUpdateParams({this.skillId, this.changeMap});
}

class SessionInsertOrUpdateParams extends Params {
  final Session session;

  SessionInsertOrUpdateParams({@required this.session}) : super();

  @override
  List<Object> get props => [session];
}

class SessionByIdParams extends Params {
  final int sessionId;

  SessionByIdParams({@required this.sessionId});
  @override
  List<Object> get props => [sessionId];
}

class SessionCompleteParams extends Params {
  final int sessionId;
  final DateTime date;

  SessionCompleteParams(this.sessionId, this.date);

  List<Object> get props => [sessionId, date];
}

class SessionInMonthParams extends Params {
  final DateTime month;

  SessionInMonthParams(this.month);
  @override
  List<Object> get props => [month];
}

class SessionsInDateRangeParams extends Params {
  final List<DateTime> dates;

  SessionsInDateRangeParams(this.dates);
  @override
  List<Object> get props => [dates];
}

class SessionUpdateParams extends Params {
  final int sessionId;
  final Map<String, dynamic> changeMap;

  SessionUpdateParams({@required this.sessionId, @required this.changeMap});
  @override
  List<Object> get props => [sessionId, changeMap];
}

class SessionDeleteParams extends Params {
  final int sessionId;

  SessionDeleteParams({@required this.sessionId});
  @override
  List<Object> get props => [sessionId];
}

class SkillEventInsertOrUpdateParams extends Params {
  final SkillEvent event;

  SkillEventInsertOrUpdateParams({@required this.event});
  @override
  List<Object> get props => [event];
}

class SkillEventUpdateParams extends Params {
  final Map<String, dynamic> changeMap;
  final int eventId;

  SkillEventUpdateParams(this.changeMap, this.eventId);

  @override
  List<Object> get props => [changeMap, eventId];
}

class SkillEventGetOrDeleteParams extends Params {
  final int eventId;

  SkillEventGetOrDeleteParams({@required this.eventId});
  @override
  List<Object> get props => [eventId];
}

class SkillEventMultiInsertParams extends Params {
  final List<SkillEvent> events;
  final int newSessionId;

  SkillEventMultiInsertParams(
      {@required this.events, @required this.newSessionId});

  @override
  List<Object> get props => [events];
}
