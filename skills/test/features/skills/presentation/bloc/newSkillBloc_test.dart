import 'package:skills/core/error/failures.dart' show CacheFailure;
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/usecases/insertNewSkill.dart';
import 'package:skills/features/skills/presentation/bloc/newSkillScreen/bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_bloc.dart';

class MockInsertNewSkillUC extends Mock implements InsertNewSkill {}

void main() {
  NewSkillBloc sut;
  MockInsertNewSkillUC mockInsertNewSkillUC;

  setUp(() {
    mockInsertNewSkillUC = MockInsertNewSkillUC();
    sut = NewSkillBloc(insertNewSkillUC: mockInsertNewSkillUC);
  });

  test('test bloc initial state is correct', () {
    expect(sut.initialState, equals(EmptyNewSkillState()));
  });

  group('InertNewSkill', () {
    final testSkill = Skill(name: 'test', source: 'test');

    test('test that new id for skill is returned', () async {
      when(mockInsertNewSkillUC(InsertParams(skill: testSkill)))
          .thenAnswer((_) async => Right(1));
      sut.add(InsertNewSkillEvent(testSkill));
      await untilCalled(mockInsertNewSkillUC(InsertParams(skill: testSkill)));
      verify(mockInsertNewSkillUC(InsertParams(skill: testSkill)));
    });

    test(
        'test that bloc emits [NewSkillInsertingState, NewSkillInsertedState] on successful insert',
        () async {
      when(mockInsertNewSkillUC(InsertParams(skill: testSkill)))
          .thenAnswer((_) async => Right(1));
      final expected = [
        EmptyNewSkillState(),
        NewSkillInsertingState(),
        NewSkillInsertedState(1)
      ];
      // assert before act due to possibility of act event completing too quickly
      expectLater(sut, emitsInOrder(expected));
      sut.add(InsertNewSkillEvent(testSkill));
    });

    test(
        'test that bloc emits [NewSkillInsertingState, NewSkillErrorState] on unsuccessful insert',
        () async {
      when(mockInsertNewSkillUC(InsertParams(skill: testSkill)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        EmptyNewSkillState(),
        NewSkillInsertingState(),
        NewSkillErrorState(CACHE_FAILURE_MESSAGE)
      ];
      // assert before act due to possibility of act event completing too quickly
      expectLater(sut, emitsInOrder(expected));
      sut.add(InsertNewSkillEvent(testSkill));
    });
  });
}
