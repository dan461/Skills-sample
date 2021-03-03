import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/usecases/activityUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import '../../mockClasses.dart';

void main() {
  InsertActivityForSessionUC sut;
  MockActivitiesRepo mockEventsRepo;

  setUp(() {
    mockEventsRepo = MockActivitiesRepo();
    sut = InsertActivityForSessionUC(mockEventsRepo);
  });

  test('test that class calls repo insertEvents()', () async {
    final Activity testEvent = Activity(
        skillId: 1,
        sessionId: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        duration: 30,
        isComplete: false,
        skillString: 'test');
    final events = [testEvent];
    final list = [1];
    when(mockEventsRepo.insertActivities(events, 1))
        .thenAnswer((_) async => Right(list));
    final result =
        await sut(ActivityMultiInsertParams(activities: events, newSessionId: 1));
    expect(result, Right(list));
    verify(mockEventsRepo.insertActivities(events, 1));
    verifyNoMoreInteractions(mockEventsRepo);
  });
}
