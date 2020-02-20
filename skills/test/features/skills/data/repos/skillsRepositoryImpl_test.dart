import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skills/features/skills/data/repos/skillsRepositoryImpl.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/data/models/skillModel.dart';
import 'package:dartz/dartz.dart';

import '../../mockClasses.dart';

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

  // void runTestsOnline(Function body) {
  //   group('device is online', () {
  //     setUp(() {
  //       when(mockNetworkInfo.isConnected).thenThrow((_) async => true);
  //     });

  //     body();
  //   });
  // }

  // void runTestsOffline(Function body) {
  //   group('device is offline', () {
  //     setUp(() {
  //       when(mockNetworkInfo.isConnected).thenThrow((_) async => false);
  //     });

  //     body();
  //   });
  // }

  group('Skills CRUD tests', () {
    final SkillModel skillModel = SkillModel(
      name: 'test',
      source: 'testing',
      type: 'composition',
      startDate: DateTime.fromMillisecondsSinceEpoch(0),
    );
    final List<SkillModel> skillModelList = [skillModel];
    final Skill tSkill = skillModel;

    test('getAllSkills - returns a List of SkillModels', () async {
      when(mockLocalDataSource.getAllSkills())
          .thenAnswer((_) async => skillModelList);
      final result = await repositoryImpl.getAllSkills();
      verify(mockLocalDataSource.getAllSkills());
      expect(result, equals(Right(skillModelList)));
    });

    test('getSkillById - returns a specific SkillModel', () async {
      when(mockLocalDataSource.getSkillById(1))
          .thenAnswer((_) async => skillModel);
      final result = await repositoryImpl.getSkillById(1);

      verify(mockLocalDataSource.getSkillById(1));
      expect(result, equals(Right(tSkill)));
    });

    test(
        'insertNewSkill - returns a new Skill with an id after inserting a SkillModel',
        () async {
      Skill newSkill = Skill(
          skillId: 1,
          name: 'new',
          source: 'new',
          type: 'composition',
          startDate: DateTime.fromMillisecondsSinceEpoch(0),
          lastPracDate: DateTime.fromMillisecondsSinceEpoch(0));
      when(mockLocalDataSource.insertNewSkill(tSkill))
          .thenAnswer((_) async => newSkill);
      final result = await repositoryImpl.insertNewSkill(tSkill);

      verify(mockLocalDataSource.insertNewSkill(tSkill));
      expect(result, equals(Right(newSkill)));
    });

    test(
        'deleteSkillWithId - returns int of number of row changes, should be 1',
        () async {
      when(mockLocalDataSource.deleteSkillWithId(1)).thenAnswer((_) async => 1);
      final result = await repositoryImpl.deleteSkillWithId(1);
      verify(mockLocalDataSource.deleteSkillWithId(1));
      expect(result, equals(Right(1)));
    });

    test('updateSkill - returns an int for number of changes to Skill',
        () async {
      when(mockLocalDataSource.updateSkill(tSkill)).thenAnswer((_) async => 1);
      final result = await repositoryImpl.updateSkill(tSkill);
      verify(mockLocalDataSource.updateSkill(tSkill));
      expect(result, equals(Right(1)));
    });
  });

  // group('downloadAllSkills', () {
  //   test('test for connection', () async {
  //     when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
  //     repositoryImpl.downloadAllSkills();
  //     verify(mockNetworkInfo.isConnected);
  //   });

  //   test(
  //       'should return failure when call to remote data source is unsuccessful',
  //       () async {
  //     // TODO remove this after adding else to downloadAllSkills to repo impl
  //     when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
  //     when(mockRemoteDataSource.downloadAllSkills())
  //         .thenThrow(ServerException());

  //     final result = await repositoryImpl.downloadAllSkills();

  //     verify(mockRemoteDataSource.downloadAllSkills());
  //     expect(result, equals(Left(ServerFailure())));
  //     verifyZeroInteractions(mockLocalDataSource);
  //   });
  // });
}
