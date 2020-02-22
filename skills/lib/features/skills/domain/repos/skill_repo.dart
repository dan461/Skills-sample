import 'package:dartz/dartz.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';

// A contract for the repository

abstract class SkillRepository {
  Future<Either<Failure, List<Skill>>> getAllSkills();
  Future<Either<Failure, Skill>> getSkillById(int id);
  Future<Either<Failure, Map<String, dynamic>>> getSkillGoalMapById(int id);
  // Future<Either<Failure, int>> insertNewSkill(Skill skill);
  Future<Either<Failure, Skill>> insertNewSkill(Skill skill);
  Future<Either<Failure, int>> deleteSkillWithId(int skillId);
  Future<Either<Failure, int>> updateSkill(Skill skill);
  // Future<Either<Failure, int>> updateSkill(int skillId, Map changeMap);

  // Future<Either<Failure, List<Skill>>> downloadAllSkills();
}
