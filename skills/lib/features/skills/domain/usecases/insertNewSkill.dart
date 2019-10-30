import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/repos/skill_repo.dart';
import 'package:dartz/dartz.dart';

class InsertNewSkill extends UseCase<int, Params> {
  final SkillRepository repo;

  InsertNewSkill(this.repo);

  Future<Either<Failure, int>> call(Params params) async {
    return await repo.insertNewSkill(params.skill);
  }
}

class Params extends Equatable {
  final Skill skill;

  Params({@required this.skill}) : super([skill]);
}
