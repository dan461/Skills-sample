import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/repos/skill_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

class InsertNewSkill extends UseCase<Skill, SkillInsertOrUpdateParams> {
  final SkillRepository repo;

  InsertNewSkill(this.repo);

  Future<Either<Failure, Skill>> call(SkillInsertOrUpdateParams params) async {
    return await repo.insertNewSkill(params.skill);
  }
}
