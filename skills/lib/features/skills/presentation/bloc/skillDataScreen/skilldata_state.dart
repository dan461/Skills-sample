part of 'skilldata_bloc.dart';

abstract class SkillDataState extends Equatable {
  const SkillDataState();
}

class SkillDataInitialState extends SkillDataState {
  @override
  List<Object> get props => [];
}

class SkillDataGettingEventsState extends SkillDataState {
  @override
  List<Object> get props => [];
}

class SkillDataEventsLoadedState extends SkillDataState {
  @override
  List<Object> get props => [];
}

class SkillDataErrorState extends SkillDataState {
  final String message;

  SkillDataErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class UpdatedExistingSkillState extends SkillDataState {
  @override
  List<Object> get props => [];
}

class SkillRefreshedState extends SkillDataState {
  @override
  List<Object> get props => [];
}
