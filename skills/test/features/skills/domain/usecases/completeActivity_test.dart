import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/usecases/activityUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import '../../mockClasses.dart';

void main() {
  CompleteActivityUC sut;
  MockActivitiesRepo mockEventsRepo;

  setUp(() {
    mockEventsRepo = MockActivitiesRepo();
    sut = CompleteActivityUC(mockEventsRepo);
  });

  test('test that class returns an int after marking an event complete',
      () async {
    final Activity activity = Activity(
        eventId: 1,
        skillId: 1,
        sessionId: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        duration: 30,
        isComplete: false,
        skillString: 'test');

    when(mockEventsRepo.completeActivity(
            activity.eventId, activity.date, 30, activity.skillId))
        .thenAnswer((_) async => Right(1));
    final result = await sut(ActivityCompleteParams(
        activity.eventId, activity.date, 30, activity.skillId));
    expect(result, Right(1));
    verify(mockEventsRepo.completeActivity(
        activity.eventId, activity.date, 30, activity.skillId));
    verifyNoMoreInteractions(mockEventsRepo);
  });
}
