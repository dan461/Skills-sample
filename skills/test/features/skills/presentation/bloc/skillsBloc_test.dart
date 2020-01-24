import 'package:skills/core/constants.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/bloc.dart';

import '../../mockClasses.dart';

void main() {
  SkillsBloc sut;
  MockGetAllSkillsUC mockGetAllSkillsUC;

  setUp(() {
    mockGetAllSkillsUC = MockGetAllSkillsUC();

    sut = SkillsBloc(
      getAllSkills: mockGetAllSkillsUC,
    );
  });

  group('Skill list sorting', (){

    final testSkill1 = Skill(name: 'Zulu', source: 'test');
    final testSkill2 = Skill(name: 'Delta', source: 'test');
    final testSkill3 = Skill(name: 'Alpha', source: 'test');
    final testSkill4 = Skill(name: 'Lima', source: 'test');
    final List<Skill> skillsList = [testSkill1, testSkill2, testSkill3, testSkill4];
    
    test('test that skill list is sorted by selected option', (){
      sut.skills = skillsList;
      sut.sortOptionPicked(SkillSortOption.name);
      List<Skill> expected = [testSkill3, testSkill2, testSkill4, testSkill1];
      expect(sut.skills, expected);
    });

    test('test that skill list is reversed when asc/desc tapped', (){
      sut.skills = skillsList;
      sut.ascDescTapped();
      List<Skill> expected = [testSkill4, testSkill3, testSkill2, testSkill1];
      expect(sut.skills, expected);
    });
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
