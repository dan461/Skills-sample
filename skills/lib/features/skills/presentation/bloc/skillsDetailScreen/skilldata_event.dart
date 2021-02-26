part of 'skilldata_bloc.dart';

abstract class SkillDataEvent extends Equatable {
  const SkillDataEvent();
}

class GetEventsForSkillEvent extends SkillDataEvent {
  final int skillId;

  GetEventsForSkillEvent({@required this.skillId});

  @override
  List<Object> get props => null;
}

class UpdateExistingSkillEvent extends SkillDataEvent {
  final int skillId;
  final Map<String, dynamic> changeMap;

  UpdateExistingSkillEvent({@required this.skillId, @required this.changeMap});

  @override
  List<Object> get props => [changeMap];
}

class RefreshSkillByIdEvent extends SkillDataEvent {
  final int skillId;

  RefreshSkillByIdEvent({@required this.skillId});

  @override
  List<Object> get props => [skillId];
}
