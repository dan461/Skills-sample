import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import '../../mockClasses.dart';

void main() {
  CompleteSessionAndEvents sut;
  MockSessionRepo mockSessionRepo;

  setUp(() {
    mockSessionRepo = MockSessionRepo();
    sut = CompleteSessionAndEvents(mockSessionRepo);
  });

  test(
      'test that class will return an int as response to setting Session to completed',
      () async {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(0);
    when(mockSessionRepo.completeSessionAndEvents(1, date))
        .thenAnswer((_) async => Right(1));
    final result = await sut(SessionCompleteParams(1, date));
    expect(result, Right(1));
    verify(mockSessionRepo.completeSessionAndEvents(1, date));
    verifyNoMoreInteractions(mockSessionRepo);
  });
}
