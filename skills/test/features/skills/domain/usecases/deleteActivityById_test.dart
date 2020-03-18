import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/usecases/activityUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import '../../mockClasses.dart';

void main() {
  DeleteActivityByIdUC sut;
  MockActivitiesRepo mockEventsRepo;

  setUp(() {
    mockEventsRepo = MockActivitiesRepo();
    sut = DeleteActivityByIdUC(mockEventsRepo);
  });

  test('test that class returns an int after updating an event', () async {
    when(mockEventsRepo.deleteActivityById(1)).thenAnswer((_) async => Right(1));
    final result = await sut(ActivityGetOrDeleteParams(activityId: 1));
    expect(result, Right(1));
    verify(mockEventsRepo.deleteActivityById(1));
    verifyNoMoreInteractions(mockEventsRepo);
  });
}
