import 'package:skills/core/constants.dart';
import 'package:skills/core/enums.dart';
import 'package:skills/core/error/failures.dart' show CacheFailure;
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/newSkillScreen/newskill_bloc.dart';

import '../../mockClasses.dart';

void main() {
  NewskillBloc sut;
  MockInsertNewSkillUC mockInsertNewSkillUC;
  Skill testSkill;

  setUp(() {
    mockInsertNewSkillUC = MockInsertNewSkillUC();
    sut = NewskillBloc(insertNewSkillUC: mockInsertNewSkillUC);

    testSkill = Skill(
        name: 'test',
        type: skillTypeToString(SkillType.composition),
        startDate: DateTime.utc(2019, 2, 1));
  });

  group('InsertNewSkill', () {
    Skill newSkill = Skill(
        name: 'test',
        type: skillTypeToString(SkillType.composition),
        startDate: DateTime.utc(2019, 2, 1));

    test('test for InsertNewSkill called', () async {
      when(mockInsertNewSkillUC(SkillInsertOrUpdateParams(skill: testSkill)))
          .thenAnswer((_) async => Right(newSkill));
      sut.add(CreateNewSkillEvent(testSkill));
      await untilCalled(
          mockInsertNewSkillUC(SkillInsertOrUpdateParams(skill: testSkill)));
      verify(mockInsertNewSkillUC(SkillInsertOrUpdateParams(skill: testSkill)));
    });

    test(
        'test that bloc emits [CreatingNewSkillState, NewSkillInsertedState] on successful insert',
        () async {
      when(mockInsertNewSkillUC(SkillInsertOrUpdateParams(skill: testSkill)))
          .thenAnswer((_) async => Right(newSkill));
      final expected = [CreatingNewSkillState(), NewSkillInsertedState()];
      // assert before act due to possibility of act event completing too quickly
      expectLater(sut, emitsInOrder(expected));
      sut.add(CreateNewSkillEvent(testSkill));
    });

    test(
        'test that bloc emits [CreatingNewSkillState, NewSkillErrorState] on unsuccessful insert',
        () async {
      when(mockInsertNewSkillUC(SkillInsertOrUpdateParams(skill: testSkill)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        CreatingNewSkillState(),
        NewSkillErrorState(CACHE_FAILURE_MESSAGE)
      ];
      // assert before act due to possibility of act event completing too quickly
      expectLater(sut, emitsInOrder(expected));
      sut.add(CreateNewSkillEvent(testSkill));
    });
  });
}
