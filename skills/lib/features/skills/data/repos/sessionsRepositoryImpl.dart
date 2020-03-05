import 'package:dartz/dartz.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/data/datasources/skillsLocalDataSource.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/repos/session_repo.dart';

class SessionsRepositoryImpl extends SessionRepository {
  final SkillsLocalDataSource localDataSource;

  SessionsRepositoryImpl({this.localDataSource});

  @override
  Future<Either<Failure, int>> deleteSessionById(int id) async {
    return Right(await localDataSource.deleteSessionWithId(id));
  }

  @override
  Future<Either<Failure, Session>> getSessionById(int id) async {
    return Right(await localDataSource.getSessionById(id));
  }

  @override
  Future<Either<Failure, Session>> insertNewSession(Session session) async {
    return Right(await localDataSource.insertNewSession(session));
  }

  @override
  Future<Either<Failure, int>> updateSession(
      Map<String, dynamic> changeMap, int id) async {
    return Right(await localDataSource.updateSession(changeMap, id));
  }

  @override
  Future<Either<Failure, Session>> updateAndRefreshSession(
      Map<String, dynamic> changeMap, int id) async {
    return Right(await localDataSource.updateAndRefreshSession(changeMap, id));
  }

  @override
  Future<Either<Failure, List<Session>>> getSessionsInMonth(
      DateTime month) async {
    return Right(await localDataSource.getSessionsInMonth(month));
  }

  @override
  Future<Either<Failure, List<Session>>> getSessionsInDateRange(
      DateTime from, DateTime to) async {
    return Right(await localDataSource.getSessionsInDateRange(from, to));
  }

  @override
  Future<Either<Failure, List<Map>>> getSessionMapsInDateRange(
      DateTime from, DateTime to) async {
    return Right(await localDataSource.getSessionMapsInDateRange(from, to));
  }

  @override
  Future<Either<Failure, int>> completeSessionAndEvents(
      int sessionId, DateTime date) async {
    return Right(
        await localDataSource.completeSessionAndEvents(sessionId, date));
  }
}
