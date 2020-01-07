import 'package:dartz/dartz.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/repos/session_repo.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';



class InsertNewSession extends UseCase<Session, SessionInsertOrUpdateParams> {
  final SessionRepository repo;

  InsertNewSession(this.repo);

  @override
  Future<Either<Failure, Session>> call(SessionInsertOrUpdateParams params) {
    return repo.insertNewSession(params.session);
  }
}

class GetSessionsInMonth extends UseCase<List<Session>, SessionInMonthParams> {
  final SessionRepository repo;

  GetSessionsInMonth(this.repo);

  @override
  Future<Either<Failure, List<Session>>> call(SessionInMonthParams params) {
    return repo.getSessionsInMonth(params.month);
  }
}

class GetSessionWithId extends UseCase<Session, SessionByIdParams> {
  final SessionRepository repo;

  GetSessionWithId(this.repo);
  @override
  Future<Either<Failure, Session>> call(SessionByIdParams params) async {
    return await repo.getSessionById(params.sessionId);
  }
}

class UpdateSessionWithId extends UseCase<int, SessionUpdateParams> {
  final SessionRepository repo;

  UpdateSessionWithId(this.repo);
  @override
  Future<Either<Failure, int>> call(SessionUpdateParams params) {
    
    return null;
  }

}

class DeleteSessionWithId extends UseCase<int, SessionDeleteParams> {
  final SessionRepository repo;

  DeleteSessionWithId(this.repo);
  @override
  Future<Either<Failure, int>> call(SessionDeleteParams params) async {
    return await repo.deleteSessionById(params.sessionId);
  }
}
