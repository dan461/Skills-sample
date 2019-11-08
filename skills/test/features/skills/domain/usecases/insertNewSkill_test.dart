import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/usecases/insertNewSkill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'getAllSkills_test.dart';

void main() {
  InsertNewSkill useCase;
  MockSkillsRepo mockSkillsRepo;

  setUp(() {
    mockSkillsRepo = MockSkillsRepo();
    useCase = InsertNewSkill(mockSkillsRepo);
  });

  final testSkill = Skill(name: 'test', source: 'test');
  final int newId = -1;

  test(
    'should insert new skill and return the skill id',
    () async {
      when(mockSkillsRepo.insertNewSkill(testSkill))
          .thenAnswer((_) async => Right(newId));
      final result = await useCase(InsertParams(skill: testSkill));
      expect(result, Right(newId));
      verify(mockSkillsRepo.insertNewSkill(testSkill));
      verifyNoMoreInteractions(mockSkillsRepo);
    },
  );
}
