import 'package:mockito/mockito.dart';
import 'package:skills/core/network/networkInfo.dart';
import 'package:skills/features/skills/data/datasources/skillsLocalDataSource.dart';
import 'package:skills/features/skills/data/datasources/skillsRemoteDataSource.dart';
import 'package:skills/features/skills/domain/repos/goal_repo.dart';
import 'package:skills/features/skills/domain/repos/session_repo.dart';
import 'package:skills/features/skills/domain/repos/skillEvent_repo.dart';
import 'package:skills/features/skills/domain/repos/skill_repo.dart';
import 'package:skills/features/skills/domain/usecases/addGoalToSkill.dart';
import 'package:skills/features/skills/domain/usecases/deleteGoalWithId.dart';
import 'package:skills/features/skills/domain/usecases/deleteSessionWithId.dart';
import 'package:skills/features/skills/domain/usecases/deleteSkillWithId.dart';
import 'package:skills/features/skills/domain/usecases/getAllSkills.dart';
import 'package:skills/features/skills/domain/usecases/getSessionWithId.dart';
import 'package:skills/features/skills/domain/usecases/getSkillById.dart';
import 'package:skills/features/skills/domain/usecases/insertNewGoal.dart';
import 'package:skills/features/skills/domain/usecases/insertNewSkill.dart';
import 'package:skills/features/skills/domain/usecases/sessionsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/updateGoal.dart';
import 'package:skills/features/skills/domain/usecases/updateSkill.dart';
import 'package:skills/features/skills/presentation/bloc/skillEditorScreen/bloc.dart';

class MockLocalDataSource extends Mock implements SkillsLocalDataSource {}

class MockRemoteDataSource extends Mock implements SkillsRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockSkillsRepo extends Mock implements SkillRepository {}

class MockGoalRepo extends Mock implements GoalRepository {}

class MockSessionRepo extends Mock implements SessionRepository {}

class MockUpdateGoalUC extends Mock implements UpdateGoal {}

class MockDeleteGoalWithId extends Mock implements DeleteGoalWithId {}

class MockInsertNewGoalUC extends Mock implements InsertNewGoal {}

class MockAddGoalToSkill extends Mock implements AddGoalToSkill {}

class MockInsertNewSkillUC extends Mock implements InsertNewSkill {}

class MockUpdateSkillUC extends Mock implements UpdateSkill {}

class MockDeleteSkillUC extends Mock implements DeleteSkillWithId {}

class MockGetSkillByIdUC extends Mock implements GetSkillById {}

class MockGetAllSkillsUC extends Mock implements GetAllSkills {}

class MockGetSkillById extends Mock implements GetSkillById {}

class MockInsertNewSessionUC extends Mock implements InsertNewSession {}

class MockGetSessionWithIdUC extends Mock implements GetSessionWithId {}

class MockDeleteSessionWithIdUC extends Mock implements DeleteSessionWithId {}

class MockGetSessionsInMonthUC extends Mock implements GetSessionsInMonth {}

class MockEventsRepo extends Mock implements SkillEventRepository {}

class MockInsertNewEventUC extends Mock implements InsertNewSkillEventUC {}

class MockGetEventByIdUC extends Mock implements GetEventByIdUC {}

class MockDeleteEventByIdUC extends Mock implements DeleteEventByIdUC {}

class MockUpdateEventUC extends Mock implements UpdateSkillEventUC {}



