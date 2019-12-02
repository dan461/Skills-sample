import 'package:flutter/cupertino.dart';
import 'package:skills/core/error/exceptions.dart';
import 'package:skills/features/skills/data/datasources/skillsRemoteDataSource.dart';
import 'package:skills/features/skills/domain/repos/skill_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/data/datasources/skillsLocalDataSource.dart';
import 'package:skills/core/network/networkInfo.dart';

class SkillsRepositoryImpl implements SkillRepository {
  final SkillsLocalDataSource localDataSource;
  final SkillsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SkillsRepositoryImpl(
      {@required this.localDataSource,
      this.remoteDataSource,
      this.networkInfo});

  @override
  Future<Either<Failure, List<Skill>>> getAllSkills() async {
    return Right(await localDataSource.getAllSkills());
  }

  @override
  Future<Either<Failure, Skill>> getSkillById(int id) async {
    return Right(await localDataSource.getSkillById(id));
  }

  @override
  Future<Either<Failure, int>> insertNewSkill(Skill skill) async {
    return Right(await localDataSource.insertNewSkill(skill));
  }

  // @override
  // Future<Either<Failure, int>> updateSkill(Skill skill) async {

  //   return Right(await localDataSource.updateSkill(skill));
  // }

  @override
  Future<Either<Failure, int>> updateSkill(int skillId, Map changeMap) async {
    return Right(await localDataSource.updateSkill(skillId, changeMap));
  }

  // TODO only added to follow course, no remote source yet
  @override
  Future<Either<Failure, List<Skill>>> downloadAllSkills() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSkills = await remoteDataSource.downloadAllSkills();
        return Right(remoteSkills);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
  }
}
