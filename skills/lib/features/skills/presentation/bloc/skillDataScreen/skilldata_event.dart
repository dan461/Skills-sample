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
