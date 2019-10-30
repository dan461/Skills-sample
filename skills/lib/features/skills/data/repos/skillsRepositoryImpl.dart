import 'package:flutter/cupertino.dart';
import 'package:skills/features/skills/domain/repos/skill_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/data/datasources/skillsLocalDataSource.dart';
import 'package:skills/core/network/networkInfo.dart';

class SkillsRepositoryImpl implements SkillRepository {
  final SkillsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SkillsRepositoryImpl({@required this.localDataSource, this.networkInfo});

  @override
  Future<Either<Failure, List<Skill>>> getAllSkills() async {
    return Right(await localDataSource.getAllSkills());
  }

  @override
  Future<Either<Failure, Skill>> getSkillById(int id) async {
    return Right(await localDataSource.getSkillById(id));
  }

  @override
  Future<Either<Failure, int>> insertNewSkill(Skill skill) {
    return null;
  }

  // TODO only added to follow course, no remote source yet
  @override
  Future<Either<Failure, List<Skill>>> downloadAllSkills() {
    networkInfo.isConnected;
    return null;
  }
}
