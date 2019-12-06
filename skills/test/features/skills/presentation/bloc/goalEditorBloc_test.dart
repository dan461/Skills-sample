import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/usecases/addGoalToSkill.dart';
import 'package:skills/features/skills/domain/usecases/insertNewGoal.dart';
import 'package:skills/features/skills/domain/usecases/updateGoal.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/goalEditorScreen/bloc.dart';
import 'package:skills/features/skills/presentation/bloc/goalEditorScreen/goalEditor_state.dart';

class MockInsertNewGoalUC extends Mock implements InsertNewGoal {}

class MockUpdateGoalUC extends Mock implements UpdateGoal {}

class MockAddGoalToSkill extends Mock implements AddGoalToSkill {}

void main() {
  GoaleditorBloc sut;
  MockInsertNewGoalUC mockInsertNewGoalUC;
  MockUpdateGoalUC mockUpdateGoalUC;
  MockAddGoalToSkill mockAddGoalToSkill;
  Goal testGoal;

  setUp(() {
    mockInsertNewGoalUC = MockInsertNewGoalUC();
    mockUpdateGoalUC = MockUpdateGoalUC();
    mockAddGoalToSkill = MockAddGoalToSkill();
    sut = GoaleditorBloc(
        insertNewGoalUC: mockInsertNewGoalUC,
        updateGoalUC: mockUpdateGoalUC,
        addGoalToSkill: mockAddGoalToSkill);

    testGoal = Goal(
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

  group('InsertNewGoal', () {
    test('test that InsertNewGoal usecase called', () async {
      when(mockInsertNewGoalUC(GoalCrudParams(id: null, goal: testGoal)))
          .thenAnswer((_) async => Right(1));
      sut.add(InsertNewGoalEvent(testGoal));
      await untilCalled(
          mockInsertNewGoalUC(GoalCrudParams(id: null, goal: testGoal)));
      verify(mockInsertNewGoalUC(GoalCrudParams(id: null, goal: testGoal)));
    });

    test(
        'test that bloc emits [GoalCrudInProgressState, NewGoalInsertedState] on successful insert',
        () async {
      when(mockInsertNewGoalUC(GoalCrudParams(id: null, goal: testGoal)))
          .thenAnswer((_) async => Right(1));
      final expected = [
        EmptyGoalEditorState(),
        GoalCrudInProgressState(),
        NewGoalInsertedState(1)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(InsertNewGoalEvent(testGoal));
    });
  });

  group('AddGoalToSkill', () {
    test('test that AddGoalToSkill is called', () async {
      when(mockAddGoalToSkill(AddGoalToSkillParams(skillId: 1, goalId: 1, goalText: 'goal')))
          .thenAnswer((_) async => Right(1));
      sut.add(AddGoalToSkillEvent(skillId: 1, goalId: 1, goalText: 'goal'));
      await untilCalled(
          mockAddGoalToSkill(AddGoalToSkillParams(skillId: 1, goalId: 1, goalText: 'goal')));
      verify(mockAddGoalToSkill(AddGoalToSkillParams(skillId: 1, goalId: 1, goalText: 'goal')));
    });

    test(
        'test that bloc emits [GoalCrudInProgressState, GoalAddedToSkillState] on successful add',
        () async {
      when(mockAddGoalToSkill(AddGoalToSkillParams(skillId: 1, goalId: 1, goalText: 'goal')))
          .thenAnswer((_) async => Right(1));
      final expected = [
        EmptyGoalEditorState(),
        GoalCrudInProgressState(),
        GoalAddedToSkillState(newId: 1, goalText: 'none')
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(AddGoalToSkillEvent(skillId: 1, goalId: 1, goalText: 'goal'));
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
