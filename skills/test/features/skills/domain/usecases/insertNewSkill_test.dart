import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/usecases/insertNewSkill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
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
    'should insert new skill and return the new skill',
    () async {
      Skill newSkill = Skill(name: 'new', source: 'new');
      when(mockSkillsRepo.insertNewSkill(testSkill))
          .thenAnswer((_) async => Right(newSkill));
      final result = await useCase(SkillInsertOrUpdateParams(skill: testSkill));
      expect(result, Right(newSkill));
      verify(mockSkillsRepo.insertNewSkill(testSkill));
      verifyNoMoreInteractions(mockSkillsRepo);
    },
  );
}
