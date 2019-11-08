import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:skills/core/error/failures.dart';

/* used to allow all UseCases to have a call(), which makes having
  something like an execute() redundant
*/

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => null;
}

class Params extends Equatable {
  // final Skill skill;

  // Params({@required this.skill}) : super();

  @override
  // TODO: implement props
  List<Object> get props => null;
}
