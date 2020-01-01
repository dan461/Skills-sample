import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import '../../mockClasses.dart';

void main() {
  DeleteSessionWithId sut;
  MockSessionRepo mockSessionRepo;

  setUp(() {
    mockSessionRepo = MockSessionRepo();
    sut = DeleteSessionWithId(mockSessionRepo);
  });

  test('should return 0 after successful delete of a session', () async {
    when(mockSessionRepo.deleteSessionById(1))
        .thenAnswer((_) async => Right(0));
    final result = await sut(SessionDeleteParams(sessionId: 1));
    expect(result, Right(0));
    verify(mockSessionRepo.deleteSessionById(1));
    verifyNoMoreInteractions(mockSessionRepo);
  });
}
