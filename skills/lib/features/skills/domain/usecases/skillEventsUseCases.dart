import 'package:dartz/dartz.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/repos/skillEvent_repo.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

class InsertNewSkillEventUC
    extends UseCase<SkillEvent, SkillEventInsertOrUpdateParams> {
  final SkillEventRepository repo;

  InsertNewSkillEventUC(this.repo);

  @override
  Future<Either<Failure, SkillEvent>> call(
      SkillEventInsertOrUpdateParams params) async {
    return await repo.insertNewEvent(params.event);
  }
}

class InsertEventsForSessionUC
    extends UseCase<void, SkillEventMultiInsertParams> {
  final SkillEventRepository repo;

  InsertEventsForSessionUC(this.repo);
  @override
  Future<Either<Failure, List<int>>> call(
      SkillEventMultiInsertParams params) async {
    return await repo.insertEvents(params.events, params.newSessionId);
  }
}

class GetEventByIdUC extends UseCase<SkillEvent, SkillEventGetOrDeleteParams> {
  final SkillEventRepository repo;

  GetEventByIdUC(this.repo);
  @override
  Future<Either<Failure, SkillEvent>> call(
      SkillEventGetOrDeleteParams params) async {
    return await repo.getEventById(params.eventId);
  }
}

class DeleteEventByIdUC extends UseCase<int, SkillEventGetOrDeleteParams> {
  final SkillEventRepository repo;

  DeleteEventByIdUC(this.repo);
  @override
  Future<Either<Failure, int>> call(SkillEventGetOrDeleteParams params) async {
    return await repo.deleteEventById(params.eventId);
  }
}

class UpdateSkillEventUC extends UseCase<int, SkillEventUpdateParams> {
  final SkillEventRepository repo;

  UpdateSkillEventUC(this.repo);

  @override
  Future<Either<Failure, int>> call(SkillEventUpdateParams params) async {
    return await repo.updateEvent(params.changeMap, params.eventId);
  }
}

class GetEventsForSession extends UseCase<List<SkillEvent>, SessionByIdParams> {
  final SkillEventRepository repo;

  GetEventsForSession(this.repo);
  @override
  Future<Either<Failure, List<SkillEvent>>> call(
      SessionByIdParams params) async {
    return await repo.getEventsForSession(params.sessionId);
  }
}

class GetCompletedEventsForSkill
    extends UseCase<List<SkillEvent>, GetSkillParams> {
  final SkillEventRepository repo;

  GetCompletedEventsForSkill(this.repo);

  @override
  Future<Either<Failure, List<SkillEvent>>> call(GetSkillParams params) async {
    return await repo.getCompletedActivitiesForSkill(params.id);
  }
}

class GetEventMapsForSession extends UseCase<List<Map>, SessionByIdParams> {
  final SkillEventRepository repo;

  GetEventMapsForSession(this.repo);
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

    return await repo.getEventMapsForSession(params.sessionId);
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
