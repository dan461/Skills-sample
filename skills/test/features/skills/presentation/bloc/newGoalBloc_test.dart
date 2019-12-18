import 'package:dartz/dartz.dart';
import 'package:dartz/dartz.dart' as prefix1;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

import 'package:skills/features/skills/presentation/bloc/newGoalScreen/newgoal_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/newGoalScreen/newgoal_event.dart';
import 'package:skills/features/skills/presentation/bloc/newGoalScreen/newgoal_state.dart';

import '../../mockClasses.dart';

void main() {
  NewgoalBloc sut;
  MockInsertNewGoalUC mockInsertNewGoalUC;
  MockAddGoalToSkill mockAddGoalToSkill;
  Goal testGoal;
  Goal newGoal;

  setUp(() {
    mockInsertNewGoalUC = MockInsertNewGoalUC();
    mockAddGoalToSkill = MockAddGoalToSkill();
    sut = NewgoalBloc(
        insertNewGoalUC: mockInsertNewGoalUC,
        addGoalToSkill: mockAddGoalToSkill);
    testGoal = Goal(
        skillId: 1,
        fromDate: DateTime.now(),
        toDate: DateTime.now(),
        isComplete: false,
        timeBased: true,
        timeRemaining: 0,
        goalTime: 0);

    newGoal = Goal(
        skillId: 1,
        fromDate: DateTime.now(),
        toDate: DateTime.now(),
        isComplete: false,
        timeBased: true,
        timeRemaining: 0,
        goalTime: 0);
  });

  test('test bloc initial state is correct', () {
    expect(sut.initialState, equals(InitialNewgoalState()));
  });

  group('InsertNewGoal', () {
    test('test that InsertNewGoal usecase called', () async {
      when(mockInsertNewGoalUC(GoalCrudParams(id: null, goal: testGoal)))
          .thenAnswer((_) async => Right(newGoal));
      sut.add(InsertNewGoalEvent(testGoal));
      await untilCalled(
          mockInsertNewGoalUC(GoalCrudParams(id: null, goal: testGoal)));
      verify(mockInsertNewGoalUC(GoalCrudParams(id: null, goal: testGoal)));
    });

    test(
        'test that bloc emits [NewGoalInsertingState, NewGoalInsertedState] on successful insert',
        () async {
      when(mockInsertNewGoalUC(GoalCrudParams(id: null, goal: testGoal)))
          .thenAnswer((_) async => Right(newGoal));
      final expected = [
        InitialNewgoalState(),
        NewGoalInsertingState(),
        NewGoalInsertedState(newGoal)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(InsertNewGoalEvent(testGoal));
    });

    test(
        'test that bloc emits [NewGoalInsertingState, GoalEditorErrorState] upon unsuccessful insert',
        () async {
      when(mockInsertNewGoalUC(GoalCrudParams(id: null, goal: testGoal)))
          .thenAnswer((_) async => prefix1.Left(CacheFailure()));
      final expected = [
        InitialNewgoalState(),
        NewGoalInsertingState(),
        NewGoalErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(InsertNewGoalEvent(testGoal));
    });
  });

  group('AddGoalToSkill', () {
    test('test that AddGoalToSkill is called', () async {
      when(mockAddGoalToSkill(
              AddGoalToSkillParams(skillId: 1, goalId: 1, goalText: 'goal')))
          .thenAnswer((_) async => Right(1));
      sut.add(AddGoalToSkillEvent(skillId: 1, goalId: 1, goalText: 'goal'));
      await untilCalled(mockAddGoalToSkill(
          AddGoalToSkillParams(skillId: 1, goalId: 1, goalText: 'goal')));
      verify(mockAddGoalToSkill(
          AddGoalToSkillParams(skillId: 1, goalId: 1, goalText: 'goal')));
    });

    test(
        'test that bloc emits [AddingGoalToSkillState, GoalAddedToSkillState] on successful add',
        () async {
      when(mockAddGoalToSkill(
              AddGoalToSkillParams(skillId: 1, goalId: 1, goalText: 'goal')))
          .thenAnswer((_) async => Right(1));
      final expected = [
        InitialNewgoalState(),
        AddingGoalToSkillState(),
        GoalAddedToSkillState(newId: 1, goalText: 'none')
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(AddGoalToSkillEvent(skillId: 1, goalId: 1, goalText: 'goal'));
    });

    test(
        'test that bloc emits [AddingGoalToSkillState, GoalEditorErrorState] upon unsuccessful add',
        () async {
      when(mockAddGoalToSkill(
              AddGoalToSkillParams(skillId: 1, goalId: 1, goalText: 'goal')))
          .thenAnswer((_) async => prefix1.Left(CacheFailure()));
      final expected = [
        InitialNewgoalState(),
        AddingGoalToSkillState(),
        NewGoalErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(AddGoalToSkillEvent(skillId: 1, goalId: 1, goalText: 'goal'));
    });
  });
}
