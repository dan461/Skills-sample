import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/usecases/getGoalById.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

import '../../mockClasses.dart';

void main() {
  GetGoalById sut;
  MockGoalRepo mockGoalRepo;

  setUp(() {
    mockGoalRepo = MockGoalRepo();
    sut = GetGoalById(mockGoalRepo);
  });

  final testGoal = Goal(
      skillId: 1,
      fromDate: DateTime.now().millisecondsSinceEpoch,
      toDate: DateTime.now().millisecondsSinceEpoch,
      isComplete: false,
      timeBased: true,
      timeRemaining: 0,
      goalTime: 0);

  test('should insert new Goal and return goal id', () async {
    when(mockGoalRepo.getGoalById(any))
        .thenAnswer((_) async => Right(testGoal));
    final result = await sut(GoalCrudParams(id: 1, goal: null));
    expect(result, Right(testGoal));
    verify(mockGoalRepo.getGoalById(1));
    verifyNoMoreInteractions(mockGoalRepo);
  });
}
