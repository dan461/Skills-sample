import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/flutter_test.dart' as prefix0;
import 'package:mockito/mockito.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/data/models/goalModel.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/goalEditorScreen/bloc.dart';

import '../../mockClasses.dart';

void main() {
  GoaleditorBloc sut;
  // MockInsertNewGoalUC mockInsertNewGoalUC;
  MockUpdateGoalUC mockUpdateGoalUC;
  // MockAddGoalToSkill mockAddGoalToSkill;
  MockDeleteGoalWithId mockDeleteGoalWithId;
  Goal testGoal;

  GoalModel testModel;

  setUp(() {
    // mockInsertNewGoalUC = MockInsertNewGoalUC();
    mockUpdateGoalUC = MockUpdateGoalUC();
    // mockAddGoalToSkill = MockAddGoalToSkill();
    mockDeleteGoalWithId = MockDeleteGoalWithId();
    sut = GoaleditorBloc(
        updateGoalUC: mockUpdateGoalUC, deleteGoalWithId: mockDeleteGoalWithId);

    testGoal = Goal(
        skillId: 1,
        fromDate: DateTime.now(),
        toDate: DateTime.now(),
        isComplete: false,
        timeBased: true,
        timeRemaining: 0,
        goalTime: 0);

    testModel = GoalModel(
        skillId: testGoal.skillId,
        fromDate: testGoal.fromDate,
        toDate: testGoal.toDate,
        timeBased: true,
        isComplete: false,
        goalTime: 60,
        timeRemaining: 60,
        desc: testGoal.desc != null ? testGoal.desc : "");
  });

  test(
      'test for bloc emitting [GoalEditorEditingState] in response to an EditGoalEvent',
      () async {
    final expected = [GoalEditorEditingState(goal: testGoal)];
    sut.theGoal = testGoal;
    sut.add(EditGoalEvent());
    expect(sut, emitsInOrder(expected));
    // sut.add(EditGoalEvent());
  });

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
      final expected = [GoalCrudInProgressState(), GoalDeletedState(0)];
      expectLater(sut, emitsInOrder(expected));
      sut.add(DeleteGoalEvent(1));
    });

    test(
        'test that bloc emits [GoalCrudInProgressState, GoalEditorErrorState] upon unsuccessful delete',
        () async {
      when(mockDeleteGoalWithId(GoalCrudParams(id: 1)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
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
      final expected = [GoalCrudInProgressState(), GoalUpdatedState(1)];
      expectLater(sut, emitsInOrder(expected));
      sut.add(UpdateGoalEvent(testGoal));
    });

    test(
        'test that bloc emits [GoalCrudInProgressState, GoalEditorErrorState] upon unsuccessful update',
        () async {
      when(mockUpdateGoalUC(GoalCrudParams(id: null, goal: testGoal)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        GoalCrudInProgressState(),
        GoalEditorErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(UpdateGoalEvent(testGoal));
    });
  });

  group(
      'test comparing user inputs to existing goal to detect changes to be updated: ',
      () {
    test('test that goalIsChanged returns true when user makes a change',
        () async {
      sut.goalModel = testModel;
      Map testMap = {'fromDate': 1};
      bool response = sut.goalIsChanged(testMap);
      expect(response, true);
    });

    test(
        'test that goalIsChanged returns false when user inputs match current goal values, or goal has not been changed',
        () async {
      sut.goalModel = testModel;
      Map testMap = {'fromDate': testModel.fromDate.millisecondsSinceEpoch};
      bool response = sut.goalIsChanged(testMap);
      expect(response, false);
    });
  });

  // group('testing translation of a goal to a descriptive string', () {
  //   test(
  //       'test translation of a time based goal into a descriptive string, with hours and minutes.',
  //       () {
  //     DateTime from = DateTime(2019, 07, 02);
  //     DateTime to = DateTime(2019, 07, 04);

  //     final testTimeGoal = Goal(
  //         skillId: 1,
  //         fromDate: from,
  //         toDate: to,
  //         isComplete: false,
  //         timeBased: true,
  //         goalTime: 330);

  //     String matcher = "Goal: 5 hrs 30 min between Jul 2 and Jul 4.";
  //     String translation = sut.translateGoal(testTimeGoal);

  //     expect(translation, matcher);
  //   });

  //   test(
  //       'test translation of a time based goal into a descriptive string, with one hour and no minutes.',
  //       () {
  //     DateTime from = DateTime(2019, 07, 02);
  //     DateTime to = DateTime(2019, 07, 04);

  //     final testTimeGoal = Goal(
  //         skillId: 1,
  //         fromDate: from,
  //         toDate: to,
  //         isComplete: false,
  //         timeBased: true,
  //         goalTime: 60);

  //     String matcher = "Goal: 1 hour between Jul 2 and Jul 4.";
  //     String translation = sut.translateGoal(testTimeGoal);

  //     expect(translation, matcher);
  //   });

  // test(
  //     'test translation of a time based goal into a descriptive string, with less than one hour.',
  //     () {
  //   DateTime from = DateTime(2019, 07, 02);
  //   DateTime to = DateTime(2019, 07, 04);

  //   final testTimeGoal = Goal(
  //       skillId: 1,
  //       fromDate: from,
  //       toDate: to,
  //       isComplete: false,
  //       timeBased: true,
  //       goalTime: 15);

  //   String matcher = "Goal: 15 minutes between Jul 2 and Jul 4.";
  //   String translation = sut.translateGoal(testTimeGoal);

  //   expect(translation, matcher);
  // });

  // test(
  //     'test translation of a time based goal with multiple hours and zero minutes into a descriptive string.',
  //     () {
  //   DateTime from = DateTime(2019, 07, 02);
  //   DateTime to = DateTime(2019, 07, 04);

  //   final testTimeGoal = Goal(
  //       skillId: 1,
  //       fromDate: from,
  //       toDate: to,
  //       isComplete: false,
  //       timeBased: true,
  //       goalTime: 120);

  //   String matcher = "Goal: 2 hrs between Jul 2 and Jul 4.";
  //   String translation = sut.translateGoal(testTimeGoal);

  //   expect(translation, matcher);
  // });

  // test(
  //     'test translation of a time based goal into a descriptive string, start and end on same day.',
  //     () {
  //   DateTime from = DateTime(2019, 07, 02);
  //   DateTime to = DateTime(2019, 07, 02);

  //   final testTimeGoal = Goal(
  //       skillId: 1,
  //       fromDate: from,
  //       toDate: to,
  //       isComplete: false,
  //       timeBased: true,
  //       goalTime: 90);

  //   String matcher = "Goal: 1 hrs 30 min on Jul 2.";
  //   String translation = sut.translateGoal(testTimeGoal);

  //   expect(translation, matcher);
  // });

  // test(
  //     'test translation of a task based goal into a descriptive string, start and end on different days.',
  //     () {
  //   DateTime from = DateTime(2019, 07, 02);
  //   DateTime to = DateTime(2019, 07, 04);

  //   final testTimeGoal = Goal(
  //       skillId: 1,
  //       fromDate: from,
  //       toDate: to,
  //       isComplete: false,
  //       timeBased: false,
  //       goalTime: 0,
  //       desc: 'Practice practice practice');

  //   String matcher =
  //       "Goal: Practice practice practice between Jul 2 and Jul 4.";
  //   String translation = sut.translateGoal(testTimeGoal);

  //   expect(translation, matcher);
  // });

  // test(
  //     'test translation of a task based goal into a descriptive string, start and end on same day.',
  //     () {
  //   DateTime from = DateTime(2019, 07, 02);
  //   DateTime to = DateTime(2019, 07, 02);

  //   final testTimeGoal = Goal(
  //       skillId: 1,
  //       fromDate: from,
  //       toDate: to,
  //       isComplete: false,
  //       timeBased: false,
  //       goalTime: 0,
  //       desc: 'Practice practice practice');

  //   String matcher = "Goal: Practice practice practice on Jul 2.";
  //   String translation = sut.translateGoal(testTimeGoal);

  //   expect(translation, matcher);
  // });
  // });
}
