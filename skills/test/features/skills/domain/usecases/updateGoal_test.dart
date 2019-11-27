import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/usecases/updateGoal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

import 'insertNewGoal_test.dart';

void main() {
  UpdateGoal sut;
  MockGoalRepo mockGoalRepo;

  setUp(() {
    mockGoalRepo = MockGoalRepo();
    sut = UpdateGoal(mockGoalRepo);
  });

  final testGoal = Goal(
      fromDate: DateTime.now().millisecondsSinceEpoch,
      toDate: DateTime.now().millisecondsSinceEpoch,
      isComplete: false,
      timeBased: true,
      timeRemaining: 0,
      goalTime: 0);

  final int changesInt = 1;

  test('should update goal and return int for number of changes made',
      () async {
    when(mockGoalRepo.updateGoal(testGoal))
        .thenAnswer((_) async => Right(changesInt));
    final result = await sut(GoalCrudParams(id: null, goal: testGoal));
    expect(result, Right(changesInt));
    verify(mockGoalRepo.updateGoal(testGoal));
    verifyNoMoreInteractions(mockGoalRepo);
  });
}
