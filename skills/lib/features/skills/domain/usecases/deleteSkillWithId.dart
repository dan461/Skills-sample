import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:dartz/dartz.dart';
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