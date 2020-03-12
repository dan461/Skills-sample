import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

import '../../mockClasses.dart';

void main() {
  GetSessionsInDateRange sut;
  MockSessionRepo mockSessionRepo;

  setUp(() {
    mockSessionRepo = MockSessionRepo();
    sut = GetSessionsInDateRange(mockSessionRepo);
  });

  test('UseCase should return a List<Session>', () async {
    final testSession = Session(
        date: DateTime.now(),
        startTime: TimeOfDay(hour: 12, minute: 0),
        isComplete: false,
        isScheduled: true);

    final dates = [DateTime(2019, 12, 29), DateTime(2020, 1, 1)];
    final testList = [testSession];
    when(mockSessionRepo.getSessionsInDateRange(dates.first, dates.last))
        .thenAnswer((_) async => Right(testList));
    final result = await sut(SessionsInDateRangeParams(dates));
    expect(result, Right(testList));
    verify(mockSessionRepo.getSessionsInDateRange(dates.first, dates.last));
    verifyNoMoreInteractions(mockSessionRepo);
  });
}
