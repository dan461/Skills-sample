import 'package:dartz/dartz.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/domain/repos/session_repo.dart';

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
