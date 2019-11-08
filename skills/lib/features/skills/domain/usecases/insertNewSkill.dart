import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/repos/skill_repo.dart';
import 'package:dartz/dartz.dart';

class InsertNewSkill extends UseCase<int, InsertParams> {
  final SkillRepository repo;

  InsertNewSkill(this.repo);

  Future<Either<Failure, int>> call(InsertParams params) async {
    return await repo.insertNewSkill(params.skill);
  }
}

class InsertParams extends Params {
  final Skill skill;

  InsertParams({@required this.skill}) : super();

  @override
  // TODO: implement props
  List<Object> get props => [skill];
}
