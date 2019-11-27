import 'package:skills/features/skills/domain/usecases/deleteGoalWithId.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

import 'insertNewGoal_test.dart';

void main() {
  DeleteGoalWithId sut;
  MockGoalRepo mockGoalRepo;

  setUp(() {
    mockGoalRepo = MockGoalRepo();
    sut = DeleteGoalWithId(mockGoalRepo);
  });

  test('should delete a goal and return zero', () async {
    when(mockGoalRepo.deleteGoal(0)).thenAnswer((_) async => Right(0));
    final result = await sut(GoalCrudParams(id: 0, goal: null));
    expect(result, Right(0));
    verify(mockGoalRepo.deleteGoal(0));
    verifyNoMoreInteractions(mockGoalRepo);
  });
}
