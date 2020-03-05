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

class GetSessionsInDateRange
    extends UseCase<List<Session>, SessionsInDateRangeParams> {
  final SessionRepository repo;

  GetSessionsInDateRange(this.repo);

  @override
  Future<Either<Failure, List<Session>>> call(
      SessionsInDateRangeParams params) {
    return repo.getSessionsInDateRange(params.dates.first, params.dates.last);
  }
}

class GetMapsForSessionsInDateRange
    extends UseCase<List<Map>, SessionsInDateRangeParams> {
  final SessionRepository repo;

  GetMapsForSessionsInDateRange(this.repo);

  @override
  Future<Either<Failure, List<Map>>> call(SessionsInDateRangeParams params) {
    return repo.getSessionMapsInDateRange(
        params.dates.first, params.dates.last);
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
    return repo.updateSession(params.changeMap, params.sessionId);
  }
}

class UpdateAndRefreshSessionWithId extends UseCase<Session, SessionUpdateParams> {
  final SessionRepository repo;

  UpdateAndRefreshSessionWithId(this.repo);
  @override
  Future<Either<Failure, Session>> call(SessionUpdateParams params) {
    return repo.updateAndRefreshSession(params.changeMap, params.sessionId);
  }
}

class CompleteSessionAndEvents extends UseCase<int, SessionCompleteParams> {
  final SessionRepository repo;

  CompleteSessionAndEvents(this.repo);
  @override
  Future<Either<Failure, int>> call(SessionCompleteParams params) {
    return repo.completeSessionAndEvents(params.sessionId, params.date);
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
