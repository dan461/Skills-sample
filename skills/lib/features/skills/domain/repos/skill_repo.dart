import 'package:dartz/dartz.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';

abstract class SkillRepository {
  Future<Either<Failure, List<Skill>>> getAllSkills();
  Future<Either<Failure, Skill>> getSkillById(int id);
  Future<Either<Failure, int>> insertNewSkill(Skill skill);
  // TODO only added to follow course, no remote source yet
  Future<Either<Failure, List<Skill>>> downloadAllSkills();
}
