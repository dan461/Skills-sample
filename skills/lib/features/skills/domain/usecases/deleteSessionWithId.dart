import 'package:dartz/dartz.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/repos/session_repo.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

class DeleteSessionWithId extends UseCase<int, SessionDeleteParams> {
  final SessionRepository repo;

  DeleteSessionWithId(this.repo);
  @override
  Future<Either<Failure, int>> call(SessionDeleteParams params) async {
    return await repo.deleteSessionById(params.sessionId);
  }
}
