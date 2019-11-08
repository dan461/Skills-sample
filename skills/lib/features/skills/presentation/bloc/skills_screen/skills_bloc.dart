import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/repos/skill_repo.dart';
import 'package:skills/features/skills/domain/usecases/getAllSkills.dart';
import 'package:skills/features/skills/domain/usecases/insertNewSkill.dart';
import './bloc.dart';

const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String SERVER_FAILURE_MESSAGE = 'Server Failure';

class SkillsBloc extends Bloc<SkillsEvent, SkillsState> {

  // UseCases
  final GetAllSkills getAllSkills;
  final InsertNewSkill insertNewSkill;

  SkillsBloc({
    // @required this.repository,
    @required this.getAllSkills,
    @required this.insertNewSkill
    });

  @override
  SkillsState get initialState => InitialSkillsState();

  @override
  Stream<SkillsState> mapEventToState(
    SkillsEvent event,
  ) async* {
    if (event is GetAllSkillsEvent){
      yield AllSkillsLoading();
      final failureOrSkills = await getAllSkills(NoParams());
      yield* _eitherSkillsLoadedOrErrorState(failureOrSkills);
    }  
  }

  Stream<SkillsState> _eitherSkillsLoadedOrErrorState(Either<Failure, List<Skill>> failureOrSkills) async* {
    yield failureOrSkills.fold(
        (failure) => AllSkillsError(_mapFailureToMessage(failure)), 
        (skillsList) => AllSkillsLoaded(skillsList),
        );
  }

  String _mapFailureToMessage(Failure failure){
    switch (failure.runtimeType){
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
