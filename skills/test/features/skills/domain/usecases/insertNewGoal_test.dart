import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/repos/goal_repo.dart';
import 'package:skills/features/skills/domain/usecases/insertNewGoal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

import '../../mockClasses.dart';



void main() {
  InsertNewGoal sut;
  MockGoalRepo mockGoalRepo;

  setUp(() {
    mockGoalRepo = MockGoalRepo();
    sut = InsertNewGoal(mockGoalRepo);
  });

  final testGoal = Goal(
      skillId: 1,
      fromDate: DateTime.now(),
      toDate: DateTime.now(),
      isComplete: false,
      timeBased: true,
      timeRemaining: 0,
      goalTime: 0);

  test('should insert new goal and return goal id', () async {
    Goal newGoal = Goal(
        skillId: 1,
        fromDate: DateTime.now(),
        toDate: DateTime.now(),
        isComplete: false,
        timeBased: false,
        timeRemaining: 0,
        goalTime: 1);

    when(mockGoalRepo.insertNewGoal(testGoal))
        .thenAnswer((_) async => Right(newGoal));
    final result = await sut(GoalCrudParams(id: null, goal: testGoal));
    expect(result, Right(newGoal));
    verify(mockGoalRepo.insertNewGoal(testGoal));
    verifyNoMoreInteractions(mockGoalRepo);
  });
}
