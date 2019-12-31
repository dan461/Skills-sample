import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/repos/goal_repo.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

class UpdateGoal extends UseCase<int, GoalCrudParams> {
  final GoalRepository repo;

  UpdateGoal(this.repo);

  Future<Either<Failure, int>> call(GoalCrudParams params) async {
    return await repo.updateGoal(params.goal);
  }
}
