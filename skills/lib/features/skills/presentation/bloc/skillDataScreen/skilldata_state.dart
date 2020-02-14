part of 'skilldata_bloc.dart';

abstract class SkillDataState extends Equatable {
  const SkillDataState();
}

class SkillDataInitial extends SkillDataState {
  @override
  List<Object> get props => [];
}

class SkillDataEventsLoadedState extends SkillDataState {
  @override
  List<Object> get props => [];
}
