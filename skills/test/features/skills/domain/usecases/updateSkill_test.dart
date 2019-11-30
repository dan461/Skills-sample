import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/usecases/insertNewSkill.dart';
import 'package:skills/features/skills/domain/usecases/updateSkill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'getAllSkills_test.dart';

void main() {
  UpdateSkill sut;
  MockSkillsRepo mockSkillsRepo;

  setUp((){
    mockSkillsRepo = MockSkillsRepo();
    sut = UpdateSkill(mockSkillsRepo);
  });

  final testSkill = Skill(name: 'test', source: 'test');

  test('should update skill and return int for number of changes made', () async {
    when(mockSkillsRepo.updateSkill(testSkill)).thenAnswer((_) async => Right(1));
    final result = await sut(InsertParams(skill: testSkill));
    expect(result, Right(1));
    verify(mockSkillsRepo.updateSkill(testSkill));
    verifyNoMoreInteractions(mockSkillsRepo);
  });
    
  
}