import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/usecases/addGoalToSkill.dart';
import 'package:skills/features/skills/domain/usecases/deleteGoalWithId.dart';
import 'package:skills/features/skills/domain/usecases/getGoalById.dart';
import 'package:skills/features/skills/domain/usecases/insertNewGoal.dart';
import 'package:skills/features/skills/domain/usecases/updateGoal.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import './bloc.dart';
import 'goalEditor_event.dart';
import 'goalEditor_state.dart';

class GoaleditorBloc extends Bloc<GoalEditorEvent, GoalEditorState> {
  final InsertNewGoal insertNewGoalUC;
  final UpdateGoal updateGoalUC;
  final AddGoalToSkill addGoalToSkill;
  final DeleteGoalWithId deleteGoalWithId;
  final GetGoalById getGoalById;
  Goal goal;
  String goalTranslation = 'none';

  GoaleditorBloc(
      {this.insertNewGoalUC,
      this.updateGoalUC,
      this.addGoalToSkill,
      this.deleteGoalWithId,
      this.getGoalById});

  @override
  GoalEditorState get initialState => EmptyGoalEditorState();

  @override
  Stream<GoalEditorState> mapEventToState(
    GoalEditorEvent event,
  ) async* {
    if (event is CreateNewGoalEvent) {
      yield GoalEditorCreatingState();
    } else if (event is EditGoalEvent) {
      yield GoalCrudInProgressState();
      final failureOrGoal = await getGoalById(GoalCrudParams(id: event.goalId));
      yield failureOrGoal.fold(
          (failure) => GoalEditorErrorState(CACHE_FAILURE_MESSAGE),
          (goal) => GoalEditorEditingState(goal: goal));
      // InsertNewGoal
    } else if (event is InsertNewGoalEvent) {
      yield GoalCrudInProgressState();
      final failureOrNewGoal =
          await insertNewGoalUC(GoalCrudParams(goal: event.newGoal));
      yield failureOrNewGoal.fold(
          (failure) => GoalEditorErrorState(CACHE_FAILURE_MESSAGE),
          (newGoal) => NewGoalInsertedState(newGoal));
      // AddGoalToSkill
    } else if (event is AddGoalToSkillEvent) {
      yield GoalCrudInProgressState();
      final failureOrNewId = await addGoalToSkill(AddGoalToSkillParams(
          skillId: event.skillId,
          goalId: event.goalId,
          goalText: event.goalText));
      yield failureOrNewId.fold(
          (failure) => GoalEditorErrorState(CACHE_FAILURE_MESSAGE),
          (newId) =>
              GoalAddedToSkillState(newId: newId, goalText: goalTranslation));
      // Update Goal
    } else if (event is UpdateGoalEvent) {
      yield GoalCrudInProgressState();
      final failureOrResult =
          await updateGoalUC(GoalCrudParams(goal: event.newGoal));
      yield failureOrResult.fold(
          (failure) => GoalEditorErrorState(CACHE_FAILURE_MESSAGE),
          (updates) => GoalUpdatedState(updates));
    }
    // Delete goal
    else if (event is DeleteGoalEvent) {
      yield GoalCrudInProgressState();
      final failureOrSuccess =
          await deleteGoalWithId(GoalCrudParams(id: event.goalId));
      yield failureOrSuccess.fold(
          (failure) => GoalEditorErrorState(CACHE_FAILURE_MESSAGE),
          (success) => GoalDeletedState(success));
    }
  }

  void insertNewGoal(
      {int startDate,
      int endDate,
      bool timeBased,
      int goalMinutes,
      int skillId,
      String desc}) async {
    Goal newGoal = Goal(
        skillId: skillId,
        fromDate: startDate,
        toDate: endDate,
        isComplete: false,
        timeBased: timeBased,
        goalTime: goalMinutes,
        desc: desc);
    add(InsertNewGoalEvent(newGoal));
    goalTranslation = translateGoal(newGoal);
  }

  String translateGoal(Goal goal) {
    String translation;
    final durationString = createDurationString(goal.fromDate, goal.toDate);

    if (goal.timeBased) {
      final timeString = createGoalTimeString(goal.goalTime);
      translation = 'Goal: $timeString $durationString.';
    } else {
      var desc = goal.desc;
      translation = 'Goal: $desc $durationString.';
    }

    return translation;
  }

  String createGoalTimeString(int time) {
    String timeString;

    String hours;
    String min;
    if (time < 60) {
      min = time.toString();
      timeString = '$min minutes';
    } else if (time == 60) {
      timeString = '1 hour';
    } else {
      hours = (time / 60).floor().toString();
      timeString = '$hours hrs';
      if (time % 60 != 0) {
        min = (time % 60).toString();
        timeString = '$hours hrs $min min';
      }
    }

    return timeString;
  }

  String createDurationString(int from, int to) {
    String durationString;

    final fromDate = DateTime.fromMillisecondsSinceEpoch(from);
    final fromString = DateFormat.MMMd().format(fromDate);
    if (from == to) {
      durationString = 'on $fromString';
    } else {
      final toDate = DateTime.fromMillisecondsSinceEpoch(to);
      final toString = DateFormat.MMMd().format(toDate);
      durationString = 'between $fromString and $toString';
    }
    return durationString;
  }
}
