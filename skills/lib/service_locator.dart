import 'package:get_it/get_it.dart';
import 'package:skills/features/skills/data/repos/skillEventRepositoryImpl.dart';
import 'package:skills/features/skills/domain/repos/goal_repo.dart';
import 'package:skills/features/skills/domain/repos/session_repo.dart';
import 'package:skills/features/skills/domain/repos/skillEvent_repo.dart';
import 'package:skills/features/skills/domain/usecases/goalUseCases.dart';
import 'package:skills/features/skills/presentation/bloc/new_session/bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skillDataScreen/skilldata_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_bloc.dart';
import 'features/skills/data/datasources/skillsLocalDataSource.dart';
import 'features/skills/data/repos/goalsRepositoryImpl.dart';
import 'features/skills/data/repos/sessionsRepositoryImpl.dart';
import 'features/skills/data/repos/skillsRepositoryImpl.dart';
import 'features/skills/domain/repos/skill_repo.dart';
import 'features/skills/domain/usecases/skillUseCases.dart';
import 'features/skills/domain/usecases/sessionUseCases.dart';
import 'features/skills/domain/usecases/skillEventsUseCases.dart';
import 'features/skills/presentation/bloc/goalEditorScreen/goaleditor_bloc.dart';
import 'features/skills/presentation/bloc/newGoalScreen/newgoal_bloc.dart';
import 'features/skills/presentation/bloc/newSkillScreen/newskill_bloc.dart';
import 'features/skills/presentation/bloc/schedulerScreen/scheduler_bloc.dart';
import 'features/skills/presentation/bloc/sessionDataScreen/sessiondata_bloc.dart';
import 'features/skills/presentation/pages/sessionDataScreen.dart';

final locator = GetIt.instance;

void init() {
  //// Features - Skills
  // Blocs

  locator.registerFactory(() => SkillsBloc(getAllSkills: locator()));

  locator.registerFactory(() => NewskillBloc(insertNewSkillUC: locator()));

  locator.registerFactory(() => SkillDataBloc(
      getCompletedEventsForSkill: locator(),
      updateSkill: locator(),
      getSkillById: locator(),
      getSkillGoalMapById: locator()));

  locator.registerFactory(() => GoaleditorBloc(
      updateGoalUC: locator(),
      deleteGoalWithId: locator(),
      getGoalById: locator()));

  locator.registerFactory(() => NewgoalBloc(
        insertNewGoalUC: locator(),
        addGoalToSkill: locator(),
      ));

  locator.registerFactory(() => NewSessionBloc(insertNewSession: locator()));

  locator.registerFactory(() => SessiondataBloc(
      updateAndRefreshSessionWithId: locator(),
      deleteSessionWithId: locator(),
      getEventMapsForSession: locator(),
      insertEventsForSession: locator(),
      // completeSessionAndEvents: locator(),
      deleteEventByIdUC: locator()));

  locator.registerFactory(() => SchedulerBloc(
      getSessionsInDateRange: locator(),
      getEventsForSession: locator(),
      getMapsForSessionsInDateRange: locator()));

  locator.registerFactory(() => SessionDataScreen(bloc: locator()));

  // UseCases - can be singletons because they have no state, no streams etc.
  locator.registerLazySingleton(() => GetAllSkills(locator()));
  // locator.registerLazySingleton(() => GetAllSkillsInfoMaps(locator()));
  locator.registerLazySingleton(() => GetSkillById(locator()));
  locator.registerLazySingleton(() => GetSkillGoalMapById(locator()));
  locator.registerLazySingleton(() => InsertNewSkill(locator()));
  locator.registerLazySingleton(() => UpdateSkill(locator()));
  locator.registerLazySingleton(() => DeleteSkillWithId(locator()));

  locator.registerLazySingleton(() => UpdateGoal(locator()));
  locator.registerLazySingleton(() => GetGoalById(locator()));
  locator.registerLazySingleton(() => DeleteGoalWithId(locator()));

  locator.registerLazySingleton(() => InsertNewGoal(locator()));
  locator.registerLazySingleton(() => AddGoalToSkill(locator()));

  locator.registerLazySingleton(() => InsertNewSession(locator()));
  locator.registerLazySingleton(() => GetSessionsInDateRange(locator()));
  locator.registerLazySingleton(() => GetMapsForSessionsInDateRange(locator()));
  locator.registerLazySingleton(() => UpdateSessionWithId(locator()));
  locator.registerLazySingleton(() => UpdateAndRefreshSessionWithId(locator()));
  locator.registerLazySingleton(() => DeleteSessionWithId(locator()));

  locator.registerLazySingleton(() => InsertNewSkillEventUC(locator()));
  locator.registerLazySingleton(() => InsertEventsForSessionUC(locator()));
  locator.registerLazySingleton(() => GetEventByIdUC(locator()));
  locator.registerLazySingleton(() => UpdateSkillEventUC(locator()));
  locator.registerLazySingleton(() => DeleteEventByIdUC(locator()));
  locator.registerLazySingleton(() => GetEventsForSession(locator()));
  locator.registerLazySingleton(() => GetCompletedEventsForSkill(locator()));
  locator.registerLazySingleton(() => GetEventMapsForSession(locator()));
  locator.registerLazySingleton(() => CompleteSessionAndEvents(locator()));
  // locator.registerLazySingleton(() => GetSkillInfoForEvent(locator(), locator()));

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
