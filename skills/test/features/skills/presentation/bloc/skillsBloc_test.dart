import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/usecases/getAllSkills.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/usecases/getSkillById.dart';
import 'package:skills/features/skills/domain/usecases/insertNewSkill.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/bloc.dart';

class MockGetAllSkillsUC extends Mock implements GetAllSkills {}

class MockGetSkillById extends Mock implements GetSkillById {}

class MockInsertNewSkillUC extends Mock implements InsertNewSkill {}

void main() {
  SkillsBloc sut;
  MockGetAllSkillsUC mockGetAllSkillsUC;

  setUp(() {
    mockGetAllSkillsUC = MockGetAllSkillsUC();

    sut = SkillsBloc(
      getAllSkills: mockGetAllSkillsUC,
    );
  });

  test('test initial state is correct', () {
    expect(sut.initialState, equals(InitialSkillsState()));
  });

  group('GetAllSkills', () {
    final testSkill = Skill(name: 'test', source: 'test');
    final List<Skill> skillsList = [testSkill];
    test('test that List of Skills is returned', () async {
      when(mockGetAllSkillsUC(NoParams()))
          .thenAnswer((_) async => Right(skillsList));
      sut.add(GetAllSkillsEvent());
      await untilCalled(mockGetAllSkillsUC(NoParams()));
      verify(mockGetAllSkillsUC(NoParams()));
    });

    test('test that Bloc emits [Loading, Loaded] states on successful query',
        () async {
      when(mockGetAllSkillsUC(NoParams()))
          .thenAnswer((_) async => Right(skillsList));
      final expected = [
        InitialSkillsState(),
        AllSkillsLoading(),
        AllSkillsLoaded(skillsList),
      ];

      // assert before act due to possibility of act event completing too quickly
      expectLater(sut, emitsInOrder(expected));
      sut.add(GetAllSkillsEvent());
    });

    test('test that Bloc emits [Loading, Error] when db query fails', () async {
      when(mockGetAllSkillsUC(NoParams()))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        InitialSkillsState(),
        AllSkillsLoading(),
        AllSkillsError(CACHE_FAILURE_MESSAGE),
      ];

      expectLater(sut, emitsInOrder(expected));
      sut.add(GetAllSkillsEvent());
    });

    test('test that Bloc emits [Loading, Error] when call to server fails',
        () async {
      when(mockGetAllSkillsUC(NoParams()))
          .thenAnswer((_) async => Left(ServerFailure()));
      final expected = [
        InitialSkillsState(),
        AllSkillsLoading(),
        AllSkillsError(SERVER_FAILURE_MESSAGE),
      ];

      expectLater(sut, emitsInOrder(expected));
      sut.add(GetAllSkillsEvent());
    });
  });

  // group('GetSkillById', (){
  //   final testSkill = Skill(name: 'test', source: 'test');
  //   test('test that a Skill is returned', () async {
  //     when(mockGetSkillByIdUC(GetSkillParams(id: 1))).thenAnswer((_) async => Right(testSkill));
  //     sut.add(GetSkillByIdEvent(id: 1));
  //     await untilCalled(mockGetSkillByIdUC(GetSkillParams(id: 1)));
  //     verify(mockGetSkillByIdUC(GetSkillParams(id: 1)));

  //   });
  // });
}
