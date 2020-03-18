import 'package:dartz/dartz.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';

abstract class ActivityRepository {
  Future<Either<Failure, Activity>> insertNewActivity(Activity event);
  Future<Either<Failure, List<int>>> insertActivities(
      List<Activity> events, int newSessionId);
  Future<Either<Failure, Activity>> getActivityById(int id);
  Future<Either<Failure, int>> updateActivity(
      Map<String, dynamic> changeMap, eventId);
  Future<Either<Failure, int>> deleteActivityById(int id);
  Future<Either<Failure, List<Activity>>> getActivitiesForSession(int sessionId);
  Future<Either<Failure, List<Activity>>> getCompletedActivitiesForSkill(
      int skillId);
  Future<Either<Failure, List<Map>>> getInfoForActivities(
      List<Activity> events);
  Future<Either<Failure, List<Map>>> getActivityMapsForSession(int sessionId);
}
