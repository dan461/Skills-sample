import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/usecases/getAllSkills.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/core/usecase.dart';

import '../../mockClasses.dart';

void main() {
  GetAllSkills useCase;
  MockSkillsRepo mockSkillsRepo;

  setUp(() {
    mockSkillsRepo = MockSkillsRepo();
    useCase = GetAllSkills(mockSkillsRepo);
  });

  final testSkill = Skill(name: 'test', source: 'test');
  final List<Skill> skillsList = [testSkill];

  test(
    'should get all skills from the repo',
    () async {
      when(mockSkillsRepo.getAllSkills())
          .thenAnswer((_) async => Right(skillsList));
      final result = await useCase(NoParams());
      expect(result, Right(skillsList));
      verify(mockSkillsRepo.getAllSkills());
      verifyNoMoreInteractions(mockSkillsRepo);
    },
  );
}
