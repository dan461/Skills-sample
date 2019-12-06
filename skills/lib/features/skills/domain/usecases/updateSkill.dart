import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/repos/skill_repo.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

class UpdateSkill extends UseCase<int, SkillInsertOrUpdateParams> {
  final SkillRepository repo;

  UpdateSkill(this.repo);

  @override
  Future<Either<Failure, int>> call(SkillInsertOrUpdateParams params) async {
    return await repo.updateSkill(params.skill);
  }
}
