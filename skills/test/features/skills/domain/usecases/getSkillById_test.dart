import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/usecases/getSkillById.dart';
import '../../mockClasses.dart';

void main(){
  GetSkillById sut;
  MockSkillsRepo mockSkillsRepo;

  setUp((){
    mockSkillsRepo = MockSkillsRepo();
    sut = GetSkillById(mockSkillsRepo);
  });

  final testSkill = Skill(name: 'test', source: 'test');

  test('should return a Skill', () async {
    when(mockSkillsRepo.getSkillById(any)).thenAnswer((_) async => Right(testSkill));
    final result = await sut(GetSkillParams(id: 1));
    expect(result, Right(testSkill));
    verify(mockSkillsRepo.getSkillById(1));
    verifyNoMoreInteractions(mockSkillsRepo);
  });
}

