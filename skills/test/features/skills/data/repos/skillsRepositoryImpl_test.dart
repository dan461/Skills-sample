import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skills/core/error/exceptions.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/data/datasources/skillsLocalDataSource.dart';
import 'package:skills/features/skills/data/datasources/skillsRemoteDataSource.dart';
import 'package:skills/features/skills/data/repos/skillsRepositoryImpl.dart';
import 'package:skills/core/network/networkInfo.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/data/models/skillModel.dart';
import 'package:dartz/dartz.dart';

class MockLocalDataSource extends Mock implements SkillsLocalDataSource {}

class MockRemoteDataSource extends Mock implements SkillsRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  SkillsRepositoryImpl repositoryImpl;
  MockNetworkInfo mockNetworkInfo;
  MockLocalDataSource mockLocalDataSource;
  MockRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = SkillsRepositoryImpl(
        localDataSource: mockLocalDataSource,
        remoteDataSource: mockRemoteDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenThrow((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenThrow((_) async => false);
      });

      body();
    });
  }

  group('getAllSkills', () {
    final SkillModel skillModel = SkillModel(name: 'test', source: 'testing');
    final List<SkillModel> skillModelList = [skillModel];
    final Skill tSkill = skillModel;

    test('returns a List of SkillModels', () async {
      when(mockLocalDataSource.getAllSkills())
          .thenAnswer((_) async => skillModelList);
      final result = await repositoryImpl.getAllSkills();
      verify(mockLocalDataSource.getAllSkills());
      expect(result, equals(Right(skillModelList)));
    });
  });

  group('getSkillById', () {
    final SkillModel skillModel = SkillModel(name: 'test', source: 'testing');
    final Skill tSkill = skillModel;

    setUp(() {});

    test('returns a specific SkillModel', () async {
      when(mockLocalDataSource.getSkillById(1))
          .thenAnswer((_) async => skillModel);
      final result = await repositoryImpl.getSkillById(1);

      verify(mockLocalDataSource.getSkillById(1));
      expect(result, equals(Right(tSkill)));
    });
  });

  group('insertNewSkill', () {
    final SkillModel skillModel = SkillModel(name: 'test', source: 'testing');
    final Skill tSkill = skillModel;

    setUp(() {});

    test('returns an ID after inserting a SkillModel', () async {
      when(mockLocalDataSource.insertNewSkill(tSkill))
          .thenAnswer((_) async => 1);
      final result = await repositoryImpl.insertNewSkill(tSkill);

      verify(mockLocalDataSource.insertNewSkill(tSkill));
      expect(result, equals(Right(1)));
    });
  });

  /* TODO only implementing to follow the course. No Remote source yet
  */

  group('downloadAllSkills', () {
    test('test for connection', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repositoryImpl.downloadAllSkills();
      verify(mockNetworkInfo.isConnected);
    });

    test(
        'should return failure when call to remote data source is unsuccessful',
        () async {
      // TODO remove this after adding else to downloadAllSkills to repo impl
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.downloadAllSkills())
          .thenThrow(ServerException());

      final result = await repositoryImpl.downloadAllSkills();

      verify(mockRemoteDataSource.downloadAllSkills());
      expect(result, equals(Left(ServerFailure())));
      verifyZeroInteractions(mockLocalDataSource);
    });
  });
}
