import 'package:dartz/dartz.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';

abstract class GoalRepository {
  Future<Either<Failure, Goal>> getGoalById(int id);
  Future<Either<Failure, int>> insertNewGoal(Goal goal);
  Future<Either<Failure, int>> updateGoal(Goal goal);
  Future<Either<Failure, int>> deleteGoalWithId(int id);
}