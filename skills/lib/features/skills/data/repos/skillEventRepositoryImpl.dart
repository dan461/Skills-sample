import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/core/network/networkInfo.dart';
import 'package:skills/features/skills/data/datasources/skillsLocalDataSource.dart';
import 'package:skills/features/skills/data/datasources/skillsRemoteDataSource.dart';
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
  Future<Either<Failure, int>> updateEvent(SkillEvent event) async {
    return Right(await localDataSource.updateEvent(event));
  }
}
