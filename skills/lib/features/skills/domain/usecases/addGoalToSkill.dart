import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/repos/goal_repo.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

class AddGoalToSkill extends UseCase<int, AddGoalToSkillParams> {
  final GoalRepository repo;

  AddGoalToSkill(this.repo);

  @override
  Future<Either<Failure, int>> call(AddGoalToSkillParams params) async {
    return await repo.addGoalToSkill(
        params.skillId, params.goalId, params.goalText);
  }
}
