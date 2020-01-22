import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/data/models/goalModel.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/usecases/goalUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import './bloc.dart';
// import 'goalEditor_event.dart';
// import 'goalEditor_state.dart';
// import 'goaleditor_event.dart';

class GoaleditorBloc extends Bloc<GoalEditorEvent, GoalEditorState> {
  final UpdateGoal updateGoalUC;
  final DeleteGoalWithId deleteGoalWithId;
  final GetGoalById getGoalById;
  Goal theGoal;
  GoalModel goalModel;
  String goalTranslation = 'none';

  GoaleditorBloc({this.updateGoalUC, this.deleteGoalWithId, this.getGoalById});

  @override
  GoalEditorState get initialState => EmptyGoalEditorState();

  bool goalIsChanged(Map changeMap) {
    bool response = false;
    Map goalMap = goalModel.toMap();
    changeMap.forEach((key, value) {
      if (value != goalMap[key]) {
        response = true;
      }
    });

    return response;
  }

  @override
  Stream<GoalEditorState> mapEventToState(
    GoalEditorEvent event,
  ) async* {
    // get goal
    if (event is GetGoalEvent) {
      yield GoalCrudInProgressState();
      final failureOrGoal = await getGoalById(GoalCrudParams(id: event.goalId));
      yield failureOrGoal.fold(
          (failure) => GoalEditorErrorState(CACHE_FAILURE_MESSAGE), (goal) {
        theGoal = goal;
        goalModel = GoalModel(
            skillId: goal.skillId,
            fromDate: goal.fromDate,
            toDate: goal.toDate,
            timeBased: goal.timeBased,
            isComplete: false,
            goalTime: goal.goalTime,
            timeRemaining: goal.goalTime,
            desc: goal.desc != null ? goal.desc : "");
        return GoalEditorGoalReturnedState(goal: goal);
      }); 

      // edit Goal
    } else if (event is EditGoalEvent) {
      yield GoalEditorEditingState(goal: theGoal);
    }
    // update goal
    else if (event is UpdateGoalEvent) {
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

  String createDurationString(DateTime from, DateTime to) {
    String durationString;

    // final fromDate = DateTime.fromMillisecondsSinceEpoch(from);
    final fromString = DateFormat.MMMd().format(from);
    if (from == to) {
      durationString = 'on $fromString';
    } else {
      final toString = DateFormat.MMMd().format(to);
      durationString = 'between $fromString and $toString';
    }
    return durationString;
  }
}
