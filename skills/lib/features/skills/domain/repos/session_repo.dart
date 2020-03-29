import 'package:dartz/dartz.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/session.dart';

abstract class SessionRepository {
  Future<Either<Failure, Session>> getSessionById(int id);
  Future<Either<Failure, Session>> getSessionAndActivities(int id);
  Future<Either<Failure, Session>> insertNewSession(Session session);
  Future<Either<Failure, int>> updateSession(
      Map<String, dynamic> changeMap, int id);
  Future<Either<Failure, Session>> updateAndRefreshSession(
      Map<String, dynamic> changeMap, int id);
  Future<Either<Failure, int>> deleteSessionById(int id);
  Future<Either<Failure, List<Session>>> getSessionsInMonth(DateTime month);
  Future<Either<Failure, List<Session>>> getSessionsInDateRange(
      DateTime from, DateTime to);
  Future<Either<Failure, List<Map>>> getSessionMapsInDateRange(
      DateTime from, DateTime to);
  Future<Either<Failure, int>> completeSessionAndEvents(
      int sessionId, DateTime date);
}
