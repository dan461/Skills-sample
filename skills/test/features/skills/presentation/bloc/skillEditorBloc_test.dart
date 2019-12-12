import 'package:flutter_test/flutter_test.dart' as prefix0;
import 'package:skills/core/constants.dart';
import 'package:skills/core/error/failures.dart' show CacheFailure;
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/usecases/deleteSkillWithId.dart';
import 'package:skills/features/skills/domain/usecases/getSkillById.dart';
import 'package:skills/features/skills/domain/usecases/insertNewSkill.dart';
import 'package:skills/features/skills/domain/usecases/updateSkill.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/skillEditorScreen/bloc.dart';

class MockInsertNewSkillUC extends Mock implements InsertNewSkill {}

class MockUpdateSkillUC extends Mock implements UpdateSkill {}

class MockDeleteSkillUC extends Mock implements DeleteSkillWithId {}

class MockGetSkillByIdUC extends Mock implements GetSkillById {}

void main() {
  SkillEditorBloc sut;
  MockInsertNewSkillUC mockInsertNewSkillUC;
  MockUpdateSkillUC mockUpdateSkillUC;
  MockDeleteSkillUC mockDeleteSkillUC;
  MockGetSkillByIdUC mockGetSkillByIdUC;
  Skill testSkill;

  setUp(() {
    mockInsertNewSkillUC = MockInsertNewSkillUC();
    mockUpdateSkillUC = MockUpdateSkillUC();
    mockDeleteSkillUC = MockDeleteSkillUC();
    mockGetSkillByIdUC = MockGetSkillByIdUC();
    sut = SkillEditorBloc(
        insertNewSkillUC: mockInsertNewSkillUC,
        updateSkill: mockUpdateSkillUC,
        getSkillById: mockGetSkillByIdUC,
        deleteSkillWithId: mockDeleteSkillUC);
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
Skill newSkill = Skill(name: 'new', source: 'new');

    test('test for InsertNewSkill called', () async {
      when(mockInsertNewSkillUC(SkillInsertOrUpdateParams(skill: testSkill)))
          .thenAnswer((_) async => Right(newSkill));
      sut.add(InsertNewSkillEvent(testSkill));
      await untilCalled(
          mockInsertNewSkillUC(SkillInsertOrUpdateParams(skill: testSkill)));
      verify(mockInsertNewSkillUC(SkillInsertOrUpdateParams(skill: testSkill)));
    });

    test(
        'test that bloc emits [NewSkillInsertingState, EditingSkillState] on successful insert',
        () async {
      when(mockInsertNewSkillUC(SkillInsertOrUpdateParams(skill: testSkill)))
          .thenAnswer((_) async => Right(newSkill));
      final expected = [
        InitialSkillEditorState(),
        NewSkillInsertingState(),
        EditingSkillState(newSkill)
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

  group('GetSkillById', () {
    test(
      'test for GetSkillById being called',
      () async {
        when(mockGetSkillByIdUC(GetSkillParams(id: 1)))
            .thenAnswer((_) async => Right(testSkill));
        sut.add(GetSkillByIdEvent(id: 1));
        await untilCalled(mockGetSkillByIdUC(GetSkillParams(id: 1)));
        verify(mockGetSkillByIdUC(GetSkillParams(id: 1)));
      },
    );

    test(
      'test that bloc emits [SkillEditorCrudInProgressState, SkillRetrievedForEditingState] upon success',
      () async {
        when(mockGetSkillByIdUC(GetSkillParams(id: 1)))
            .thenAnswer((_) async => Right(testSkill));
        final expected = [
          InitialSkillEditorState(),
          SkillEditorCrudInProgressState(),
          SkillRetrievedForEditingState(testSkill)
        ];
        expectLater(sut, emitsInOrder(expected));
        sut.add(GetSkillByIdEvent(id: 1));
      },
    );

    test(
      'test that bloc emits [SkillEditorCrudInProgressState, SkillEditorErrorState] upon failure',
      () async {
        when(mockGetSkillByIdUC(GetSkillParams(id: 1)))
            .thenAnswer((_) async => Left(CacheFailure()));
        final expected = [
          InitialSkillEditorState(),
          SkillEditorCrudInProgressState(),
          SkillEditorErrorState(CACHE_FAILURE_MESSAGE)
        ];
        expectLater(sut, emitsInOrder(expected));
        sut.add(GetSkillByIdEvent(id: 1));
      },
    );
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
      sut.add(UpdateSkillEvent(skill: testSkill));
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
      sut.add(UpdateSkillEvent(skill: testSkill));
    });
  });

  group('DeleteSkillWithId', () {
    prefix0.test('test that DeleteSkillWithId is called', () async {
      when(mockDeleteSkillUC(SkillDeleteParams(skillId: 1)))
          .thenAnswer((_) async => Right(1));
      sut.add(DeleteSkillWithIdEvent(skillId: 1));
      await untilCalled(mockDeleteSkillUC(SkillDeleteParams(skillId: 1)));
      verify(mockDeleteSkillUC(SkillDeleteParams(skillId: 1)));
    });
  });
}
