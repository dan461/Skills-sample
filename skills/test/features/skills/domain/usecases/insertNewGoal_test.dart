import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/repos/goal_repo.dart';
import 'package:skills/features/skills/domain/usecases/insertNewGoal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

class MockGoalRepo extends Mock implements GoalRepository {}

void main() {
  InsertNewGoal sut;
  MockGoalRepo mockGoalRepo;

  setUp(() {
    mockGoalRepo = MockGoalRepo();
    sut = InsertNewGoal(mockGoalRepo);
  });

  final testGoal = Goal(
      fromDate: DateTime.now().millisecondsSinceEpoch,
      toDate: DateTime.now().millisecondsSinceEpoch,
      isComplete: false,
      timeBased: true,
      timeRemaining: 0,
      goalTime: 0);

  final int newId = -1;

  test('should insert new goal and return goal id', () async {
    when(mockGoalRepo.insertNewGoal(testGoal))
        .thenAnswer((_) async => Right(newId));
    final result = await sut(GoalCrudParams(id: null, goal: testGoal));
    expect(result, Right(newId));
    verify(mockGoalRepo.insertNewGoal(testGoal));
    verifyNoMoreInteractions(mockGoalRepo);
  });
}
