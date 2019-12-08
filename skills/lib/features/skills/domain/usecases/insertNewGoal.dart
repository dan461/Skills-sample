import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/repos/goal_repo.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

class InsertNewGoal extends UseCase<Goal, GoalCrudParams> {
  final GoalRepository repo;

  InsertNewGoal(this.repo);

  Future<Either<Failure, Goal>> call(GoalCrudParams params) async {
    return await repo.insertNewGoal(params.goal);
  }
}
