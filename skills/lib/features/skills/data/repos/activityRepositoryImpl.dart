import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/data/datasources/skillsLocalDataSource.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/repos/activity_repo.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final SkillsLocalDataSource localDataSource;
  // final SkillsRemoteDataSource remoteDataSource;
  // final NetworkInfo networkInfo;

  ActivityRepositoryImpl({@required this.localDataSource});
  @override
  Future<Either<Failure, int>> deleteActivityById(int id) async {
    return Right(await localDataSource.deleteActivityById(id));
  }

  @override
  Future<Either<Failure, Activity>> getActivityById(int id) async {
    return Right(await localDataSource.getActivityById(id));
  }

  @override
  Future<Either<Failure, Activity>> insertNewActivity(Activity event) async {
    return Right(await localDataSource.insertNewActivity(event));
  }

  @override
  Future<Either<Failure, List<int>>> insertActivities(
      List<Activity> events, int newSessionId) async {
    return Right(await localDataSource.insertActivities(events, newSessionId));
  }

  @override
  Future<Either<Failure, int>> updateActivity(
      Map<String, dynamic> changeMap, eventId) async {
    return Right(await localDataSource.updateActivity(changeMap, eventId));
  }

  @override
  Future<Either<Failure, List<Activity>>> getActivitiesForSession(
      int sessionId) async {
    return Right(await localDataSource.getActivitiesForSession(sessionId));
  }

  @override
  Future<Either<Failure, List<Activity>>> getActivitiesWithSkillsForSession(
      int sessionId) async {
    return Right(
        await localDataSource.getActivitiesWithSkillsForSession(sessionId));
  }

  @override
  Future<Either<Failure, List<Activity>>> getCompletedActivitiesForSkill(
      int skillId) async {
    return Right(await localDataSource.getCompletedActivitiesForSkill(skillId));
  }

  // TODO - dead code?
  @override
  Future<Either<Failure, List<Map>>> getInfoForActivities(
      List<Activity> events) async {
    return Right(await localDataSource.getInfoForActivities(events));
  }

  @override
  Future<Either<Failure, List<Map>>> getActivityMapsForSession(
      int sessionId) async {
    return Right(await localDataSource.getActivityMapsForSession(sessionId));
  }
}
