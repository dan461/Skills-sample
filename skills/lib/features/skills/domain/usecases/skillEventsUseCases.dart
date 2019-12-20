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
      SkillEventInsertOrUpdateParams params) {
    return repo.insertNewEvent(params.event);
  }
}

class GetEventByIdUC extends UseCase<SkillEvent, SkillEventGetOrDeleteParams> {

  final int eventId;

  GetEventByIdUC(this.eventId);
  @override
  Future<Either<Failure, SkillEvent>> call(SkillEventGetOrDeleteParams params) {
    // TODO: implement call
    return null;
  }
  
}

class DeleteEventByIdUC extends UseCase<SkillEvent, SkillEventGetOrDeleteParams> {

  final int eventId;

  DeleteEventByIdUC(this.eventId);
  @override
  Future<Either<Failure, SkillEvent>> call(SkillEventGetOrDeleteParams params) {
    // TODO: implement call
    return null;
  }
  
}

class UpdateSkillEventUC
    extends UseCase<SkillEvent, SkillEventInsertOrUpdateParams> {
  final SkillEventRepository repo;

  UpdateSkillEventUC(this.repo);

  @override
  Future<Either<Failure, SkillEvent>> call(
      SkillEventInsertOrUpdateParams params) {
    return null;
  }
}
