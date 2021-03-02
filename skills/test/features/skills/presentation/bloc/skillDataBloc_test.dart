import 'package:skills/core/constants.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/skillsDetailScreen/skilldata_bloc.dart';

import '../../mockClasses.dart';

void main() {
  SkillDataBloc sut;
  MockGetCompletedActivitiesForSkill mockGetCompletedEventsForSkill;
  MockUpdateSkillUC mockUpdateSkillUC;
  MockGetSkillByIdUC mockGetSkillByIdUC;
  MockGetSkillGoalMapById mockGetSkillGoalMapById;
  Activity testEvent;

  List<Activity> eventsList;

  setUp(() {
    mockGetCompletedEventsForSkill = MockGetCompletedActivitiesForSkill();
    mockUpdateSkillUC = MockUpdateSkillUC();
    mockGetSkillByIdUC = MockGetSkillByIdUC();
    mockGetSkillGoalMapById = MockGetSkillGoalMapById();

    sut = SkillDataBloc(
        getCompletedEventsForSkill: mockGetCompletedEventsForSkill,
        updateSkill: mockUpdateSkillUC,
        getSkillById: mockGetSkillByIdUC,
        getSkillGoalMapById: mockGetSkillGoalMapById);

    testEvent = Activity(
        eventId: 1,
        skillId: 1,
        sessionId: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        duration: 30,
        isComplete: true,
        skillString: 'test');

    eventsList = [testEvent];
  });

  test('bloc initial state is correct', () {
    expect(sut.initialState, equals(SkillDataInitialState()));
  });

  group('GetEventsForSkillEvent: - ', () {
    test(
        'test that bloc emits [SkillDataCrudProcessingState, SkillDataEventsLoadedState] when GetEventsForSkillEvent is added',
        () {
      when(mockGetCompletedEventsForSkill(GetSkillParams(id: 1)))
          .thenAnswer((_) async => Right(eventsList));
      final expected = [
        SkillDataInitialState(),
        SkillDataCrudProcessingState(),
        SkillDataEventsLoadedState()
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(GetEventsForSkillEvent(skillId: 1));
    });

    test(
        'test that bloc emits [SkillDataCrudProcessingState, SkillDataErrorState] when cache failure after GetEventsForSkillEvent is added',
        () {
      when(mockGetCompletedEventsForSkill(GetSkillParams(id: 1)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        SkillDataInitialState(),
        SkillDataCrudProcessingState(),
        SkillDataErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(GetEventsForSkillEvent(skillId: 1));
    });
  });

  group('UpdateExistingSkillEvent: - ', () {
    final testSkill = Skill(
      skillId: 1,
      name: 'test',
      source: 'test',
      type: 'composition',
      startDate: DateTime.fromMillisecondsSinceEpoch(0),
    );
    Map<String, dynamic> testMap = {'name': 'new name'};
    test(
        'test that bloc emits [SkillDataCrudProcessingState, UpdatedExistingSkillState] after UpdateExistingSkillEvent is added ',
        () {
      when(mockUpdateSkillUC(SkillUpdateParams(
              skillId: testSkill.skillId, changeMap: testMap)))
          .thenAnswer((_) async => Right(1));
      final expected = [
        SkillDataInitialState(),
        SkillDataCrudProcessingState(),
        UpdatedExistingSkillState()
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(UpdateExistingSkillEvent(
          skillId: testSkill.skillId, changeMap: testMap));
    });

    test(
        'test that bloc emits [SkillDataCrudProcessingState, SkillDataErrorState] after cache failure when UpdateExistingSkillEvent is added ',
        () {
      when(mockUpdateSkillUC(SkillUpdateParams(
              skillId: testSkill.skillId, changeMap: testMap)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        SkillDataInitialState(),
        SkillDataCrudProcessingState(),
        SkillDataErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(UpdateExistingSkillEvent(
          skillId: testSkill.skillId, changeMap: testMap));
    });
  });

  group('RefreshSkillByIdEvent: - ', () {
    final testSkill = Skill(
      skillId: 1,
      name: 'test',
      source: 'test',
      type: 'composition',
      startDate: DateTime.fromMillisecondsSinceEpoch(0),
    );

    final testGoal = Goal(
        skillId: 1,
        goalTime: 1,
        fromDate: DateTime.fromMillisecondsSinceEpoch(0),
        toDate: DateTime.fromMillisecondsSinceEpoch(0),
        isComplete: false,
        timeBased: true);

    final testMap = {'skill': testSkill, 'goal': testGoal};

    test(
        'test that bloc emits [SkillDataCrudProcessingState, SkillRefreshedState] after RefreshSkillByIdEvent is added ',
        () {
      when(mockGetSkillGoalMapById(GetSkillParams(id: 1)))
          .thenAnswer((_) async => Right(testMap));
      final expected = [
        SkillDataInitialState(),
        SkillDataCrudProcessingState(),
        SkillRefreshedState()
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(RefreshSkillByIdEvent(skillId: 1));
    });

    test(
        'test that bloc emits [SkillDataCrudProcessingState, SkillDataErrorState] after cache failure when RefreshSkillByIdEvent is added ',
        () {
      when(mockGetSkillGoalMapById(GetSkillParams(id: 1)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        SkillDataInitialState(),
        SkillDataCrudProcessingState(),
        SkillDataErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(RefreshSkillByIdEvent(skillId: 1));
    });
  });
}
