import 'package:flutter/cupertino.dart';
import 'package:skills/features/skills/data/datasources/skillsRemoteDataSource.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/repos/goal_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/data/datasources/skillsLocalDataSource.dart';
import 'package:skills/core/network/networkInfo.dart';

class GoalsRepositoryImpl implements GoalRepository {
  final SkillsLocalDataSource localDataSource;
  final SkillsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  GoalsRepositoryImpl(
      {@required this.localDataSource,
      this.remoteDataSource,
      this.networkInfo});

  @override
  Future<Either<Failure, int>> deleteGoalWithId(int id) async {
    return Right(await localDataSource.deleteGoalWithId(id));
  }

  @override
  Future<Either<Failure, Goal>> getGoalById(int id) async {
    return Right(await localDataSource.getGoalById(id));
  }

  @override
  Future<Either<Failure, int>> insertNewGoal(Goal goal) async {
    return Right(await localDataSource.insertNewGoal(goal));
  }

  @override
  Future<Either<Failure, int>> updateGoal(Goal goal) async {
    return Right(await localDataSource.updateGoal(goal));
  }

  @override
  Future<Either<Failure, int>> addGoalToSkill(int skillId, int goalId, String goalText) async {
    return Right(await localDataSource.addGoalToSkill(skillId, goalId, goalText));
  }
}
