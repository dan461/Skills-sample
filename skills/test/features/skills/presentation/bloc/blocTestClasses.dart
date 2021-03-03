import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/core/usecase.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc/bloc.dart';

class UseCaseCalledTestFunction {
  UseCaseCalledTestFunction();

  Future<VerificationResult> call(
      {Bloc bloc,
      UseCase useCase,
      Params params,
      // BlocEvent event,
      Object response}) async {
    when(useCase(params)).thenAnswer((_) async => Right(response));
    // bloc.add(event);
    await untilCalled(useCase(params));

    return verify(useCase(params));
  }
}

class BlocEmitsStatesInOrderTest {
  BlocEmitsStatesInOrderTest();

  Future<void> call({
    Bloc bloc,
    UseCase useCase,
    Params params,
    List expectedStates,
    // BlocEvent event,
    Either<Failure, int> response,
  }) async {
    when(useCase(params)).thenAnswer((_) async => response);
    expectLater(bloc, emitsInOrder(expectedStates));
    // bloc.add(event);
  }
}
