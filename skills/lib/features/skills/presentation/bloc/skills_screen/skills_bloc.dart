import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/usecases/skillUseCases.dart';
import './bloc.dart';

enum SkillSortOption { name, source, lastPracDate }

class SkillsBloc extends Bloc<SkillsEvent, SkillsState> {
  List<Skill> skills;
  // UseCases
  final GetAllSkills getAllSkills;

  SkillsBloc({@required this.getAllSkills});

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
    }
    skills.sort(comparator);
  }

  @override
  SkillsState get initialState => InitialSkillsState();

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
