import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/usecases/sessionsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

import '../../mockClasses.dart';

void main() {
  GetSessionsInMonth sut;
  MockSessionRepo mockSessionRepo;

  setUp(() {
    mockSessionRepo = MockSessionRepo();
    sut = GetSessionsInMonth(mockSessionRepo);
  });

  test(
      'UseCase should return a List<Session>',
      () async {
    final testSession = Session(
        date: 1,
        startTime: 1,
        endTime: 1,
        isCompleted: false,
        isScheduled: true);

    final testMonth = DateTime(2019, 12);
    final testList = [testSession];
    when(mockSessionRepo.getSessionsInMonth(testMonth))
        .thenAnswer((_) async => Right(testList));
    final result = await sut(SessionInMonthParams(testMonth));
    expect(result, Right(testList));
    verify(mockSessionRepo.getSessionsInMonth(testMonth));
    verifyNoMoreInteractions(mockSessionRepo);
  });
}
