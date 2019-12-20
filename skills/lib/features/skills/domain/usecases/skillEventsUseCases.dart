import 'package:dartz/dartz.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
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

class GetEventByIdUC extends UseCase<SkillEvent, SkillEventGetOrDeleteParams> {
  final SkillEventRepository repo;

  GetEventByIdUC(this.repo);
  @override
  Future<Either<Failure, SkillEvent>> call(SkillEventGetOrDeleteParams params) async {
    return await repo.getEventById(params.eventId);
  }
}

class DeleteEventByIdUC
    extends UseCase<int, SkillEventGetOrDeleteParams> {
  final SkillEventRepository repo;

  DeleteEventByIdUC(this.repo);
  @override
  Future<Either<Failure, int>> call(SkillEventGetOrDeleteParams params) async {
    return await repo.deleteEventById(params.eventId);
  }
}

class UpdateSkillEventUC
    extends UseCase<int, SkillEventInsertOrUpdateParams> {
  final SkillEventRepository repo;

  UpdateSkillEventUC(this.repo);

  @override
  Future<Either<Failure, int>> call(
      SkillEventInsertOrUpdateParams params) async {
    return await repo.updateEvent(params.event);
  }
}
