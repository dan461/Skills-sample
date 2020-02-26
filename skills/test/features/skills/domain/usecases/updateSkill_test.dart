import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/usecases/skillUseCases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

import '../../mockClasses.dart';

void main() {
  UpdateSkill sut;
  MockSkillsRepo mockSkillsRepo;

  setUp(() {
    mockSkillsRepo = MockSkillsRepo();
    sut = UpdateSkill(mockSkillsRepo);
  });

  final testSkill = Skill(
    name: 'test',
    source: 'test',
    type: 'composition',
    startDate: DateTime.fromMillisecondsSinceEpoch(0),
  );

  Map<String, dynamic> testMap = {'name' : 'test'};

  test('should update skill and return int for number of changes made',
      () async {
    when(mockSkillsRepo.updateSkill(testSkill.skillId, testMap))
        .thenAnswer((_) async => Right(1));
    final result = await sut(SkillUpdateParams(skillId: testSkill.skillId, changeMap: testMap));
    expect(result, Right(1));
    verify(mockSkillsRepo.updateSkill(testSkill.skillId, testMap));
    verifyNoMoreInteractions(mockSkillsRepo);
  });
}
