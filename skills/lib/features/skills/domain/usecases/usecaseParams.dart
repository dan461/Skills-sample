import 'package:flutter/foundation.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';

class GoalCrudParams extends Params {
  final int id;
  final Goal goal;

  GoalCrudParams({this.id, this.goal}) : super();
}

class AddGoalToSkillParams extends Params {
  final int skillId;
  final int goalId;

  AddGoalToSkillParams({@required this.skillId, @required this.goalId});
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

class ActivityInsertOrUpdateParams extends Params {
  final Activity activity;

  ActivityInsertOrUpdateParams({@required this.activity});
  @override
  List<Object> get props => [activity];
}

class ActivityUpdateParams extends Params {
  final Map<String, dynamic> changeMap;
  final int activityId;

  ActivityUpdateParams(this.changeMap, this.activityId);

  @override
  List<Object> get props => [changeMap, activityId];
}

class ActivityCompleteParams extends Params {
  final int activityId;
  final DateTime date;
  final int elapsedTime;
  final int skillId;


  ActivityCompleteParams(this.activityId, this.date, this.elapsedTime, this.skillId);
  @override
  List<Object> get props => [activityId, date, elapsedTime, skillId];
}

class ActivityGetOrDeleteParams extends Params {
  final int activityId;

  ActivityGetOrDeleteParams({@required this.activityId});
  @override
  List<Object> get props => [activityId];
}

class ActivityMultiInsertParams extends Params {
  final List<Activity> activities;
  final int newSessionId;

  ActivityMultiInsertParams(
      {@required this.activities, @required this.newSessionId});

  @override
  List<Object> get props => [activities];
}
