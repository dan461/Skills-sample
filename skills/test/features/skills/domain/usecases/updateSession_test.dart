import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import '../../mockClasses.dart';

void main() {
  UpdateSessionWithId sut;
  MockSessionRepo mockSessionRepo;

  setUp(() {
    mockSessionRepo = MockSessionRepo();
    sut = UpdateSessionWithId(mockSessionRepo);
  });

  test(
      'test that class will return an int as a response after updating a Session',
      () async {
    Map<String, dynamic> changeMap = {};
    when(mockSessionRepo.updateSession(changeMap, 1))
        .thenAnswer((_) async => Right(1));
    final result =
        await sut(SessionUpdateParams(changeMap: changeMap, sessionId: 1));
    expect(result, Right(1));
    verify(mockSessionRepo.updateSession(changeMap, 1));
    verifyNoMoreInteractions(mockSessionRepo);
  });
}
