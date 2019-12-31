import 'package:flutter/cupertino.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/repos/skill_repo.dart';
import 'package:dartz/dartz.dart';

class GetSkillById extends UseCase<Skill, GetSkillParams> {
  final SkillRepository repo;

  GetSkillById(this.repo);

  Future<Either<Failure, Skill>> call(GetSkillParams params) async {
    return await repo.getSkillById(params.id);
  }
}

class GetSkillParams extends Params {
  final int id;

  GetSkillParams({@required this.id}) : super();

  @override
  List<Object> get props => [id];
}
