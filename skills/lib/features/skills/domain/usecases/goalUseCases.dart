import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
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

class DeleteGoalWithId extends UseCase<int, GoalCrudParams> {
  final GoalRepository repo;

  DeleteGoalWithId(this.repo);

  Future<Either<Failure, int>> call(GoalCrudParams params) async {
    return await repo.deleteGoalWithId(params.id);
  }
}

class GetGoalById extends UseCase<Goal, GoalCrudParams> {
  final GoalRepository repo;

  GetGoalById(this.repo);

  Future<Either<Failure, Goal>> call(GoalCrudParams params) async {
    return await repo.getGoalById(params.id);
  }
}

class InsertNewGoal extends UseCase<Goal, GoalCrudParams> {
  final GoalRepository repo;

  InsertNewGoal(this.repo);

  Future<Either<Failure, Goal>> call(GoalCrudParams params) async {
    return await repo.insertNewGoal(params.goal);
  }
}

class UpdateGoal extends UseCase<int, GoalCrudParams> {
  final GoalRepository repo;

  UpdateGoal(this.repo);

  Future<Either<Failure, int>> call(GoalCrudParams params) async {
    return await repo.updateGoal(params.goal);
  }
}
