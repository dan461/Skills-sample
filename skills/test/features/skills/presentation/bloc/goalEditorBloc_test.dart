import 'package:dartz/dartz.dart';
import 'package:dartz/dartz.dart' as prefix1;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/flutter_test.dart' as prefix0;
import 'package:mockito/mockito.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/usecases/addGoalToSkill.dart';
import 'package:skills/features/skills/domain/usecases/deleteGoalWithId.dart';
import 'package:skills/features/skills/domain/usecases/insertNewGoal.dart';
import 'package:skills/features/skills/domain/usecases/updateGoal.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/goalEditorScreen/bloc.dart';

// class MockInsertNewGoalUC extends Mock implements InsertNewGoal {}

class MockUpdateGoalUC extends Mock implements UpdateGoal {}

// class MockAddGoalToSkill extends Mock implements AddGoalToSkill {}

class MockDeleteGoalWithId extends Mock implements DeleteGoalWithId {}

void main() {
  GoaleditorBloc sut;
  // MockInsertNewGoalUC mockInsertNewGoalUC;
  MockUpdateGoalUC mockUpdateGoalUC;
  // MockAddGoalToSkill mockAddGoalToSkill;
  MockDeleteGoalWithId mockDeleteGoalWithId;
  Goal testGoal;
  Goal newGoal;

  setUp(() {
    // mockInsertNewGoalUC = MockInsertNewGoalUC();
    mockUpdateGoalUC = MockUpdateGoalUC();
    // mockAddGoalToSkill = MockAddGoalToSkill();
    mockDeleteGoalWithId = MockDeleteGoalWithId();
    sut = GoaleditorBloc(
        updateGoalUC: mockUpdateGoalUC, deleteGoalWithId: mockDeleteGoalWithId);

    testGoal = Goal(
        skillId: 1,
        fromDate: DateTime.now().millisecondsSinceEpoch,
        toDate: DateTime.now().millisecondsSinceEpoch,
        isComplete: false,
        timeBased: true,
        timeRemaining: 0,
        goalTime: 0);

    newGoal = Goal(
        skillId: 1,
        fromDate: DateTime.now().millisecondsSinceEpoch,
        toDate: DateTime.now().millisecondsSinceEpoch,
        isComplete: false,
        timeBased: true,
        timeRemaining: 0,
        goalTime: 0);
  });

  test('test bloc initial state is correct', () {
    expect(sut.initialState, equals(EmptyGoalEditorState()));
  });

  group('test that bloc is in correct mode for creating or editing a goal', () {
    test(
        'test for bloc emitting [GoalEditorCreatingState] in response to a CreateNewGoalEvent',
        () async {
      final expected = [EmptyGoalEditorState(), GoalEditorCreatingState()];
      expectLater(sut, emitsInOrder(expected));
      sut.add(CreateNewGoalEvent());
    });

    test(
        'test for bloc emitting [GoalEditorEditingState] in response to an EditGoalEvent',
        () async {
      final expected = [
        EmptyGoalEditorState(),
        GoalEditorEditingState(goal: testGoal)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(EditGoalEvent(goalId: 1));
    });
  });

  // group('InsertNewGoal', () {
  //   test('test that InsertNewGoal usecase called', () async {
  //     when(mockInsertNewGoalUC(GoalCrudParams(id: null, goal: testGoal)))
  //         .thenAnswer((_) async => Right(newGoal));
  //     sut.add(InsertNewGoalEvent(testGoal));
  //     await untilCalled(
  //         mockInsertNewGoalUC(GoalCrudParams(id: null, goal: testGoal)));
  //     verify(mockInsertNewGoalUC(GoalCrudParams(id: null, goal: testGoal)));
  //   });

  //   test(
  //       'test that bloc emits [GoalCrudInProgressState, NewGoalInsertedState] on successful insert',
  //       () async {
  //     when(mockInsertNewGoalUC(GoalCrudParams(id: null, goal: testGoal)))
  //         .thenAnswer((_) async => Right(newGoal));
  //     final expected = [
  //       EmptyGoalEditorState(),
  //       GoalCrudInProgressState(),
  //       NewGoalInsertedState(newGoal)
  //     ];
  //     expectLater(sut, emitsInOrder(expected));
  //     sut.add(InsertNewGoalEvent(testGoal));
  //   });

  //   test(
  //       'test that bloc emits [GoalCrudInProgressState, GoalEditorErrorState] upon unsuccessful insert',
  //       () async {
  //     when(mockInsertNewGoalUC(GoalCrudParams(id: null, goal: testGoal)))
  //         .thenAnswer((_) async => prefix1.Left(CacheFailure()));
  //     final expected = [
  //       EmptyGoalEditorState(),
  //       GoalCrudInProgressState(),
  //       GoalEditorErrorState(CACHE_FAILURE_MESSAGE)
  //     ];
  //     expectLater(sut, emitsInOrder(expected));
  //     sut.add(InsertNewGoalEvent(testGoal));
  //   });
  // });

  // group('AddGoalToSkill', () {
  //   test('test that AddGoalToSkill is called', () async {
  //     when(mockAddGoalToSkill(
  //             AddGoalToSkillParams(skillId: 1, goalId: 1, goalText: 'goal')))
  //         .thenAnswer((_) async => Right(1));
  //     sut.add(AddGoalToSkillEvent(skillId: 1, goalId: 1, goalText: 'goal'));
  //     await untilCalled(mockAddGoalToSkill(
  //         AddGoalToSkillParams(skillId: 1, goalId: 1, goalText: 'goal')));
  //     verify(mockAddGoalToSkill(
  //         AddGoalToSkillParams(skillId: 1, goalId: 1, goalText: 'goal')));
  //   });

  //   test(
  //       'test that bloc emits [GoalCrudInProgressState, GoalAddedToSkillState] on successful add',
  //       () async {
  //     when(mockAddGoalToSkill(
  //             AddGoalToSkillParams(skillId: 1, goalId: 1, goalText: 'goal')))
  //         .thenAnswer((_) async => Right(1));
  //     final expected = [
  //       EmptyGoalEditorState(),
  //       GoalCrudInProgressState(),
  //       GoalAddedToSkillState(newId: 1, goalText: 'none')
  //     ];
  //     expectLater(sut, emitsInOrder(expected));
  //     sut.add(AddGoalToSkillEvent(skillId: 1, goalId: 1, goalText: 'goal'));
  //   });

  //   test(
  //       'test that bloc emits [GoalCrudInProgressState, GoalEditorErrorState] upon unsuccessful add',
  //       () async {
  //     when(mockAddGoalToSkill(
  //             AddGoalToSkillParams(skillId: 1, goalId: 1, goalText: 'goal')))
  //         .thenAnswer((_) async => prefix1.Left(CacheFailure()));
  //     final expected = [
  //       EmptyGoalEditorState(),
  //       GoalCrudInProgressState(),
  //       GoalEditorErrorState(CACHE_FAILURE_MESSAGE)
  //     ];
  //     expectLater(sut, emitsInOrder(expected));
  //     sut.add(AddGoalToSkillEvent(skillId: 1, goalId: 1, goalText: 'goal'));
  //   });
  // });

  group('DeleteGoalWithId', () {
    test('test that DeleteGoalWithId is called', () async {
      when(mockDeleteGoalWithId(GoalCrudParams(id: 1)))
          .thenAnswer((_) async => Right(0));
      sut.add(DeleteGoalEvent(1));
      await untilCalled(mockDeleteGoalWithId(GoalCrudParams(id: 1)));
      verify(mockDeleteGoalWithId(GoalCrudParams(id: 1)));
    });

    test(
        'test that bloc emits [GoalCrudInProgressState, GoalDeletedState] on successful delete',
        () async {
      when(mockDeleteGoalWithId(GoalCrudParams(id: 1)))
          .thenAnswer((_) async => Right(0));
      final expected = [
        EmptyGoalEditorState(),
        GoalCrudInProgressState(),
        GoalDeletedState(0)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(DeleteGoalEvent(1));
    });

    test(
        'test that bloc emits [GoalCrudInProgressState, GoalEditorErrorState] upon unsuccessful delete',
        () async {
      when(mockDeleteGoalWithId(GoalCrudParams(id: 1)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        EmptyGoalEditorState(),
        GoalCrudInProgressState(),
        GoalEditorErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(DeleteGoalEvent(1));
    });
  });

  prefix0.group('UpdateGoal', () {
    test('test that UpdateGoal is called', () async {
      when(mockUpdateGoalUC(GoalCrudParams(id: null, goal: testGoal)))
          .thenAnswer((_) async => Right(1));
      sut.add(UpdateGoalEvent(testGoal));
      await untilCalled(
          mockUpdateGoalUC(GoalCrudParams(id: null, goal: testGoal)));
      verify(mockUpdateGoalUC(GoalCrudParams(id: null, goal: testGoal)));
    });

    test(
        'test that bloc emits [GoalCrudInProgressState, GoalUpdatedState] upon successful update',
        () async {
      when(mockUpdateGoalUC(GoalCrudParams(id: null, goal: testGoal)))
          .thenAnswer((_) async => Right(1));
      final expected = [
        EmptyGoalEditorState(),
        GoalCrudInProgressState(),
        GoalUpdatedState(1)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(UpdateGoalEvent(testGoal));
    });

    test(
        'test that bloc emits [GoalCrudInProgressState, GoalEditorErrorState] upon unsuccessful update',
        () async {
      when(mockUpdateGoalUC(GoalCrudParams(id: null, goal: testGoal)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        EmptyGoalEditorState(),
        GoalCrudInProgressState(),
        GoalEditorErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(UpdateGoalEvent(testGoal));
    });
  });

  group('testing translation of a goal to a descriptive string', () {
    test(
        'test translation of a time based goal into a descriptive string, with hours and minutes.',
        () {
      DateTime from = DateTime(2019, 07, 02);
      DateTime to = DateTime(2019, 07, 04);

      final testTimeGoal = Goal(
          skillId: 1,
          fromDate: from.millisecondsSinceEpoch,
          toDate: to.millisecondsSinceEpoch,
          isComplete: false,
          timeBased: true,
          goalTime: 330);

      String matcher = "Goal: 5 hrs 30 min between Jul 2 and Jul 4.";
      String translation = sut.translateGoal(testTimeGoal);

      expect(translation, matcher);
    });

    test(
        'test translation of a time based goal into a descriptive string, with one hour and no minutes.',
        () {
      DateTime from = DateTime(2019, 07, 02);
      DateTime to = DateTime(2019, 07, 04);

      final testTimeGoal = Goal(
          skillId: 1,
          fromDate: from.millisecondsSinceEpoch,
          toDate: to.millisecondsSinceEpoch,
          isComplete: false,
          timeBased: true,
          goalTime: 60);

      String matcher = "Goal: 1 hour between Jul 2 and Jul 4.";
      String translation = sut.translateGoal(testTimeGoal);

      expect(translation, matcher);
    });

    test(
        'test translation of a time based goal into a descriptive string, with less than one hour.',
        () {
      DateTime from = DateTime(2019, 07, 02);
      DateTime to = DateTime(2019, 07, 04);

      final testTimeGoal = Goal(
          skillId: 1,
          fromDate: from.millisecondsSinceEpoch,
          toDate: to.millisecondsSinceEpoch,
          isComplete: false,
          timeBased: true,
          goalTime: 15);

      String matcher = "Goal: 15 minutes between Jul 2 and Jul 4.";
      String translation = sut.translateGoal(testTimeGoal);

      expect(translation, matcher);
    });

    test(
        'test translation of a time based goal with multiple hours and zero minutes into a descriptive string.',
        () {
      DateTime from = DateTime(2019, 07, 02);
      DateTime to = DateTime(2019, 07, 04);

      final testTimeGoal = Goal(
          skillId: 1,
          fromDate: from.millisecondsSinceEpoch,
          toDate: to.millisecondsSinceEpoch,
          isComplete: false,
          timeBased: true,
          goalTime: 120);

      String matcher = "Goal: 2 hrs between Jul 2 and Jul 4.";
      String translation = sut.translateGoal(testTimeGoal);

      expect(translation, matcher);
    });

    test(
        'test translation of a time based goal into a descriptive string, start and end on same day.',
        () {
      DateTime from = DateTime(2019, 07, 02);
      DateTime to = DateTime(2019, 07, 02);

      final testTimeGoal = Goal(
          skillId: 1,
          fromDate: from.millisecondsSinceEpoch,
          toDate: to.millisecondsSinceEpoch,
          isComplete: false,
          timeBased: true,
          goalTime: 90);

      String matcher = "Goal: 1 hrs 30 min on Jul 2.";
      String translation = sut.translateGoal(testTimeGoal);

      expect(translation, matcher);
    });

    test(
        'test translation of a task based goal into a descriptive string, start and end on different days.',
        () {
      DateTime from = DateTime(2019, 07, 02);
      DateTime to = DateTime(2019, 07, 04);

      final testTimeGoal = Goal(
          skillId: 1,
          fromDate: from.millisecondsSinceEpoch,
          toDate: to.millisecondsSinceEpoch,
          isComplete: false,
          timeBased: false,
          goalTime: 0,
          desc: 'Practice practice practice');

      String matcher =
          "Goal: Practice practice practice between Jul 2 and Jul 4.";
      String translation = sut.translateGoal(testTimeGoal);

      expect(translation, matcher);
    });

    test(
        'test translation of a task based goal into a descriptive string, start and end on same day.',
        () {
      DateTime from = DateTime(2019, 07, 02);
      DateTime to = DateTime(2019, 07, 02);

      final testTimeGoal = Goal(
          skillId: 1,
          fromDate: from.millisecondsSinceEpoch,
          toDate: to.millisecondsSinceEpoch,
          isComplete: false,
          timeBased: false,
          goalTime: 0,
          desc: 'Practice practice practice');

      String matcher = "Goal: Practice practice practice on Jul 2.";
      String translation = sut.translateGoal(testTimeGoal);

      expect(translation, matcher);
    });
  });
}
