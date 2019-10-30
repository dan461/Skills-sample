import 'package:equatable/equatable.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/repos/skill_repo.dart';
import 'package:dartz/dartz.dart';

class GetAllSkills extends UseCase<List<Skill>, NoParams> {
  final SkillRepository repo;

  GetAllSkills(this.repo);

  Future<Either<Failure, List<Skill>>> call(NoParams noParams) async {
    return await repo.getAllSkills();
  }
}
