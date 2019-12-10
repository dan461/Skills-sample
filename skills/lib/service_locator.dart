import 'package:get_it/get_it.dart';
import 'package:skills/features/skills/domain/repos/goal_repo.dart';
import 'package:skills/features/skills/domain/usecases/getGoalById.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_bloc.dart';
import 'features/skills/data/datasources/skillsLocalDataSource.dart';
import 'features/skills/data/repos/goalsRepositoryImpl.dart';
import 'features/skills/data/repos/skillsRepositoryImpl.dart';
import 'features/skills/domain/repos/skill_repo.dart';
import 'features/skills/domain/usecases/addGoalToSkill.dart';
import 'features/skills/domain/usecases/deleteGoalWithId.dart';
import 'features/skills/domain/usecases/deleteSkillWithId.dart';
import 'features/skills/domain/usecases/getAllSkills.dart';
import 'features/skills/domain/usecases/getSkillById.dart';
import 'features/skills/domain/usecases/insertNewGoal.dart';
import 'features/skills/domain/usecases/insertNewSkill.dart';
import 'features/skills/domain/usecases/updateGoal.dart';
import 'features/skills/domain/usecases/updateSkill.dart';
import 'features/skills/presentation/bloc/goalEditorScreen/goalEditor_bloc.dart';
import 'features/skills/presentation/bloc/newGoalScreen/newgoal_bloc.dart';
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

  // Repositories
  locator.registerLazySingleton<SkillRepository>(
      () => SkillsRepositoryImpl(localDataSource: locator()));
  locator.registerLazySingleton<GoalRepository>(
      () => GoalsRepositoryImpl(localDataSource: locator()));

  // Data Sources
  locator.registerLazySingleton<SkillsLocalDataSource>(
      () => SkillsLocalDataSourceImpl());
}
