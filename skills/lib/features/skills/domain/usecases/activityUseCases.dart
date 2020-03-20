import 'package:dartz/dartz.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/repos/activity_repo.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

class InsertNewActivityUC
    extends UseCase<Activity, ActivityInsertOrUpdateParams> {
  final ActivityRepository repo;

  InsertNewActivityUC(this.repo);

  @override
  Future<Either<Failure, Activity>> call(
      ActivityInsertOrUpdateParams params) async {
    return await repo.insertNewActivity(params.activity);
  }
}

// TODO - this is set up to add multiple events at a time, which is no longer done. Change to add single event
class InsertActivityForSessionUC
    extends UseCase<void, ActivityMultiInsertParams> {
  final ActivityRepository repo;

  InsertActivityForSessionUC(this.repo);
  @override
  Future<Either<Failure, List<int>>> call(
      ActivityMultiInsertParams params) async {
    return await repo.insertActivities(params.activities, params.newSessionId);
  }
}

class GetActivityByIdUC extends UseCase<Activity, ActivityGetOrDeleteParams> {
  final ActivityRepository repo;

  GetActivityByIdUC(this.repo);
  @override
  Future<Either<Failure, Activity>> call(
      ActivityGetOrDeleteParams params) async {
    return await repo.getActivityById(params.activityId);
  }
}

class DeleteActivityByIdUC extends UseCase<int, ActivityGetOrDeleteParams> {
  final ActivityRepository repo;

  DeleteActivityByIdUC(this.repo);
  @override
  Future<Either<Failure, int>> call(ActivityGetOrDeleteParams params) async {
    return await repo.deleteActivityById(params.activityId);
  }
}

class UpdateActivityEventUC extends UseCase<int, ActivityUpdateParams> {
  final ActivityRepository repo;

  UpdateActivityEventUC(this.repo);

  @override
  Future<Either<Failure, int>> call(ActivityUpdateParams params) async {
    return await repo.updateActivity(params.changeMap, params.activityId);
  }
}

class GetActivitiesForSession
    extends UseCase<List<Activity>, SessionByIdParams> {
  final ActivityRepository repo;

  GetActivitiesForSession(this.repo);
  @override
  Future<Either<Failure, List<Activity>>> call(SessionByIdParams params) async {
    return await repo.getActivitiesForSession(params.sessionId);
  }
}

class GetCompletedActivitiesForSkill
    extends UseCase<List<Activity>, GetSkillParams> {
  final ActivityRepository repo;

  GetCompletedActivitiesForSkill(this.repo);

  @override
  Future<Either<Failure, List<Activity>>> call(GetSkillParams params) async {
    return await repo.getCompletedActivitiesForSkill(params.id);
  }
}

class GetActivitiesWithSkillsForSession extends UseCase<List<Activity>, SessionByIdParams>{
  final ActivityRepository repo;

  GetActivitiesWithSkillsForSession(this.repo);

  @override
  Future<Either<Failure, List<Activity>>> call(SessionByIdParams params) {
    return repo.getActivitiesWithSkillsForSession(params.sessionId);
  }
}

class GetActivityMapsForSession extends UseCase<List<Map>, SessionByIdParams> {
  final ActivityRepository repo;

  GetActivityMapsForSession(this.repo);
  @override
  Future<Either<Failure, List<Map>>> call(SessionByIdParams params) async {
    // Either<Failure, List<Map>> maps;
    // List<SkillEvent> theEvents = [];
    // final events = await repo.getEventsForSession(params.sessionId);
    // events.fold((failure) => NewSessionErrorState(CACHE_FAILURE_MESSAGE),
    //     (eventsList) {
    //   theEvents = eventsList;
    // });
    // maps = await repo.getInfoForEvents(theEvents);
    // use getInfoForEvents - return List<Map> with Skill and Goal, make new Map with that list

    return await repo.getActivityMapsForSession(params.sessionId);
  }
}

// class GetSkillInfoForEvent
//     extends UseCase<Map<String, dynamic>, GetSkillParams> {
//   final GetSkillById getSkillById;
//   final GetGoalById getGoalById;

//   GetSkillInfoForEvent(this.getSkillById, this.getGoalById);
//   @override
//   Future<Either<Failure, Map<String, dynamic>>> call(
//       GetSkillParams params) async {
//     Skill theSkill;
//     Goal currentGoal;
//     final skillOrFail = await getSkillById(params);
//     skillOrFail.fold((failure) => CacheFailure(), (skill) {
//       theSkill = skill;
//     });

//     if (theSkill != null && theSkill.currentGoalId != 0) {
//       final goalOrFail =
//           await getGoalById(GoalCrudParams(id: theSkill.currentGoalId));
//       goalOrFail.fold((failure) => CacheFailure(), (goal) {
//         currentGoal = goal;
//       });
//     }

//     return Right({'skill': theSkill, 'goal': currentGoal});
//   }
// }
