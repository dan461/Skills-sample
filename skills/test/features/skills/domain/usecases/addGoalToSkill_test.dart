import 'package:skills/features/skills/domain/usecases/addGoalToSkill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

import '../../mockClasses.dart';
import 'insertNewGoal_test.dart';

void main() {
  AddGoalToSkill sut;
  MockGoalRepo mockGoalRepo;

  setUp(() {
    mockGoalRepo = MockGoalRepo();
    sut = AddGoalToSkill(mockGoalRepo);
  });

  final newId = 1;

  test('should add a goal to a skill and return a new id for the join row',
      () async {
    when(mockGoalRepo.addGoalToSkill(1, 1, 'goal'))
        .thenAnswer((_) async => Right(newId));
    final result = await sut(AddGoalToSkillParams(skillId: 1, goalId: 1, goalText: 'goal'));
    expect(result, Right(newId));
    verify(mockGoalRepo.addGoalToSkill(1, 1, 'goal'));
    verifyNoMoreInteractions(mockGoalRepo);
  });
}
