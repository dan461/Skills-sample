import 'package:get_it/get_it.dart';
import 'package:skills/features/skills/presentation/bloc/newSkillScreen/new_skill_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_bloc.dart';
import 'features/skills/data/datasources/skillsLocalDataSource.dart';
import 'features/skills/data/repos/skillsRepositoryImpl.dart';
import 'features/skills/domain/repos/skill_repo.dart';
import 'features/skills/domain/usecases/getAllSkills.dart';
import 'features/skills/domain/usecases/getSkillById.dart';
import 'features/skills/domain/usecases/insertNewSkill.dart';

final locator = GetIt.instance;

void init(){

  //// Features - Skills
    // Blocs
    // TODO - remove insertNewSkill parameter from SkillsBloc
    locator.registerFactory(() => SkillsBloc(getAllSkills: locator(), insertNewSkill: locator()));
    locator.registerFactory(() => NewSkillBloc(insertNewSkillUC: locator()));

    // UseCases - can be singletons because they have no state, no streams etc.
    locator.registerLazySingleton(() => GetAllSkills(locator()));
    locator.registerLazySingleton(() => GetSkillById(locator()));
    locator.registerLazySingleton(() => InsertNewSkill(locator()));

    // Repositories
    locator.registerLazySingleton<SkillRepository>(() => SkillsRepositoryImpl(
      localDataSource: locator()
    ));

    // Data Sources
    locator.registerLazySingleton<SkillsLocalDataSource>(() => SkillsLocalDataSourceImpl());

}