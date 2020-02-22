import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/repos/skill_repo.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

class DeleteSkillWithId extends UseCase<int, SkillDeleteParams> {
  final SkillRepository repo;

  DeleteSkillWithId(this.repo);

  @override
  Future<Either<Failure, int>> call(SkillDeleteParams params) async {
    return await repo.deleteSkillWithId(params.skillId);
  }
}

class UpdateSkill extends UseCase<int, SkillInsertOrUpdateParams> {
  final SkillRepository repo;

  UpdateSkill(this.repo);

  @override
  Future<Either<Failure, int>> call(SkillInsertOrUpdateParams params) async {
    return await repo.updateSkill(params.skill);
  }
}

class InsertNewSkill extends UseCase<Skill, SkillInsertOrUpdateParams> {
  final SkillRepository repo;

  InsertNewSkill(this.repo);

  Future<Either<Failure, Skill>> call(SkillInsertOrUpdateParams params) async {
    return await repo.insertNewSkill(params.skill);
  }
}

class GetAllSkills extends UseCase<List<Skill>, NoParams> {
  final SkillRepository repo;

  GetAllSkills(this.repo);

  Future<Either<Failure, List<Skill>>> call(NoParams noParams) async {
    return await repo.getAllSkills();
  }
}

// class GetAllSkillsInfoMaps
//     extends UseCase<List<Map<String, dynamic>>, NoParams> {
//   final SkillRepository repo;

//   GetAllSkillsInfoMaps(this.repo);
//   @override
//   Future<Either<Failure, List<Map<String, dynamic>>>> call(
//       NoParams params) async {
//     return await repo.getAllSkillsInfo();
//   }
// }

class GetSkillById extends UseCase<Skill, GetSkillParams> {
  final SkillRepository repo;

  GetSkillById(this.repo);

  Future<Either<Failure, Skill>> call(GetSkillParams params) async {
    return await repo.getSkillById(params.id);
  }
}

class GetSkillGoalMapById
    extends UseCase<Map<String, dynamic>, GetSkillParams> {
  final SkillRepository repo;

  GetSkillGoalMapById(this.repo);
  @override
  Future<Either<Failure, Map<String, dynamic>>> call(GetSkillParams params) {
    return repo.getSkillGoalMapById(params.id);
  }
}
