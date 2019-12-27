import 'package:get_it/get_it.dart';
import 'package:skills/features/skills/data/repos/skillEventRepositoryImpl.dart';
import 'package:skills/features/skills/domain/repos/goal_repo.dart';
import 'package:skills/features/skills/domain/repos/session_repo.dart';
import 'package:skills/features/skills/domain/repos/skillEvent_repo.dart';
import 'package:skills/features/skills/domain/usecases/getGoalById.dart';
import 'package:skills/features/skills/presentation/bloc/new_session/bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_bloc.dart';
import 'features/skills/data/datasources/skillsLocalDataSource.dart';
import 'features/skills/data/repos/goalsRepositoryImpl.dart';
import 'features/skills/data/repos/sessionsRepositoryImpl.dart';
import 'features/skills/data/repos/skillsRepositoryImpl.dart';
import 'features/skills/domain/repos/skill_repo.dart';
import 'features/skills/domain/usecases/addGoalToSkill.dart';
import 'features/skills/domain/usecases/deleteGoalWithId.dart';
import 'features/skills/domain/usecases/deleteSkillWithId.dart';
import 'features/skills/domain/usecases/getAllSkills.dart';
import 'features/skills/domain/usecases/getSkillById.dart';
import 'features/skills/domain/usecases/insertNewGoal.dart';
import 'features/skills/domain/usecases/insertNewSkill.dart';
import 'features/skills/domain/usecases/sessionsUseCases.dart';
import 'features/skills/domain/usecases/skillEventsUseCases.dart';
import 'features/skills/domain/usecases/updateGoal.dart';
import 'features/skills/domain/usecases/updateSkill.dart';
import 'features/skills/presentation/bloc/goalEditorScreen/goaleditor_bloc.dart';
import 'features/skills/presentation/bloc/newGoalScreen/newgoal_bloc.dart';
import 'features/skills/presentation/bloc/schedulerScreen/scheduler_bloc.dart';
import 'features/skills/presentation/bloc/skillEditorScreen/skilleditor_bloc.dart';

final locator = GetIt.instance;

void init() {
  //// Features - Skills
  // Blocs

  locator.registerFactory(() => SkillsBloc(getAllSkills: locator()));

  locator.registerFactory(() => SkillEditorBloc(
      insertNewSkillUC: locator(),
      updateSkill: locator(),
      getSkillById: locator(),
      deleteSkillWithId: locator()));

  locator.registerFactory(() => GoaleditorBloc(
      updateGoalUC: locator(),
      deleteGoalWithId: locator(),
      getGoalById: locator()));

  locator.registerFactory(() => NewgoalBloc(
        insertNewGoalUC: locator(),
        addGoalToSkill: locator(),
      ));

  locator.registerFactory(() => NewSessionBloc(
      insertNewSession: locator(), insertEventsForSessionUC: locator()));

  locator.registerFactory(() => SchedulerBloc(getSessionInMonth: locator()));

  // UseCases - can be singletons because they have no state, no streams etc.
  locator.registerLazySingleton(() => GetAllSkills(locator()));
  locator.registerLazySingleton(() => GetSkillById(locator()));
  locator.registerLazySingleton(() => InsertNewSkill(locator()));
  locator.registerLazySingleton(() => UpdateSkill(locator()));
  locator.registerLazySingleton(() => DeleteSkillWithId(locator()));

  locator.registerLazySingleton(() => UpdateGoal(locator()));
  locator.registerLazySingleton(() => GetGoalById(locator()));
  locator.registerLazySingleton(() => DeleteGoalWithId(locator()));

  locator.registerLazySingleton(() => InsertNewGoal(locator()));
  locator.registerLazySingleton(() => AddGoalToSkill(locator()));

  locator.registerLazySingleton(() => InsertNewSession(locator()));
  locator.registerLazySingleton(() => GetSessionsInMonth(locator()));

  locator.registerLazySingleton(() => InsertNewSkillEventUC(locator()));
  locator.registerLazySingleton(() => InsertEventsForSessionUC(locator()));
  locator.registerLazySingleton(() => GetEventByIdUC(locator()));
  locator.registerLazySingleton(() => UpdateSkillEventUC(locator()));
  locator.registerLazySingleton(() => DeleteEventByIdUC(locator()));

  // Repositories
  locator.registerLazySingleton<SkillRepository>(
      () => SkillsRepositoryImpl(localDataSource: locator()));
  locator.registerLazySingleton<GoalRepository>(
      () => GoalsRepositoryImpl(localDataSource: locator()));
  locator.registerLazySingleton<SessionRepository>(
      () => SessionsRepositoryImpl(localDataSource: locator()));
  locator.registerLazySingleton<SkillEventRepository>(
      () => SkillEventRepositoryImpl(localDataSource: locator()));

  // Data Sources
  locator.registerLazySingleton<SkillsLocalDataSource>(
      () => SkillsLocalDataSourceImpl());
}
