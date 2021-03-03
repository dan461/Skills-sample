import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/usecases/skillUseCases.dart';
import './bloc.dart';

enum SkillSortOption {
  name,
  source,
  lastPracDate,
  instrument,
  priority,
  proficiency,
}

class SkillsBloc extends Bloc<SkillsEvent, SkillsState> {
  List<Skill> skills;
  // UseCases
  final GetAllSkills getAllSkills;

  SkillsBloc({@required this.getAllSkills}) : super(InitialSkillsState());

  void ascDescTapped() {
    skills = List<Skill>.from(skills.reversed);
  }

  void sortOptionPicked(SkillSortOption choice) {
    Function comparator;
    switch (choice) {
      case SkillSortOption.name:
        comparator = (Skill a, Skill b) => a.name.compareTo(b.name);
        break;
      case SkillSortOption.source:
        comparator = (Skill a, Skill b) => a.source.compareTo(b.source);
        break;
      case SkillSortOption.lastPracDate:
        comparator =
            (Skill a, Skill b) => a.lastPracDate.compareTo(b.lastPracDate);
        break;
      case SkillSortOption.instrument:
        comparator = (Skill a, Skill b) => a.instrument.compareTo(b.instrument);
        break;
      case SkillSortOption.priority:
        comparator = (Skill a, Skill b) => a.priority.compareTo(b.priority);
        break;
      case SkillSortOption.proficiency:
        comparator =
            (Skill a, Skill b) => a.proficiency.compareTo(b.proficiency);
        break;
    }
    skills.sort(comparator);
  }

  @override
  Stream<SkillsState> mapEventToState(
    SkillsEvent event,
  ) async* {
    if (event is GetAllSkillsEvent) {
      yield AllSkillsLoading();
      final failureOrSkills = await getAllSkills(NoParams());
      yield failureOrSkills.fold(
        (failure) => AllSkillsError(_mapFailureToMessage(failure)),
        (skillsList) {
          skills = skillsList;
          return AllSkillsLoaded(skillsList);
        },
      );
    }
  }

  // Stream<SkillsState> _eitherSkillsLoadedOrErrorState(
  //     Either<Failure, List<Skill>> failureOrSkills) async* {
  //   yield failureOrSkills.fold(
  //     (failure) => AllSkillsError(_mapFailureToMessage(failure)),
  //     (skillsList) => AllSkillsLoaded(skillsList),
  //   );
  // }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
