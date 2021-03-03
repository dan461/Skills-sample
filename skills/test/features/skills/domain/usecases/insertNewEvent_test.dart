import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/usecases/activityUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

import '../../mockClasses.dart';

void main() {
  InsertNewActivityUC sut;
  MockActivitiesRepo mockActivitiesRepo;

  setUp(() {
    mockActivitiesRepo = MockActivitiesRepo();
    sut = InsertNewActivityUC(mockActivitiesRepo);
  });

  test('test that class inserts a new event and returns a new event with an id',
      () async {
    final Activity testEvent = Activity(
        skillId: 1,
        sessionId: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        duration: 30,
        isComplete: false,
        skillString: 'test');

    final Activity newEvent = Activity(
        eventId: 1,
        skillId: 1,
        sessionId: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        duration: 30,
        isComplete: false,
        skillString: 'test');

    when(mockActivitiesRepo.insertNewActivity(testEvent))
        .thenAnswer((_) async => Right(newEvent));
    final result = await sut(ActivityInsertOrUpdateParams(activity: testEvent));
    expect(result, Right(newEvent));
    verify(mockActivitiesRepo.insertNewActivity(testEvent));
    verifyNoMoreInteractions(mockActivitiesRepo);
  });
}
