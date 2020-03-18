import 'package:mockito/mockito.dart';
import 'package:skills/core/network/networkInfo.dart';
import 'package:skills/features/skills/data/datasources/skillsLocalDataSource.dart';
import 'package:skills/features/skills/data/datasources/skillsRemoteDataSource.dart';
import 'package:skills/features/skills/domain/repos/goal_repo.dart';
import 'package:skills/features/skills/domain/repos/session_repo.dart';
import 'package:skills/features/skills/domain/repos/activity_repo.dart';
import 'package:skills/features/skills/domain/repos/skill_repo.dart';
import 'package:skills/features/skills/domain/usecases/goalUseCases.dart';
import 'package:skills/features/skills/domain/usecases/skillUseCases.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/activityUseCases.dart';
import 'package:skills/features/skills/presentation/widgets/CalendarWidgets/calendarControl.dart';

class MockLocalDataSource extends Mock implements SkillsLocalDataSource {}

class MockRemoteDataSource extends Mock implements SkillsRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockSkillsRepo extends Mock implements SkillRepository {}

class MockGoalRepo extends Mock implements GoalRepository {}

class MockSessionRepo extends Mock implements SessionRepository {}

class MockUpdateGoalUC extends Mock implements UpdateGoal {}

class MockGetGoalById extends Mock implements GetGoalById {}

class MockDeleteGoalWithId extends Mock implements DeleteGoalWithId {}

class MockInsertNewGoalUC extends Mock implements InsertNewGoal {}

class MockAddGoalToSkill extends Mock implements AddGoalToSkill {}

class MockInsertNewSkillUC extends Mock implements InsertNewSkill {}

class MockUpdateSkillUC extends Mock implements UpdateSkill {}

class MockDeleteSkillUC extends Mock implements DeleteSkillWithId {}

class MockGetSkillByIdUC extends Mock implements GetSkillById {}

class MockGetSkillGoalMapById extends Mock implements GetSkillGoalMapById {}

class MockGetAllSkillsUC extends Mock implements GetAllSkills {}

class MockGetSkillById extends Mock implements GetSkillById {}

class MockInsertNewSessionUC extends Mock implements InsertNewSession {}

class MockGetSessionWithIdUC extends Mock implements GetSessionWithId {}

class MockDeleteSessionWithIdUC extends Mock implements DeleteSessionWithId {}

class MockGetSessionsInDateRange extends Mock
    implements GetSessionsInDateRange {}

class MockGetMapsForSessionsInDateRange extends Mock
    implements GetMapsForSessionsInDateRange {}

class MockActivitiesRepo extends Mock implements ActivityRepository {}

class MockinsertNewActivityUC extends Mock implements InsertNewActivityUC {}

class MockGetActivityByIdUC extends Mock implements GetActivityByIdUC {}

class MockGetCompletedActivitiesForSkill extends Mock
    implements GetCompletedActivitiesForSkill {}

class MockDeleteActivityByIdUC extends Mock implements DeleteActivityByIdUC {}

class MockUpdateActivityUC extends Mock implements UpdateActivityEventUC {}

class MockInsertActivitiesForSessionUC extends Mock
    implements InsertActivityForSessionUC {}

class MockGetActivitiesForSessionUC extends Mock
    implements GetActivitiesForSession {}

class MockGetActivityMapsForSession extends Mock
    implements GetActivityMapsForSession {}

class MockUpdateSessionWithId extends Mock implements UpdateSessionWithId {}

class MockUpdateAndRefreshSessionWithId extends Mock
    implements UpdateAndRefreshSessionWithId {}

class MockDeleteSessionWithId extends Mock implements DeleteSessionWithId {}

class MockCompleteSessionAndEvents extends Mock
    implements CompleteSessionAndEvents {}

class MockCalendarControl extends Mock implements CalendarControl {}
