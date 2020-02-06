import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/data/datasources/skillsLocalDataSource.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/repos/skillEvent_repo.dart';

class SkillEventRepositoryImpl implements SkillEventRepository {
  final SkillsLocalDataSource localDataSource;
  // final SkillsRemoteDataSource remoteDataSource;
  // final NetworkInfo networkInfo;

  SkillEventRepositoryImpl({@required this.localDataSource});
  @override
  Future<Either<Failure, int>> deleteEventById(int id) async {
    return Right(await localDataSource.deleteEventById(id));
  }

  @override
  Future<Either<Failure, SkillEvent>> getEventById(int id) async {
    return Right(await localDataSource.getEventById(id));
  }

  @override
  Future<Either<Failure, SkillEvent>> insertNewEvent(SkillEvent event) async {
    return Right(await localDataSource.insertNewEvent(event));
  }

  @override
  Future<Either<Failure, List<int>>> insertEvents(
      List<SkillEvent> events, int newSessionId) async {
    return Right(await localDataSource.insertEvents(events, newSessionId));
  }

  @override
  Future<Either<Failure, int>> updateEvent(Map<String, dynamic> changeMap, eventId) async {
    return Right(await localDataSource.updateEvent(changeMap, eventId));
  }

  @override
  Future<Either<Failure, List<SkillEvent>>> getEventsForSession(
      int sessionId) async {
    return Right(await localDataSource.getEventsForSession(sessionId));
  }

  // TODO - dead code?
  @override
  Future<Either<Failure, List<Map>>> getInfoForEvents(
      List<SkillEvent> events) async {
    return Right(await localDataSource.getInfoForEvents(events));
  }

  @override
  Future<Either<Failure, List<Map>>> getEventMapsForSession(int sessionId) async {
    return Right(await localDataSource.getEventMapsForSession(sessionId));
  }
}
