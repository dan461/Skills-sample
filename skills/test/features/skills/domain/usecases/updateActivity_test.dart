import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/usecases/activityUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import '../../mockClasses.dart';

void main() {
  UpdateActivityEventUC sut;
  MockActivitiesRepo mockEventsRepo;

  setUp(() {
    mockEventsRepo = MockActivitiesRepo();
    sut = UpdateActivityEventUC(mockEventsRepo);
  });

  test('test that class returns an int after updating an event', () async {
    Map<String, dynamic> changeMap = {'isCompleted': 1};

    when(mockEventsRepo.updateActivity(changeMap, 1))
        .thenAnswer((_) async => Right(1));
    final result = await sut(ActivityUpdateParams(changeMap, 1));
    expect(result, Right(1));
    verify(mockEventsRepo.updateActivity(changeMap, 1));
    verifyNoMoreInteractions(mockEventsRepo);
  });
}
