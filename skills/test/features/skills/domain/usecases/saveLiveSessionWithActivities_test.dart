import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

import '../../mockClasses.dart';

void main() {
  SaveLiveSessionWithActivities sut;
  MockSessionRepo mockSessionRepo;
  Session testSession;
  List<Activity> testList;

  setUp(() {
    mockSessionRepo = MockSessionRepo();
    sut = SaveLiveSessionWithActivities(mockSessionRepo);

    testSession = Session(
        date: DateTime.now(),
        startTime: TimeOfDay(hour: 12, minute: 0),
        isComplete: false,
        isScheduled: true);

    final Activity testActivity = Activity(
        skillId: 1,
        sessionId: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        duration: 30,
        isComplete: false,
        skillString: 'test');
    testList = [testActivity];
  });

  test(
      'saveSessionWithActivities - should insert new session and activities with new seesion id',
      () async {
    when(mockSessionRepo.saveLiveSessionWithActivities(testSession, testList))
        .thenAnswer((_) async => Right(1));
    final result = await sut(
        LiveSessionParams(session: testSession, activities: testList));
        expect(result, Right(1));
        verify(mockSessionRepo.saveLiveSessionWithActivities(testSession, testList));
        verifyNoMoreInteractions(mockSessionRepo);
  });
}
