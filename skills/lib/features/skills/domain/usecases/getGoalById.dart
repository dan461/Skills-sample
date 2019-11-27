import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/repos/goal_repo.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

class GetGoalById extends UseCase<Goal, GoalCrudParams> {
  final GoalRepository repo;

  GetGoalById(this.repo);

  Future<Either<Failure, Goal>> call(GoalCrudParams params) async {
    return await repo.getGoalById(params.id);
  }
}


