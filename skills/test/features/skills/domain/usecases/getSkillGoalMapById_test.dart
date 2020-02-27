import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/usecases/skillUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import '../../mockClasses.dart';

void main() {
  GetSkillGoalMapById sut;
  MockSkillsRepo mockSkillsRepo;

  setUp(() {
    mockSkillsRepo = MockSkillsRepo();
    sut = GetSkillGoalMapById(mockSkillsRepo);
  });

  final testSkill = Skill(
    skillId: 1,
    name: 'test',
    source: 'test',
    type: 'composition',
    startDate: DateTime.fromMillisecondsSinceEpoch(0),
  );

  final testGoal = Goal(
      skillId: 1,
      goalTime: 1,
      fromDate: DateTime.fromMillisecondsSinceEpoch(0),
      toDate: DateTime.fromMillisecondsSinceEpoch(0),
      isComplete: false,
      timeBased: true);

  final testMap = {'skill': testSkill, 'goal': testGoal};

  test('should return a Map with a Skill and Goal', () async {
    when(mockSkillsRepo.getSkillGoalMapById(1))
        .thenAnswer((_) async => Right(testMap));
    final result = await sut(GetSkillParams(id: 1));
    expect(result, Right(testMap));
    verify(mockSkillsRepo.getSkillGoalMapById(1));
    verifyNoMoreInteractions(mockSkillsRepo);
  });
}
