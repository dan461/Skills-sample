import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

import '../../mockClasses.dart';

void main() {
  InsertNewSession sut;
  MockSessionRepo mockSessionRepo;

  setUp(() {
    mockSessionRepo = MockSessionRepo();
    sut = InsertNewSession(mockSessionRepo);
  });

  final testSession = Session(
      date: DateTime.now(),
      startTime: TimeOfDay(hour: 12, minute: 0),
      isComplete: false,
      isScheduled: true);
  final newSession = Session(
      sessionId: 1,
      date: DateTime.now(),
      startTime: TimeOfDay(hour: 12, minute: 0),
      isComplete: false,
      isScheduled: true);

  test('should insert a new session and return a session with an id', () async {
    when(mockSessionRepo.insertNewSession(testSession))
        .thenAnswer((_) async => Right(newSession));
    final result = await sut(SessionInsertOrUpdateParams(session: testSession));
    expect(result, Right(newSession));
    verify(mockSessionRepo.insertNewSession(testSession));
    verifyNoMoreInteractions(mockSessionRepo);
  });
}
