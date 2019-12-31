import 'package:dartz/dartz.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/repos/skillEvent_repo.dart';
import 'package:skills/features/skills/domain/usecases/getGoalById.dart';
import 'package:skills/features/skills/domain/usecases/getSkillById.dart';
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
  Future<Either<Failure, List<int>>> call(SkillEventMultiInsertParams params) {
    return repo.insertEvents(params.events, params.newSessionId);
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

class UpdateSkillEventUC extends UseCase<int, SkillEventInsertOrUpdateParams> {
  final SkillEventRepository repo;

  UpdateSkillEventUC(this.repo);

  @override
  Future<Either<Failure, int>> call(
      SkillEventInsertOrUpdateParams params) async {
    return await repo.updateEvent(params.event);
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


