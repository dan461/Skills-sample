import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/usecases/addGoalToSkill.dart';
import 'package:skills/features/skills/domain/usecases/insertNewGoal.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import './bloc.dart';

class NewgoalBloc extends Bloc<NewgoalEvent, NewgoalState> {
final InsertNewGoal insertNewGoalUC;
final AddGoalToSkill addGoalToSkill;

Goal goal;
  String goalTranslation = 'none';

  NewgoalBloc({this.insertNewGoalUC, this.addGoalToSkill});


  @override
  NewgoalState get initialState => InitialNewgoalState();

  @override
  Stream<NewgoalState> mapEventToState(
    NewgoalEvent event,
  ) async* {
    if (event is InsertNewGoalEvent){
      yield NewGoalInsertingState();
      final failureOrNewGoal =
          await insertNewGoalUC(GoalCrudParams(goal: event.newGoal));
      yield failureOrNewGoal.fold(
          (failure) => NewGoalErrorState(CACHE_FAILURE_MESSAGE),
          (newGoal) => NewGoalInsertedState(newGoal));
    } else if (event is AddGoalToSkillEvent){
      yield AddingGoalToSkillState();
      final failureOrNewId = await addGoalToSkill(AddGoalToSkillParams(
          skillId: event.skillId,
          goalId: event.goalId,
          goalText: event.goalText));
      yield failureOrNewId.fold(
          (failure) => NewGoalErrorState(CACHE_FAILURE_MESSAGE),
          (newId) =>
              GoalAddedToSkillState(newId: newId, goalText: goalTranslation));
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
