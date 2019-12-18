import 'package:dartz/dartz.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/repos/session_repo.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

class GetSessionWithId extends UseCase<Session, SessionByIdParams> {
  final SessionRepository repo;

  GetSessionWithId(this.repo);
  @override
  Future<Either<Failure, Session>> call(SessionByIdParams params) async {
    return await repo.getSessionById(params.sessionId);
  }
}