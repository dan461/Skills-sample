import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skills/features/skills/data/datasources/skillsLocalDataSource.dart';
import 'package:skills/features/skills/data/datasources/skillsRemoteDataSource.dart';
import 'package:skills/features/skills/data/repos/goalsRepositoryImpl.dart';
import 'package:skills/core/network/networkInfo.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/data/models/goalModel.dart';
import 'package:dartz/dartz.dart';

class MockLocalDataSource extends Mock implements SkillsLocalDataSource {}

class MockRemoteDataSource extends Mock implements SkillsRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  GoalsRepositoryImpl sut_goalRepoImpl;
  MockNetworkInfo mockNetworkInfo;
  MockLocalDataSource mockLocalDataSource;
  MockRemoteDataSource mockRemoteDataSource;
  GoalModel testGoalModel;
  Goal testGoal;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    testGoalModel = GoalModel(
        id: 1,
        skillId: 1,
        fromDate: DateTime.fromMillisecondsSinceEpoch(0),
        toDate: DateTime.fromMillisecondsSinceEpoch(0),
        isComplete: false,
        timeBased: true,
        goalTime: 60,
        timeRemaining: 60);
    testGoal = testGoalModel;

    sut_goalRepoImpl = GoalsRepositoryImpl(
        localDataSource: mockLocalDataSource,
        remoteDataSource: mockRemoteDataSource,
        networkInfo: mockNetworkInfo);
  });

  group('getGoalById', () {
    test('returns a specific GoalModel', () async {
      when(mockLocalDataSource.getGoalById(1))
          .thenAnswer((_) async => testGoalModel);
      final result = await sut_goalRepoImpl.getGoalById(1);
      verify(mockLocalDataSource.getGoalById(1));
      expect(result, equals(Right(testGoal)));
    });
  });

  group('insertNewGoal', () {
    Goal newGoal = testGoalModel;
    test('returns an ID after inserting a GoalModel', () async {
      when(mockLocalDataSource.insertNewGoal(testGoal))
          .thenAnswer((_) async => newGoal);
      final result = await sut_goalRepoImpl.insertNewGoal(testGoal);
      verify(mockLocalDataSource.insertNewGoal(testGoal));
      expect(result, equals(Right(newGoal)));
    });
  });

  group('updateGoal', () {
    test('returns an integer after updating a GoalModel', () async {
      when(mockLocalDataSource.updateGoal(testGoal)).thenAnswer((_) async => 1);
      final result = await sut_goalRepoImpl.updateGoal(testGoal);
      verify(mockLocalDataSource.updateGoal(testGoal));
      expect(result, equals(Right(1)));
    });
  });

  group('deleteGoal', () {
    test('returns an integer after deleting a Goal', () async {
      when(mockLocalDataSource.deleteGoalWithId(1)).thenAnswer((_) async => 1);
      final result = await sut_goalRepoImpl.deleteGoalWithId(1);
      verify(mockLocalDataSource.deleteGoalWithId(1));
      expect(result, equals(Right(1)));
    });
  });

  group('add goal to skill', () {
    test('testing adding a goal to a skill', () async {
      when(mockLocalDataSource.addGoalToSkill(1, 1, 'goal'))
          .thenAnswer((_) async => 1);
      final result = await sut_goalRepoImpl.addGoalToSkill(1, 1, 'goal');
      verify(mockLocalDataSource.addGoalToSkill(1, 1, 'goal'));
      expect(result, equals(Right(1)));
    });
  });
}
