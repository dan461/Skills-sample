import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/usecases/activityUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';

import '../../mockClasses.dart';

void main() {
  GetActivityByIdUC sut;
  MockActivitiesRepo mockEventsRepo;

  setUp(() {
    mockEventsRepo = MockActivitiesRepo();
    sut = GetActivityByIdUC(mockEventsRepo);
  });

  test('test that class returns an activity with given id', () async {
    final Activity event = Activity(
        eventId: 1,
        skillId: 1,
        sessionId: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        duration: 30,
        isComplete: false,
        skillString: 'test');

    when(mockEventsRepo.getActivityById(1))
        .thenAnswer((_) async => Right(event));
    final result = await sut(ActivityGetOrDeleteParams(activityId: 1));
    expect(result, Right(event));
    verify(mockEventsRepo.getActivityById(1));
    verifyNoMoreInteractions(mockEventsRepo);
  });
}
