import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/usecases/getSessionWithId.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import '../../mockClasses.dart';

void main() {
  GetSessionWithId sut;
  MockSessionRepo mockSessionRepo;

  setUp(() {
    mockSessionRepo = MockSessionRepo();
    sut = GetSessionWithId(mockSessionRepo);
  });

  test('should return a session', () async {
final newSession = Session(
      sessionId: 1, date: DateTime.now(), startTime: TimeOfDay(hour: 12, minute: 0), endTime: TimeOfDay(hour: 12, minute: 0), isCompleted: false, isScheduled: true);

    when(mockSessionRepo.getSessionById(1))
        .thenAnswer((_) async => Right(newSession));
    final result = await sut(SessionByIdParams(sessionId: 1));
    expect(result, Right(newSession));
    verify(mockSessionRepo.getSessionById(1));
    verifyNoMoreInteractions(mockSessionRepo);
  });
}