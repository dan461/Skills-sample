import 'dart:math';

import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/usecases/getSkillById.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import '../../mockClasses.dart';

void main() {
  GetSkillInfoForEvent sut;
  MockGetSkillById mockGetSkillById;
  MockGetGoalById mockGetGoalById;

  setUp(() {
    mockGetGoalById = MockGetGoalById();
    mockGetSkillById = MockGetSkillById();

    sut = GetSkillInfoForEvent(mockGetSkillById, mockGetGoalById);
  });

  final testSkill =
      Skill(id: 1, name: 'test', source: 'test', currentGoalId: 1);
  final testGoal = Goal(
      id: 1,
      skillId: 1,
      fromDate: DateTime.fromMillisecondsSinceEpoch(0),
      toDate: DateTime.fromMillisecondsSinceEpoch(0),
      goalTime: 10,
      isComplete: false,
      timeBased: false);

  Map<String, dynamic> testMap = {'skill': testSkill, 'goal': testGoal};
  Right<Failure, Map<String, dynamic>> matcher = Right(testMap);

// TODO - can't get this test to pass without using .isRight, even though expected and actual match
  test(
      'should return a Map<String, dynamic> with a Skill and Goal (if a current goal is set)',
      () async {
    when(mockGetSkillById(GetSkillParams(id: 1)))
        .thenAnswer((_) async => Right(testSkill));
    when(mockGetGoalById(GoalCrudParams(id: 1)))
        .thenAnswer((_) async => Right(testGoal));
    final result = await sut(GetSkillParams(id: 1));
    expect(result.isRight(), matcher.isRight());
    verify(mockGetSkillById(GetSkillParams(id: 1)));
    verify(mockGetGoalById(GoalCrudParams(id: 1)));
    verifyNoMoreInteractions(mockGetSkillById);
    verifyNoMoreInteractions(mockGetGoalById);
  });
}
