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
  Future<Either<Failure, int>> updateSession(Map<String, dynamic> changeMap, int id) async {
    return Right(await localDataSource.updateSession(changeMap, id));
  }

  @override
  Future<Either<Failure, List<Session>>> getSessionsInMonth(DateTime month) async {
    return Right(await localDataSource.getSessionsInMonth(month));
  }
}
