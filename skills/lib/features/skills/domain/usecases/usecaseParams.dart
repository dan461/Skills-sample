import 'package:flutter/foundation.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';

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

class SessionInMonthParams extends Params {
  final DateTime month;

  SessionInMonthParams(this.month);
  @override
  List<Object> get props => [month];
}

class SessionDeleteParams extends Params {
  final int sessionId;

  SessionDeleteParams({@required this.sessionId});
  @override
  List<Object> get props => [sessionId];
}
