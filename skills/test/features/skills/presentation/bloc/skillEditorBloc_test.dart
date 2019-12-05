import 'package:flutter_test/flutter_test.dart' as prefix0;
import 'package:skills/core/error/failures.dart' show CacheFailure;
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/usecases/deleteSkillWithId.dart';
import 'package:skills/features/skills/domain/usecases/insertNewSkill.dart';
import 'package:skills/features/skills/domain/usecases/updateSkill.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/skillEditorScreen/bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_bloc.dart';

class MockInsertNewSkillUC extends Mock implements InsertNewSkill {}

class MockUpdateSkillUC extends Mock implements UpdateSkill {}
class MockDeleteSkillUC extends Mock implements DeleteSkillWithId {}

void main() {
  SkillEditorBloc sut;
  MockInsertNewSkillUC mockInsertNewSkillUC;
  MockUpdateSkillUC mockUpdateSkillUC;
  MockDeleteSkillUC mockDeleteSkillUC;
  Skill testSkill;

  setUp(() {
    mockInsertNewSkillUC = MockInsertNewSkillUC();
    mockUpdateSkillUC = MockUpdateSkillUC();
    mockDeleteSkillUC = MockDeleteSkillUC();
    sut = SkillEditorBloc(
        insertNewSkillUC: mockInsertNewSkillUC, updateSkill: mockUpdateSkillUC, deleteSkillWithId: mockDeleteSkillUC);
    testSkill = Skill(name: 'test', source: 'test');
  });

  test('test bloc initial state is correct', () {
    expect(sut.initialState, equals(InitialSkillEditorState()));
  });

  group('test that bloc is in correct mode for creating or editing a skill',
      () {
    test(
        'test for bloc emiting [CreatingNewSkillState] in response to a CreateSkillEvent',
        () async {
      final expected = [InitialSkillEditorState(), CreatingNewSkillState()];
      prefix0.expectLater(sut, emitsInOrder(expected));
      sut.add(CreateSkillEvent());
    });

    test(
        'test for bloc emiting [EditingSkillState] in response to a EditSkillEvent',
        () async {
      final expected = [
        InitialSkillEditorState(),
        EditingSkillState(testSkill)
      ];
      prefix0.expectLater(sut, emitsInOrder(expected));
      sut.add(EditSkillEvent(testSkill));
    });
  });

  group('InsertNewSkill', () {
    test('test for InsertNewSkill called', () async {
      when(mockInsertNewSkillUC(SkillInsertOrUpdateParams(skill: testSkill)))
          .thenAnswer((_) async => Right(1));
      sut.add(InsertNewSkillEvent(testSkill));
      await untilCalled(
          mockInsertNewSkillUC(SkillInsertOrUpdateParams(skill: testSkill)));
      verify(mockInsertNewSkillUC(SkillInsertOrUpdateParams(skill: testSkill)));
    });

    test(
        'test that bloc emits [NewSkillInsertingState, NewSkillInsertedState] on successful insert',
        () async {
      when(mockInsertNewSkillUC(SkillInsertOrUpdateParams(skill: testSkill)))
          .thenAnswer((_) async => Right(1));
      final expected = [
        InitialSkillEditorState(),
        NewSkillInsertingState(),
        NewSkillInsertedState(1)
      ];
      // assert before act due to possibility of act event completing too quickly
      expectLater(sut, emitsInOrder(expected));
      sut.add(InsertNewSkillEvent(testSkill));
    });

    test(
        'test that bloc emits [NewSkillInsertingState, SkillEditorErrorState] on unsuccessful insert',
        () async {
      when(mockInsertNewSkillUC(SkillInsertOrUpdateParams(skill: testSkill)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        InitialSkillEditorState(),
        NewSkillInsertingState(),
        SkillEditorErrorState(CACHE_FAILURE_MESSAGE)
      ];
      // assert before act due to possibility of act event completing too quickly
      expectLater(sut, emitsInOrder(expected));
      sut.add(InsertNewSkillEvent(testSkill));
    });
  });

  group('UpdateSkill', () {
    test(
        'test that bloc emits [UpdatingSkillState, UpdatedSkillState on successful update',
        () async {
      when(mockUpdateSkillUC(SkillInsertOrUpdateParams(skill: testSkill)))
          .thenAnswer((_) async => Right(1));
      final expected = [
        InitialSkillEditorState(),
        UpdatingSkillState(),
        UpdatedSkillState()
      ];
      prefix0.expectLater(sut, emitsInOrder(expected));
      sut.add(UpdateSkillEvent(testSkill));
    });

    test(
        'test that bloc emits [UpdatingSkillState, SkillEditorErrorState] on unsuccessful update',
        () async {
      when(mockUpdateSkillUC(SkillInsertOrUpdateParams(skill: testSkill)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        InitialSkillEditorState(),
        UpdatingSkillState(),
        SkillEditorErrorState(CACHE_FAILURE_MESSAGE)
      ];
      // assert before act due to possibility of act event completing too quickly
      expectLater(sut, emitsInOrder(expected));
      sut.add(UpdateSkillEvent(testSkill));
    });
  });

  group('DeleteSkillWithId', (){
    prefix0.test('test that DeleteSkillWithId is called', () async {
      when(mockDeleteSkillUC(SkillDeleteParams(skillId: 1))).thenAnswer((_) async => Right(1));
      sut.add(DeleteSkillWithIdEvent(1));
      await untilCalled(mockDeleteSkillUC(SkillDeleteParams(skillId: 1)));
      verify(mockDeleteSkillUC(SkillDeleteParams(skillId: 1)));
    });
  });
}
